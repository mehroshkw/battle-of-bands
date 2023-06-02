import 'package:battle_of_bands/common/app_button.dart';
import 'package:battle_of_bands/data/meta_data.dart';
import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/helper/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../backend/server_response.dart';
import '../../../common/app_text_field.dart';
import '../../../common/custom_appbar.dart';
import '../../../common/error_try_again.dart';
import '../../../helper/dilogue_helper.dart';
import '../../../util/app_strings.dart';
import '../../../util/constants.dart';
import '../main_bloc.dart';
import '../mian_state.dart';

class BattleScreen extends StatelessWidget {
  static const String key_title = '/battle_screen';

  const BattleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final bloc = context.read<MainScreenBloc>();

    return Column(children: [
      BlocListener<MainScreenBloc, MainScreenState>(
          listenWhen: (previous, current) => previous.snackbarMessage != current.snackbarMessage,
          listener: (_, state) async {
            final snackbarMessage = state.snackbarMessage;
            if (snackbarMessage.message.isEmpty) return;
            SnackbarHelper.instance
              ..injectContext(context)
              ..showSnackbar(snackbar: snackbarMessage);
          },
          child: const SizedBox(height: kToolbarHeight - 20)),
      AppBarWithGenre(
          screenName: AppText.BATTLES,
          genreField: BlocBuilder<MainScreenBloc, MainScreenState>(
              buildWhen: (previous, current) => previous.allGenre != current.allGenre,
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
                    constraints: BoxConstraints(minWidth: size.width - 25),
                    position: PopupMenuPosition.under,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    itemBuilder: (context) {
                      return state.allGenre
                          .map((Genre genre) => PopupMenuItem(
                              value: genre,
                              child: SizedBox(
                                height: 20,
                                child: Text(genre.title, style: const TextStyle(fontFamily: Constants.montserratMedium, fontSize: 15, color: Constants.colorOnPrimary)),
                              )))
                          .toList();
                    },
                    onSelected: (genre) => bloc.updateBattleByChangeGenreId(genre),
                    child: GenreField(
                        controller: bloc.battlesGenreController,
                        hint: AppText.GENRE,
                        readOnly: true,
                        textInputType: TextInputType.text,
                        isError: false,
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Constants.colorOnSurface,
                          size: 20,
                        )));
              })),
      Expanded(
          child: Container(
              width: size.width,
              height: size.height,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/battles_bg.png'), fit: BoxFit.cover)),
              child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: BlocBuilder<MainScreenBloc, MainScreenState>(
                          builder: (_, state) => state.isBeginBattle
                              ? BlocBuilder<MainScreenBloc, MainScreenState>(
                                  buildWhen: (previous, current) => previous.battleDataEvent != current.battleDataEvent,
                                  builder: (_, state) {
                                    final battleDataEvent = state.battleDataEvent;
                                    if (battleDataEvent is Loading) {
                                      return SizedBox(
                                          height: size.height / 1.5,
                                          child: const Center(child: CircularProgressIndicator(backgroundColor: Constants.colorPrimary, color: Constants.colorOnPrimary)));
                                    } else if (battleDataEvent is Empty || battleDataEvent is Initial) {
                                      return SizedBox(
                                          height: size.height / 2,
                                          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                            Image.asset('assets/no_music.png', height: 70, width: 70),
                                            const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(AppText.NO_SONG,
                                                    style: TextStyle(fontSize: 20, fontFamily: Constants.montserratRegular, color: Constants.colorOnSurface))),
                                            const SizedBox(height: 10),
                                            const Padding(
                                                padding: EdgeInsets.all(6.0),
                                                child: Text(AppText.SELECT_A_GENRE,
                                                    style: TextStyle(fontSize: 20, fontFamily: Constants.montserratRegular, color: Constants.colorOnSurface))),
                                            Text(
                                              AppText.BATTLE_TO_SHOW,
                                              style: TextStyle(fontSize: 14, fontFamily: Constants.montserratLight, color: Constants.colorOnSurface.withOpacity(0.8)),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 50)
                                          ]));
                                    } else if (battleDataEvent is Data) {
                                      final items = battleDataEvent.data as List<Song>;
                                      final song1 = items.first;
                                      final song2 = items.last;
                                      return Column(
                                        children: [
                                          SongWidget(
                                            song: song1,
                                            sliderValue: bloc.sliderValue(0),
                                            onClickCalled: () {
                                              MaterialDialogHelper.instance()
                                                ..injectContext(context)
                                                ..showVoteDialogue(
                                                    title: song1.title,
                                                    positiveClickListener: () {
                                                      bloc.voteBattleSong(song1, song2.id);
                                                    });
                                            },
                                            setUrl: () {
                                              // bloc.setSongUrl('$BASE_URL_DATA/${song1.fileUrl}', items.indexOf(song1));
                                              bloc.togglePlayPause(items.indexOf(song1), '$BASE_URL_DATA/${song1.fileUrl}');
                                            },
                                            // onNextSong: () => bloc.playNextSong(),
                                            // onPreviousSong: () => bloc.playPreviousSong(),
                                            index: items.indexOf(song1),
                                            songUrl: '$BASE_URL_DATA/${song1.fileUrl}',
                                          ),
                                          Image.asset('assets/vs_icon.png', height: 70, width: 70),
                                          SongWidget(
                                              song: song2,
                                              sliderValue: bloc.sliderValue(1),
                                              onClickCalled: () {
                                                MaterialDialogHelper.instance()
                                                  ..injectContext(context)
                                                  ..showVoteDialogue(
                                                      title: song2.title,
                                                      positiveClickListener: () {
                                                        bloc.voteBattleSong(song2, song1.id);
                                                      });
                                              },
                                              index: items.indexOf(song2),
                                              setUrl: () {
                                                bloc.togglePlayPause(items.indexOf(song2), '$BASE_URL_DATA/${song2.fileUrl}');
                                              },
                                              songUrl: '$BASE_URL_DATA/${song2.fileUrl}')
                                        ],
                                      );
                                    } else if (battleDataEvent is Error) {
                                      return SizedBox(
                                        height: size.height / 2,
                                        child: Center(
                                          child: ErrorTryAgain(
                                            margin: const EdgeInsets.symmetric(horizontal: 15),
                                            positiveClickListener: () => bloc.updateBattleByChangeGenreId,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  })
                              : SizedBox(
                                  height: size.height / 1.6,
                                  child: GestureDetector(
                                      onTap: () {
                                        if (bloc.battlesGenreController.text.isNotEmpty) {
                                          bloc.toggleBeginBattle();
                                        }
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Image.asset(bloc.battlesGenreController.text.isEmpty ? 'assets/begin_battle_dim.png' : 'assets/begin_battle.png',
                                              height: 250, width: 250, fit: BoxFit.contain)))))))))
    ]);
  }
}

