import 'dart:async';
import 'package:battle_of_bands/backend/shared_web_services.dart';
import 'package:battle_of_bands/data/meta_data.dart';
import 'package:battle_of_bands/ui/main/mian_state.dart';
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
  final SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper.instance();

  NetworkHelper get _networkHelper => NetworkHelper.instance();

  List<AudioPlayer> audioPlayers = [];

  // final AudioPlayer audioPlayer = AudioPlayer();

  StreamSubscription<Duration>? durationStreamSubscription;
  late StreamSubscription<PlayerState> processingStreamSubscription;

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
    if (allGenre.isEmpty) return;
    updateLeaderBoardByChangeGenreId(allGenre.first);
    updateMySongsByChangeGenreId(allGenre.first);
    emit(state.copyWith(allGenre: allGenre));
  }

  Future<void> getUser() async {
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    emit(state.copyWith(userEmail: user.emailAddress, userName: user.name, userId: user.id, userDb: user.dateOfBirth, userImage: user.imagePath));
  }

  void updateIndex(int index) {
    emit(state.copyWith(index: index));
  }

  Future<void> updateLeaderBoardByChangeGenreId(Genre genre) async {
    leaderBoardGenreController.text = genre.title;
    emit(state.copyWith(leaderBoardDataEvent: const Loading()));
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    final leaderBoard = await _sharedWebService.getLeaderboard(genre.id, user.id);
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
    audioPlayers = List.generate(battleSongs.length, (_) => AudioPlayer());

    if (battleSongs.isEmpty || battleSongs.length == 1) {
      emit(state.copyWith(battleDataEvent: const Empty(message: '')));
      return;
    }
    emit(state.copyWith(battleDataEvent: Data(data: battleSongs)));
  }

  Future<void> voteBattleSong(Song song, int losserSongId) async {
    if (!(await _networkHelper.isNetworkConnected)) {
      emit(state.copyWith(snackbarMessage: SnackbarMessage.error(message: AppText.LIMITED_NETWORK_CONNECTION)));
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(snackbarMessage: SnackbarMessage.empty()));
      return;
    }
    final user = await sharedPreferenceHelper.user;
    if (user == null) {
      emit(state.copyWith(snackbarMessage: SnackbarMessage.error(message: AppText.LIMITED_NETWORK_CONNECTION)));
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

  void toggleBeginBattle() {
    emit(state.copyWith(isBeginBattle: !state.isBeginBattle));
  }

  void logout() {
    sharedPreferenceHelper.clear();
  }

  // void togglePlayPause(int index, String songUrl) {
  //   print("here");
  //   emit(state.copyWith(songIndex:index));
  //   final isPlaying = state.isPlaying;
  //   final currentSongUrl = state.fileUrl;
  //   print('here 2,,,, index ===== $index');
  //
  //   if (isPlaying) {
  //     audioPlayer.pause();
  //     print("here 3");
  //   } else if (currentSongUrl.isNotEmpty && currentSongUrl == songUrl) {
  //     audioPlayer.play();
  //     print('currentUrl ======= $currentSongUrl here 4');
  //   } else {
  //     // final fileUrl = songUrl;
  //     setSongUrl(songUrl, index);
  //     audioPlayer.play();
  //     print('here 5, song url ==== $songUrl and index === $index');
  //   }
  //   emit(state.copyWith(isPlaying: !isPlaying));
  // }

  // void togglePlayPause(int index) {
  //   if (state.songIndex != index) return;
  //   final isPlaying = state.isPlaying;
  //   isPlaying ? audioPlayer.pause() : audioPlayer.play();
  //   emit(state.copyWith(isPlaying: !isPlaying));
  // }

  void backwardTenSeconds(int index) {
    final player = audioPlayers[index];
    if (!state.isPlayerReady && state.songIndex != index) return;
    if (!state.isPlayerReady) return;

    final currentDuration = state.currentDuration;
    final seekDuration = Duration(seconds: currentDuration.inSeconds - 10);

    if (seekDuration.inSeconds < 0) {
      player.seek(const Duration(seconds: 0));
    } else {
      player.seek(seekDuration);
    }
  }

  void forwardTenSeconds(int index) {
    final player = audioPlayers[index];
    if (!state.isPlayerReady && state.songIndex != index) return;
    if (!state.isPlayerReady) return;

    final currentDuration = state.currentDuration;
    final seekDuration = Duration(seconds: currentDuration.inSeconds + 10);

    if (player.duration != null && seekDuration >= player.duration!) {
      return;
    }

    player.seek(seekDuration);
  }

  double sliderValue(int index) {
    final player = audioPlayers[index];
    final tempState = state.battleDataEvent as Data;
    final songs = List<Song>.of(tempState.data as List<Song>);
    if (state.songIndex != index) {
      final player = audioPlayers[index];
      final position = songs[index].seekbar;
      final duration = player.duration;

      if (duration != null && duration.inMilliseconds > 0) {
        final currentPosition = position.inMilliseconds.toDouble();
        final totalDuration = duration.inMilliseconds.toDouble();
        final finalDuration = (currentPosition / totalDuration).isNaN ? 1.0 : currentPosition / totalDuration;
        return finalDuration;
      }
    }
    final position = player.position;
    final duration = player.duration;

    if (duration != null && duration.inMilliseconds > 0) {
      final currentPosition = position.inMilliseconds.toDouble();
      final totalDuration = duration.inMilliseconds.toDouble();
      final finalDuration = (currentPosition / totalDuration).isNaN ? 1.0 : currentPosition / totalDuration;

      return finalDuration;
    } else {
      final player = audioPlayers[index];
      final position = songs[index].seekbar;
      final duration = Duration(seconds: songs[index].duration.toInt());

      final currentPosition = position.inMilliseconds.toDouble();
      final totalDuration = duration.inMilliseconds.toDouble();
      final finalDuration = (currentPosition / totalDuration).isNaN ? 1.0 : currentPosition / totalDuration;

      return finalDuration;
    }
  }

  // double sliderValue(int index) {
  //   final tempState = state.battleDataEvent as Data;
  //
  //   final songs = List<Song>.of(tempState.data as List<Song>);
  //   if (state.songIndex != index) {
  //     final player = audioPlayers[index];
  //     final position = songs[index].seekbar;
  //     final duration = player.duration;
  //
  //     if (duration != null && duration.inMilliseconds > 0) {
  //       final currentPosition = position.inMilliseconds.toDouble();
  //       final totalDuration = duration.inMilliseconds.toDouble();
  //       final finalDuration = (currentPosition / totalDuration).isNaN
  //           ? 1.0
  //           : currentPosition / totalDuration;
  //
  //       return finalDuration;
  //     }
  //   }
  //   final player = audioPlayers[index];
  //   final position = player.position;
  //   final duration = player.duration;
  //
  //   if (state.isPlaying) {
  //     if (duration != null && duration.inMilliseconds > 0) {
  //       final currentPosition = position.inMilliseconds.toDouble();
  //       final totalDuration = duration.inMilliseconds.toDouble();
  //       final finalDuration = (currentPosition / totalDuration).isNaN
  //           ? 1.0
  //           : currentPosition / totalDuration;
  //
  //       return finalDuration;
  //     } else {
  //       return 0.0;
  //     }
  //   } else {
  //     final player = audioPlayers[index];
  //     final position = songs[index].seekbar;
  //     final duration = player.duration;
  //
  //     if (duration != null && duration.inMilliseconds > 0) {
  //       final currentPosition = position.inMilliseconds.toDouble();
  //       final totalDuration = duration.inMilliseconds.toDouble();
  //       final finalDuration = (currentPosition / totalDuration).isNaN
  //           ? 1.0
  //           : currentPosition / totalDuration;
  //
  //       return finalDuration;
  //     } else {
  //       return 0.0;
  //     }
  //   }
  //
  //   // if (duration != null && duration.inMilliseconds > 0) {
  //   //   final currentPosition = position.inMilliseconds.toDouble();
  //   //   final totalDuration = duration.inMilliseconds.toDouble();
  //   //   final finalDuration = (currentPosition / totalDuration).isNaN
  //   //       ? 1.0
  //   //       : currentPosition / totalDuration;
  //   //
  //   //   return finalDuration;
  //   // } else {
  //   //   print("else of sliderValue method");
  //   //   return 0.0;
  //   // }
  // }

  // Future<void> setSongUrl(String songUrl, int songIndex) async {
  //   final duration = await audioPlayer.setUrl(songUrl);
  //   emit(state.copyWith(isPlayerReady: true, songIndex: songIndex, fileUrl: songUrl, totalDuration: duration));
  //   processingStreamSubscription = audioPlayer.processingStateStream.listen((event) {
  //     if (event == ProcessingState.completed && state.songIndex == songIndex) {
  //       emit(state.copyWith(isPlaying: false, currentDuration: const Duration(seconds: 0)));
  //       audioPlayer.pause();
  //       audioPlayer.seek(const Duration(seconds: 0));
  //     }
  //   });
  //
  //   durationStreamSubscription = audioPlayer.positionStream.listen((event) {
  //     if (state.currentDuration.inSeconds == event.inSeconds) {
  //       return;
  //     }
  //     if (state.songIndex != songIndex) return;
  //     emit(state.copyWith(currentDuration: event));
  //   });
  // }

  void togglePlayPause(int index, String songUrl) async {
    final tempState = state.battleDataEvent as Data;

    final songs = List<Song>.of(tempState.data as List<Song>);
    if (index != state.songIndex && state.isPlaying) {
      final player = audioPlayers[state.songIndex];
      player.pause();
      songs[state.songIndex] = songs[state.songIndex].copyWith(seekbar: player.position);

      emit(state.copyWith(isPlaying: false, battleDataEvent: Data(data: songs)));
    }
    emit(state.copyWith(songIndex: index));
    final isPlaying = state.isPlaying;
    final currentSongUrl = state.fileUrl;
    final player = audioPlayers[index];

    if (isPlaying) {
      songs[index] = songs[index].copyWith(seekbar: player.position);

      emit(state.copyWith(battleDataEvent: Data(data: songs)));

      player.pause();
      emit(state.copyWith(isPlaying: !isPlaying));
    } else if (currentSongUrl.isNotEmpty && currentSongUrl == songUrl) {
      player.play();
      emit(state.copyWith(isPlaying: !isPlaying));
    } else {
      await setSongUrl(songUrl, index, player);
      // await player.setClip(start: songs[index].seekbar);
      await player.play();
      // player.play();
    }
  }

  Future<void> setSongUrl(String songUrl, int songIndex, AudioPlayer player) async {
    if (durationStreamSubscription != null) {
      durationStreamSubscription?.cancel();
    }
    final tempState = state.battleDataEvent as Data;

    final songs = List<Song>.of(tempState.data as List<Song>);
    final currentSong = songs[songIndex];
    emit(state.copyWith(isBuffering: [songIndex == 0 ? true : false, songIndex == 1 ? true : false], currentDuration: currentSong.seekbar));

    final duration = await player.setUrl(songUrl, initialPosition: currentSong.seekbar);

    emit(state.copyWith(songIndex: songIndex, fileUrl: songUrl, totalDuration: duration));

    processingStreamSubscription = player.playerStateStream.listen((event) {
      if (event.playing) {
        emit(state.copyWith(isPlaying: true, isBuffering: [false, false]));
      }
      if (event.processingState == ProcessingState.loading || event.processingState == ProcessingState.buffering) {
        emit(state.copyWith(isBuffering: [songIndex == 0 ? true : false, songIndex == 1 ? true : false], isPlaying: false));
      }
      if (event.processingState == ProcessingState.ready) {
        emit(state.copyWith(isPlayerReady: true));
      }

      if (event.processingState == ProcessingState.completed && state.songIndex == songIndex) {
        songs[songIndex] = songs[songIndex].copyWith(seekbar: const Duration(seconds: 0));
        emit(state.copyWith(isPlaying: false, battleDataEvent: Data(data: songs), currentDuration: const Duration(seconds: 0)));

        player.pause();
        player.seek(const Duration(seconds: 0));
      }
    });
    durationStreamSubscription = player.positionStream.listen((event) {
      if (state.currentDuration.inSeconds == event.inSeconds) {
        return;
      }

      emit(state.copyWith(currentDuration: event));
    });
  }

  @override
  Future<void> close() {
    // audioPlayers.stop();
    // audioPlayers.dispose();
    durationStreamSubscription?.cancel();
    processingStreamSubscription.cancel();
    return super.close();
  }
}
