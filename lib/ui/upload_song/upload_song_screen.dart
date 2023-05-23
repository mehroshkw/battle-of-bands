import 'dart:io';

import 'package:battle_of_bands/backend/server_response.dart';
import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/ui/upload_song/upload_song_bloc.dart';
import 'package:battle_of_bands/ui/upload_song/upload_song_state.dart';
import 'package:easy_audio_trimmer/easy_audio_trimmer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/app_button.dart';
import '../../common/app_text_field.dart';
import '../../common/custom_appbar.dart';
import '../../data/snackbar_message.dart';
import '../../helper/dilogue_helper.dart';
import '../../helper/material_dialogue_content.dart';
import '../../helper/snackbar_helper.dart';
import '../../util/app_strings.dart';
import '../../util/constants.dart';

class UploadSongScreen extends StatelessWidget {
  static const String route = '/upload_song_screen';

  const UploadSongScreen({Key? key}) : super(key: key);



  Future<void> _uploadSong(UploadSongBloc bloc, BuildContext context, MaterialDialogHelper dialogHelper) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(AppText.UPLOADING_SONG);
    try {
      final response = await bloc.uploadSong();
      dialogHelper.dismissProgress();
      final snackbarHelper = SnackbarHelper.instance..injectContext(context);
      if (response!.status == false && response.songs == null) {
        snackbarHelper.showSnackbar(
            snackbar: SnackbarMessage.error(message: response.message));
        return;
      }
      snackbarHelper.showSnackbar(
          snackbar: SnackbarMessage.success(message: AppText.SONG_UPLOADED));
      bloc.trimmerDispose();
      Navigator.pop(context, response.songs);
    } catch (e, s) {
      print("e: $e, s: $s");
      dialogHelper.dismissProgress();
      dialogHelper.showMaterialDialogWithContent(
          MaterialDialogContent.networkError(), () {
        _uploadSong(bloc, context, dialogHelper);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UploadSongBloc>();
    final size = context.screenSize;



    return Scaffold(
        appBar: const CustomAppbar(
          screenName: AppText.UPLOAD_SONG,
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              GestureDetector(
                onTap: () async {
                  if (bloc.state.file.path.isNotEmpty) return;
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: Platform.isAndroid ? FileType.audio : FileType.any,
                    allowCompression: false,
                  );
                  if (result == null) return;
                  bloc.updateFilePath(result.files.single.path);
                },
                child: BlocBuilder<UploadSongBloc, UploadSongState>(
                    buildWhen: (previous, current) =>
                        previous.file != current.file,
                    builder: (_, state) {
                      return Container(
                          padding: const EdgeInsets.all(10.0),
                          height: size.height / 8,
                          width: size.width,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/add_song.png'),
                                fit: BoxFit.fill,
                              ),
                              color: Constants.scaffoldColor),
                          child: Text(state.isLoading ? state.file.path : AppText.UPLOAD_AUDIO_FILE,
                              style: const TextStyle(fontFamily: Constants.montserratBold, color: Constants.colorOnSurface, fontSize: 18)));
                    }),
              ),
              BlocBuilder<UploadSongBloc, UploadSongState>(
                  // buildWhen: (previous, current) => previous.file != current.file || previous.isLoading != current.isLoading,
                  builder: (_, state) {
                return state.file.path.isEmpty
                    ? const SizedBox()
                    : state.isLoading
                        ? const CircularProgressIndicator.adaptive(backgroundColor: Constants.colorPrimary)
                        : Column(children: [
                            Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(AppText.UPLOAD_DESCRIPTION,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: Constants.montserratBold, color: Constants.colorOnSurface.withOpacity(0.6), fontSize: 14))),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(AppText.TRIM_FILE,
                                    textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 16, color: Constants.colorOnPrimary))),
                            Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TrimViewer(
                                    trimmer: bloc.trimmer,
                                    viewerHeight: 50.0,
                                    viewerWidth: MediaQuery.of(context).size.width,
                                    // maxAudioLength: const Duration(minutes: 10),
                                    onChangeStart: (value) => bloc.start = value,
                                    onChangeEnd: (value) => bloc.end = value,
                                    backgroundColor: Constants.colorTextLight,
                                    barColor: Constants.colorOnSurface,
                                    durationStyle: DurationStyle.FORMAT_MM_SS,
                                    durationTextStyle: const TextStyle(
                                      fontFamily: Constants.montserratLight,
                                      color: Constants.colorText,
                                    ),
                                    paddingFraction: 4,
                                    allowAudioSelection: true,
                                    areaProperties: TrimAreaProperties.edgeBlur(blurEdges: true, blurColor: Constants.colorPrimary, borderRadius: 3),
                                    editorProperties: const TrimEditorProperties(
                                      circleSize: 0,
                                      borderPaintColor: Constants.colorPrimary,
                                      borderWidth: 2,
                                      borderRadius: 5,
                                      scrubberPaintColor: Constants.colorPrimary,
                                      circlePaintColor: Constants.colorPrimary,
                                    )))
                          ]);
              }),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(AppText.SONG_TITLE,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: Constants.montserratMedium,
                        fontSize: 16,
                        color: Constants.colorOnPrimary)),
              ),
              BlocBuilder<UploadSongBloc, UploadSongState>(
                  buildWhen: (previous, current) =>
                      previous.nameError != current.nameError,
                  builder: (_, state) => SizedBox(
                      width: size.width,
                      height: 70,
                      child: AppTextField(
                        hint: AppText.Enter_SONG_TITLE,
                        textInputType: TextInputType.emailAddress,
                        controller: bloc.songTitleController,
                        onChanged: (String? value) {
                          if (value == null) return;
                          if (value.isNotEmpty && state.nameError)
                            bloc.updateNameError(false, '');
                        },
                        isError: state.nameError,
                      ))),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(AppText.SONG_GENRE,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: Constants.montserratMedium,
                        fontSize: 16,
                        color: Constants.colorOnPrimary)),
              ),
              SizedBox(
                  width: size.width,
                  height: 70,
                  child: BlocBuilder<UploadSongBloc, UploadSongState>(
                      buildWhen: (p, c) => p.allGenre != c.allGenre,
                      builder: (_, state) {
                        return PopupMenuButton<Genre>(
                            enabled: true,
                            color: Constants.colorPrimaryVariant,
                            shadowColor: Colors.transparent,
                            splashRadius: 0,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            offset: const Offset(0, -20),
                            tooltip: '',
                            constraints: BoxConstraints(minWidth: size.width - 48),
                            position: PopupMenuPosition.under,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            itemBuilder: (context) {
                              return state.allGenre
                                  .map((Genre genre) => PopupMenuItem(
                                      value: genre,
                                      child: SizedBox(
                                          height: 20,
                                          child: Text(genre.title,
                                              style: const TextStyle(
                                                fontFamily: Constants.montserratMedium,
                                                fontSize: 15,
                                                color: Constants.colorOnPrimary,
                                              )))))
                                  .toList();
                            },
                            onSelected: (genre) => bloc.changeGenre(genre),
                            child: GenreField(
                                controller: bloc.genreController,
                                hint: AppText.GENRE,
                                readOnly: true,
                                textInputType: TextInputType.text,
                                onChanged: (String? value) {
                                  if (value == null) return;
                                  if (value.isNotEmpty && state.genreError) {
                                    bloc.updateGenreError(false, '');
                                  }
                                },
                                isError: state.genreError,
                                suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: Constants.colorOnSurface, size: 20)));
                      })),
              Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(AppText.PERFORMER_BAND_,
                      textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 16, color: Constants.colorOnPrimary))),
              BlocBuilder<UploadSongBloc, UploadSongState>(
                  buildWhen: (previous, current) =>
                      previous.bandNameError != current.bandNameError,
                  builder: (_, state) => SizedBox(
                      width: size.width,
                      height: 70,
                      child: AppTextField(
                          hint: AppText.ENTER_PERFROMER_BAND_NAME,
                          controller: bloc.bandNameController,
                          textInputType: TextInputType.text,
                          onChanged: (String? value) {
                            if (value == null) return;
                            if (value.isNotEmpty && state.bandNameError) {
                              bloc.updateBandNameError(false, '');
                            }
                          },
                          isError: state.bandNameError))),
              Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(AppText.EXTERNAL_URL,
                      textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 16, color: Constants.colorOnPrimary))),
              SizedBox(
                  width: size.width, height: 70, child: AppTextField(hint: AppText.URL, controller: bloc.urlController, textInputType: TextInputType.emailAddress, isError: false)),
              BlocBuilder<UploadSongBloc, UploadSongState>(
                  buildWhen: (previous, current) =>
                      previous.errorText != current.errorText,
                  builder: (_, state) {
                    if (state.errorText.isEmpty) return const SizedBox();
                    return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 7),
                        margin: const EdgeInsets.only(bottom: 20, top: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Constants.colorError)),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: Constants.colorError),
                              const SizedBox(width: 5),
                              Text(state.errorText,
                                  style: const TextStyle(
                                      color: Constants.colorError,
                                      fontFamily: Constants.montserratRegular,
                                      fontSize: 14))
                            ]));
                  }),
              const SizedBox(height: 20),
              SizedBox(
                  width: size.width - 30,
                  height: 50,
                  child: AppButton(
                    text: AppText.UPLOAD,
                    onClick: () {
                      FocusScope.of(context).unfocus();
                      final name = bloc.songTitleController.text;
                      final bandName = bloc.bandNameController.text;
                      final genre = bloc.genreController.text;
                      if (name.isEmpty) {
                        bloc.updateNameError(true, AppText.TITLE_EMPTY);
                        return;
                      }
                      if (genre.isEmpty) {
                        bloc.updateGenreError(true, AppText.GENRE_EMPTY);
                        return;
                      }
                      if (bandName.isEmpty) {
                        bloc.updateBandNameError(true, AppText.BANDNAME_EMPTY);
                        return;
                      }
                      _uploadSong(
                          bloc, context, MaterialDialogHelper.instance());
                    },
                    color: Constants.colorPrimary,
                  ))
            ])));
  }
}