class SongWidget extends StatelessWidget {
  final Function onClickCalled;
  final Function setUrl;
  final String songUrl;
  final Song song;
  final double sliderValue;
  final int index;

  const SongWidget({Key? key, required this.onClickCalled, required this.song, required this.sliderValue, required this.setUrl, required this.songUrl, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainScreenBloc>();
    final Size size = MediaQuery.of(context).size;

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        width: size.width - 30,
        decoration: BoxDecoration(color: Constants.colorTextLight, borderRadius: BorderRadius.circular(20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.max, children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 90,
                  width: 90,
                  child: Image.asset('assets/song_icon.png'),
                )),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => Share.share('Listen to this amazing song!\n$songUrl', subject: 'Check out this song!'),
                    child: Image.asset('assets/share.png', height: 30, width: 30),
                  )),
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 10),
                  child: Text(song.title,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontFamily: Constants.montserratBold, fontSize: 20, fontWeight: FontWeight.bold, color: Constants.colorOnPrimary))),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 10),
                      child: Text('${AppText.PERFORMER_BAND}${song.bandName}',
                          textAlign: TextAlign.left, style: const TextStyle(fontFamily: Constants.montserratLight, fontSize: 16, color: Constants.colorText))))
            ]))
          ]),
          Slider(
              value: sliderValue,
              onChanged: (value) {
                print('valueee of seekBar   $value');
              },
              onChangeStart: (value) {},
              onChangeEnd: (value) {
                final duration = bloc.audioPlayers[index].duration;
                if (duration != null) {
                  final seekPosition = (value * duration.inMilliseconds.toDouble()).round();
                  bloc.audioPlayers[index].seek(Duration(milliseconds: seekPosition));
                }
              }),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                BlocBuilder<MainScreenBloc, MainScreenState>(
                    buildWhen: (previous, current) => previous.currentDuration.inSeconds != current.currentDuration.inSeconds && previous.songIndex == index,
                    builder: (_, state) {
                      return Text(bloc.formatDuration(state.currentDuration.inSeconds),
                          style: TextStyle(fontFamily: Constants.montserratLight, color: Constants.colorOnSurface.withOpacity(0.7)));
                    }),
                Text(bloc.formatDuration(song.duration.toInt()), style: const TextStyle(fontFamily: Constants.montserratLight, color: Constants.colorText))
              ])),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
                padding: const EdgeInsets.all(10.0),
                splashRadius: 30.0,
                splashColor: Constants.colorPrimary,
                onPressed: () => bloc.backwardTenSeconds(index),
                icon: Image.asset('assets/3x/back.png', height: 20, width: 20)),
            BlocBuilder<MainScreenBloc, MainScreenState>(builder: (_, state) {
              return GestureDetector(
                  onTap: () => setUrl.call(),
                  child: state.isPlaying && state.songIndex == index
                      ? Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Constants.colorPrimary),
                          child: state.isBuffering[index]
                              ? const CircularProgressIndicator(backgroundColor: Constants.colorPrimary, color: Constants.colorOnPrimary)
                              : const Icon(Icons.pause, size: 40, color: Constants.colorOnSurface))
                      : Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Constants.colorPrimary),
                          child: state.isBuffering[index] ? const CircularProgressIndicator() : const Icon(Icons.play_arrow_rounded, size: 40, color: Constants.colorOnSurface)));
            }),
            IconButton(
                splashRadius: 30.0,
                splashColor: Constants.colorPrimary,
                onPressed: () => bloc.forwardTenSeconds(index),
                icon: Image.asset('assets/3x/forward.png', height: 20, width: 20))
          ]),
          const SizedBox(height: 10),
          Container(
              height: 35,
              width: 130,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Constants.colorOnSurface, width: 0.4),
                shape: BoxShape.rectangle,
                color: Constants.colorPrimary,
              ),
              child: AppButton(
                text: AppText.CAST_VOTE,
                onClick: () {
                  onClickCalled.call();
                },
                fontSize: 14,
              ))
        ]));
  }
}
