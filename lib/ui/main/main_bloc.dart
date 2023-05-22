import 'dart:async';
import 'package:battle_of_bands/backend/shared_web_services.dart';
import 'package:battle_of_bands/data/meta_data.dart';
import 'package:battle_of_bands/ui/main/mian_bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../backend/server_response.dart';
import '../../data/snackbar_message.dart';
import '../../helper/network_helper.dart';
import '../../helper/shared_preference_helper.dart';
import '../../util/app_strings.dart';

class MainScreenBloc extends Cubit<MainScreenState> {
  BuildContext? textFieldContext;
  Key inputKey = GlobalKey();
  final GlobalKey globalKey = GlobalKey(debugLabel: 'btm_app_bar');
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController leaderBoardGenreController = TextEditingController();
  TextEditingController battlesGenreController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  final SharedWebService _sharedWebService = SharedWebService.instance();
  final SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper.instance();

  NetworkHelper get _networkHelper => NetworkHelper.instance();

  final AudioPlayer audioPlayer = AudioPlayer();
  int currentSongIndex = -1;

  late StreamSubscription<Duration> durationStreamSubscription;
  late StreamSubscription<ProcessingState> processingStreamSubscription;

  MainScreenBloc() : super(MainScreenState.initial()) {
    getAllGenre();
    getUser();
    getStatistics();
    getUser();
  }

  getStatistics() async {
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    final statistics = await _sharedWebService.getStatistics(user.id);
    emit(state.copyWith(statistics: statistics));
  }

  getAllGenre() async {
    final allGenre = await _sharedWebService.getAllGenre();
    emit(state.copyWith(allGenre: allGenre));
  }

  Future<void> getUser() async {
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    emit(state.copyWith(
        userEmail: user.emailAddress,
        userName: user.name,
        userId: user.id,
        userDb: user.dateOfBirth,
        userImage: user.imagePath));
  }

  void updateIndex(int index) {
    emit(state.copyWith(index: index));
  }

  Future<void> updateLeaderBoardByChangeGenreId(Genre genre) async {
    leaderBoardGenreController.text = genre.title;
    emit(state.copyWith(leaderBoardDataEvent: const Loading()));
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    final leaderBoard =
        await _sharedWebService.getLeaderboard(genre.id, user.id);
    leaderBoard.sort((b, a) => a.votesCount.compareTo(b.votesCount));
    if (leaderBoard.isEmpty) {
      emit(state.copyWith(leaderBoardDataEvent: const Empty(message: '')));
      return;
    }
    emit(state.copyWith(leaderBoardDataEvent: Data(data: leaderBoard)));
  }

  Future<void> updateMySongsByChangeGenreId(Genre genre) async {
    genreController.text = genre.title;
    emit(state.copyWith(mySongDataEvent: const Loading()));
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    final mySongs = await _sharedWebService.getAllMySongs(genre.id, user.id);

    print("mySongs===========> $mySongs");
    if (mySongs.isEmpty) {
      emit(state.copyWith(mySongDataEvent: const Empty(message: '')));
      return;
    }
    emit(state.copyWith(mySongDataEvent: Data(data: mySongs)));
  }

  Future<void> updateBattleByChangeGenreId(Genre genre) async {
    battlesGenreController.text = genre.title;
    emit(state.copyWith(battleDataEvent: const Loading()));
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    final battleSongs = await _sharedWebService.getAllSongs(genre.id, user.id);
    if (battleSongs.isEmpty || battleSongs.length == 1) {
      emit(state.copyWith(battleDataEvent: const Empty(message: '')));
      return;
    }
    emit(state.copyWith(battleDataEvent: Data(data: battleSongs)));
  }

