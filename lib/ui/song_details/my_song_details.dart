import 'package:battle_of_bands/backend/server_response.dart';
import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/ui/song_details/my_song_details_bloc.dart';
import 'package:battle_of_bands/ui/song_details/my_song_details_state.dart';
import 'package:battle_of_bands/util/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../common/custom_appbar.dart';
import '../../util/constants.dart';

class MySongDetailScreen extends StatelessWidget {
  static const String route = '/my_song_details_screen';
  final bool isMySong;

  // final Song song;

  const MySongDetailScreen({
    Key? key,
    required this.isMySong,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MySongDetailsBloc>();
    final size = context.screenSize;

    return Scaffold(
        appBar:
            CustomAppbar(screenName: isMySong ? AppText.MY_SONG : AppText.SONG),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    bloc.song.genre.title,
                    style: const TextStyle(
                        fontFamily: Constants.montserratRegular,
                        color: Constants.colorPrimary,
                        fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      bloc.song.date,
                      style: TextStyle(
                        fontFamily: Constants.montserratLight,
                        color: Constants.colorOnSurface.withOpacity(0.7),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          print("$BASE_URL_IMAGE/${bloc.song.fileUrl}");
                          String url = "$BASE_URL_IMAGE/${bloc.song.fileUrl}";
                          Share.share('Listen to this amazing song!\n$url',
                              subject: 'Check out this song!');
                        },
                        child: Image.asset('assets/share.png')),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width - 20,
                  height: size.height / 3,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/song_img.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  bloc.song.title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontFamily: Constants.montserratSemibold,
                      fontSize: 28,
                      color: Constants.colorOnPrimary),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${AppText.PERFORMER_BAND}${bloc.song.bandName}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontFamily: Constants.montserratLight,
                        fontSize: 20,
                        color: Constants.colorText),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    '${AppText.VOTE} ${bloc.song.votesCount}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontFamily: Constants.montserratRegular,
                        fontSize: 16,
                        color: Constants.colorPrimary),
                  ),
                ),
                BlocBuilder<MySongDetailsBloc, MySongDetailsState>(
                  builder: (_, state) => Slider(
                      value: bloc.sliderValue(),
                      onChanged: (value) {
                        // final position = value * duration.inMilliSeconds;
                        // bloc.audioPlayer
                        //     .seek(Duration(milliseconds: value.round()));
                      },
                      onChangeStart: (value) {
                        // Pause the audio player when seeking starts
                        bloc.audioPlayer.pause();
                        bloc.togglePlayPause();
                      },
                      onChangeEnd: (value) {
                        final duration = bloc.audioPlayer.duration;
                        if (duration != null) {
                          final seekPosition =
                              (value * duration.inMilliseconds.toDouble())
                                  .round();
                          bloc.audioPlayer
                              .seek(Duration(milliseconds: seekPosition));
                          bloc.audioPlayer.play(); // Resume playing after seeking
                          bloc.togglePlayPause();
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<MySongDetailsBloc, MySongDetailsState>(
                        // buildWhen: (previous, current) => ,
                        builder: (_, state) => Text(
                          bloc.formatDuration(state.currentDuration.inSeconds),
                          style: TextStyle(
                            fontFamily: Constants.montserratLight,
                            color: Constants.colorOnSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                      Text(
                        bloc.formatDuration(bloc.song.duration.toInt()),
                        style: TextStyle(
                          fontFamily: Constants.montserratLight,
                          color: Constants.colorOnSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset('assets/3x/previous.png', height: 20, width: 20),
                    GestureDetector(
                        onTap: () {
                          bloc.backwardTenSeconds();
                        },
                        child: Image.asset('assets/3x/back.png',
                            height: 20, width: 20)),
                    BlocBuilder<MySongDetailsBloc, MySongDetailsState>(
                      builder: (_, state) => GestureDetector(
                          onTap: () {
                            bloc.togglePlayPause();
                          },
                          child: state.isPlaying
                              ? Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Constants.colorPrimary),
                                  child: const Icon(
                                    Icons.pause,
                                    size: 40,
                                    color: Constants.colorOnSurface,
                                  ),
                                )
                              : Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Constants.colorPrimary),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    size: 50,
                                    color: Constants.colorOnSurface,
                                  ),
                                )),
                    ),
                    GestureDetector(
                        onTap: () {
                          bloc.forwardTenSeconds();
                        },
                        child: Image.asset('assets/3x/forward.png',
                            height: 20, width: 20)),
                    Image.asset('assets/3x/next.png', height: 20, width: 20),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
