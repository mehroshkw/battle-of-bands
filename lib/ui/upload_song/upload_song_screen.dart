import 'package:battle_of_bands/backend/server_response.dart';
import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/ui/upload_song/upload_song_bloc.dart';
import 'package:battle_of_bands/ui/upload_song/upload_song_state.dart';
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
        snackbarHelper.showSnackbar(snackbar: SnackbarMessage.error(message: response.message));
        return;
      }
      snackbarHelper.showSnackbar(snackbar: SnackbarMessage.success(message: AppText.SONG_UPLOADED));
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showMaterialDialogWithContent(MaterialDialogContent.networkError(), () {
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
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  bloc.pickFile();
                  // bloc.toggleVote();
                },
                child: BlocBuilder<UploadSongBloc, UploadSongState>(builder: (_, state) {
                  return Container(
                    height: size.height / 8,
                    width: size.width,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/add_song.png'),
                          fit: BoxFit.fill,
                        ),
                        color: Constants.scaffoldColor),
                    child: Text(
                      state.isShowTrim ? AppText.SONG_NAME_MP : AppText.UPLOAD_AUDIO_FILE,
                      style: const TextStyle(fontFamily: Constants.montserratBold, color: Constants.colorOnSurface, fontSize: 18),
                    ),
                  );
                }),
              ),
              BlocBuilder<UploadSongBloc, UploadSongState>(builder: (_, state) {
                return state.isShowTrim
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              AppText.UPLOAD_DESCRIPTION,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: Constants.montserratBold, color: Constants.colorOnSurface.withOpacity(0.6), fontSize: 14),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(AppText.TRIM_FILE,
                                textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 16, color: Constants.colorOnPrimary)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Image.asset('assets/record_slider.png'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppText.SONG_START,
                                style: TextStyle(
                                  fontFamily: Constants.montserratLight,
                                  color: Constants.colorOnSurface.withOpacity(0.7),
                                ),
                              ),
                              Text(
                                AppText.SONG_END_TIME,
                                style: TextStyle(
                                  fontFamily: Constants.montserratLight,
                                  color: Constants.colorOnSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox();
              }),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(AppText.SONG_TITLE,
                    textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 16, color: Constants.colorOnPrimary)),
              ),
              BlocBuilder<UploadSongBloc, UploadSongState>(
                builder: (_, state) => SizedBox(
                  width: size.width,
                  height: 70,
                  child: AppTextField(
                    hint: AppText.Enter_SONG_TITLE,
                    textInputType: TextInputType.emailAddress,
                    controller: bloc.songTitleController,
                    onChanged: (String? value) {
                      if (value == null) return;
                      if (value.isNotEmpty && state.nameError) bloc.updateNameError(false, '');
                    },
                    isError: state.nameError,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(AppText.SONG_GENRE,
                    textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 16, color: Constants.colorOnPrimary)),
              ),
              SizedBox(
                width: size.width,
                height: 70,
                child: BlocBuilder<UploadSongBloc, UploadSongState>(builder: (_, state) {
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
                                      )),
                                ),
                              ))
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
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Constants.colorOnSurface,
                        size: 20,
                      ),
                    ),
                  );
                }),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(AppText.PERFORMER_BAND_,
                    textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 16, color: Constants.colorOnPrimary)),
              ),
              BlocBuilder<UploadSongBloc, UploadSongState>(
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
                        bloc.updatebBandNameError(false, '');
                      }
                    },
                    isError: state.bandNameError,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(AppText.EXTERNAL_URL,
                    textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 16, color: Constants.colorOnPrimary)),
              ),
              BlocBuilder<UploadSongBloc, UploadSongState>(
                builder: (_, state) => SizedBox(
                  width: size.width,
                  height: 70,
                  child: AppTextField(
                    hint: AppText.URL,
                    controller: bloc.urlController,
                    textInputType: TextInputType.emailAddress,
                    isError: false,
                  ),
                ),
              ),
              BlocBuilder<UploadSongBloc, UploadSongState>(
                  buildWhen: (previous, current) => previous.errorText != current.errorText,
                  builder: (_, state) {
                    if (state.errorText.isEmpty) return const SizedBox();
                    return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                        margin: const EdgeInsets.only(bottom: 20, top: 15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Constants.colorError)),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                          const Icon(Icons.warning_amber_rounded, color: Constants.colorError),
                          const SizedBox(width: 5),
                          Text(state.errorText, style: const TextStyle(color: Constants.colorError, fontFamily: Constants.montserratRegular, fontSize: 14))
                        ]));
                  }),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: size.width - 30,
                height: 50,
                child: AppButton(
                  text: AppText.UPLOAD,
                  onClick: () {
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
                      bloc.updatebBandNameError(true, AppText.BANDNAME_EMPTY);
                      return;
                    }
                    _uploadSong(bloc, context, MaterialDialogHelper.instance());
                  },
                  color: Constants.colorPrimary,
                ),
              )
            ],
          ),
        ));
  }
}