  Future<void> voteBattleSong(Song song, int losserSongId) async {
    if (!(await _networkHelper.isNetworkConnected)) {
      emit(state.copyWith(
          snackbarMessage: SnackbarMessage.error(
              message: AppText.LIMITED_NETWORK_CONNECTION)));
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(snackbarMessage: SnackbarMessage.empty()));
      return;
    }
    final user = await sharedPreferenceHelper.user;
    if (user == null) {
      emit(state.copyWith(
          snackbarMessage: SnackbarMessage.error(
              message: AppText.LIMITED_NETWORK_CONNECTION)));
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(snackbarMessage: SnackbarMessage.empty()));
      return;
    }
    await _sharedWebService.voteSong(song.id, user.id, true, losserSongId);
    emit(state.copyWith(isBeginBattle: !state.isBeginBattle));
    battlesGenreController.clear();
  }

  Future<void> updateMySongs(Song song) async {
    final mySongDataEvent = state.mySongDataEvent;
    if (mySongDataEvent is Data) {
      final songData = mySongDataEvent.data as List<Song>;
      songData.insert(0, song);
      emit(state.copyWith(mySongDataEvent: Data(data: songData)));
    }
  }

  String formatDuration(int duration) {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;

    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds = seconds.toString().padLeft(2, '0');

    return '$formattedMinutes:$formattedSeconds';
  }

  void toggleVote() {
    emit(state.copyWith(isVote: !state.isVote));
  }

  void toggleBeginBattle() {
    emit(state.copyWith(isBeginBattle: !state.isBeginBattle));
  }

  void logout() {
    sharedPreferenceHelper.clear();
  }

  void togglePlaying() {
    final isPlaying = state.isPlaying;

    emit(state.copyWith(isPlaying: !isPlaying));
  }

  void togglePlayPause() {
    final isPlaying = state.isPlaying;
    isPlaying ? audioPlayer.pause() : audioPlayer.play();
    emit(state.copyWith(isPlaying: !isPlaying));
  }

  void backwardTenSeconds() {
    if (!state.isPlayerReady) return;
    final currentDuration = state.currentDuration;
    currentDuration.inSeconds - 10 < 0
        ? audioPlayer.seek(const Duration(seconds: 0))
        : audioPlayer.seek(Duration(seconds: currentDuration.inSeconds - 10));
  }

  void forwardTenSeconds() {
    if (!state.isPlayerReady) return;
    final currentDuration = state.currentDuration;
    audioPlayer.seek(Duration(seconds: currentDuration.inSeconds + 10));
  }

  double sliderValue() {
    final position = audioPlayer.position;
    final duration = audioPlayer.duration;

    if (position != null && duration != null && duration.inMilliseconds > 0) {
      final currentPosition = position.inMilliseconds.toDouble();
      final totalDuration = duration.inMilliseconds.toDouble();
      final finalDuration = (currentPosition / totalDuration).isNaN
          ? 1.0
          : currentPosition / totalDuration;

      return finalDuration;
    } else {
      return 0.0;
    }
  }

  void setSongUrl(String songUrl, int songIndex) {
    final duration = double.tryParse(songUrl);
    if (duration != null) Duration(milliseconds: (duration * 1000).round());
    audioPlayer.setUrl(songUrl).then((duration) {
      emit(state.copyWith(isPlayerReady: true));
    });

    currentSongIndex = songIndex;

    processingStreamSubscription =
        audioPlayer.processingStateStream.listen((event) {
      if (event == ProcessingState.completed) {
        emit(state.copyWith(
            isPlaying: false, currentDuration: const Duration(seconds: 0)));
        audioPlayer.pause();
        audioPlayer.seek(const Duration(seconds: 0));
      }
    });

    durationStreamSubscription = audioPlayer.positionStream.listen((event) {
      if (state.currentDuration.inSeconds == event.inSeconds) {
        return;
      }
      emit(state.copyWith(currentDuration: event));
    });
  }

  @override
  Future<void> close() {
    audioPlayer.stop();
    audioPlayer.dispose();
    durationStreamSubscription.cancel();
    processingStreamSubscription.cancel();
    return super.close();
  }
}
