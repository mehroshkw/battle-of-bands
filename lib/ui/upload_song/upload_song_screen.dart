import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/ui/upload_song/upload_song_bloc.dart';
import 'package:battle_of_bands/ui/upload_song/upload_song_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/app_button.dart';
import '../../common/app_text_field.dart';
import '../../common/custom_appbar.dart';
import '../../util/app_strings.dart';
import '../../util/constants.dart';

class UploadSongScreen extends StatelessWidget {
  static const String route = '/upload_song_screen';

  const UploadSongScreen({Key? key}) : super(key: key);

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
                onTap: () {
                  bloc.toggleVote();
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
                    child:  Text(
                      state.isShowTrim
                          ? AppText.SONG_NAME_MP
                          : AppText.UPLOAD_AUDIO_FILE,
                      style: const TextStyle(
                          fontFamily: Constants.montserratBold,
                          color: Constants.colorOnSurface,
                          fontSize: 18),
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
                              style: TextStyle(
                                  fontFamily: Constants.montserratBold,
                                  color:
                                      Constants.colorOnSurface.withOpacity(0.6),
                                  fontSize: 14),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(AppText.TRIM_FILE,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: Constants.montserratMedium,
                                    fontSize: 16,
                                    color: Constants.colorOnPrimary)),
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
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: Constants.montserratMedium,
                        fontSize: 16,
                        color: Constants.colorOnPrimary)),
              ),
              SizedBox(
                width: size.width,
                height: 70,
                child: AppTextField(
                  hint: AppText.Enter_SONG_TITLE,
                  textInputType: TextInputType.emailAddress,
                  controller: bloc.songTitleController,
                  isError: false,
                ),
              ),
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
                    builder: (_, state) {
                  return PopupMenuButton<String>(
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
                      return ['Rock', 'Pop', 'Classic']
                          .map((String genre) => PopupMenuItem(
                                value: genre,
                                child: SizedBox(
                                  height: 20,
                                  child: Text(genre,
                                      style: const TextStyle(
                                        fontFamily: Constants.montserratMedium,
                                        fontSize: 15,
                                        color: Constants.colorOnPrimary,
                                      )),
                                ),
                              ))
                          .toList();
                    },
                    onSelected: (value) =>
                        bloc.genreController.text = value.toString(),
                    child: GenreField(
                      controller: bloc.genreController,
                      hint: AppText.GENRE,
                      readOnly: true,
                      textInputType: TextInputType.text,
                      isError: false,
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
                child: const Text(AppText.PERFORMER_BAND,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: Constants.montserratMedium,
                        fontSize: 16,
                        color: Constants.colorOnPrimary)),
              ),
              SizedBox(
                width: size.width,
                height: 70,
                child: AppTextField(
                  hint: AppText.ENTER_PERFROMER_BAND_NAME,
                  controller: bloc.bandNameController,
                  textInputType: TextInputType.emailAddress,
                  isError: false,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(AppText.EXTERNAL_URL,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: Constants.montserratMedium,
                        fontSize: 16,
                        color: Constants.colorOnPrimary)),
              ),
              SizedBox(
                width: size.width,
                height: 70,
                child: AppTextField(
                  hint: AppText.URL,
                  controller: bloc.urlController,
                  textInputType: TextInputType.emailAddress,
                  isError: false,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: size.width - 30,
                height: 50,
                child: AppButton(
                  text: AppText.UPLOAD,
                  onClick: () {
                    // Navigator.pushNamed(context, UploadSongScreen.route);
                  },
                  color: Constants.colorPrimary,
                ),
              )
            ],
          ),
        ));
  }
}
