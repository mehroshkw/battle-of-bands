import 'package:battle_of_bands/backend/server_response.dart';
import 'package:battle_of_bands/data/meta_data.dart';
import 'package:equatable/equatable.dart';

import '../../data/snackbar_message.dart';

class MainScreenState extends Equatable {
  final int index;
  final bool isVote;
  final List<bool> isBuffering;
  final bool isBeginBattle;
  final bool isNoMusic;
  final Statistics statistics;
  final List<Genre> allGenre;
  final int userId;
  final String userName;
  final String userEmail;
  final String userDb;
  final String userImage;
  final String fileUrl;
  final DataEvent homeDataEvent;
  final DataEvent mySongDataEvent;
  final DataEvent battleDataEvent;
  final SnackbarMessage snackbarMessage;
  final bool isPlaying;
  final bool isPlayerReady;
  final Duration currentDuration;
  final Duration totalDuration;
  final int songIndex;

  const MainScreenState(
      {required this.index,
      required this.isVote,
      required this.isBeginBattle,
      required this.isNoMusic,
      required this.statistics,
      required this.allGenre,
      required this.userId,
      required this.userName,
      required this.userEmail,
      required this.userDb,
      required this.userImage,
      required this.fileUrl,
      required this.homeDataEvent,
      required this.mySongDataEvent,
      required this.battleDataEvent,
      required this.snackbarMessage,
      this.isPlaying = false,
      this.isPlayerReady = false,
      required this.isBuffering,
      this.songIndex = -1,
      this.currentDuration = Duration.zero,
      this.totalDuration = Duration.zero});

  MainScreenState.initial()
      : this(
            index: 0,
            isVote: false,
            isBeginBattle: false,
            isNoMusic: true,
            statistics: Statistics(totalUploads: 0, totalWins: 0, totalBattles: 0, totalLoses: 0, judgedBattles: 0),
            allGenre: <Genre>[],
            userId: -1,
            userName: '',
            userEmail: '',
            userDb: '',
            userImage: '',
            fileUrl: '',
            homeDataEvent: const Initial(),
            mySongDataEvent: const Initial(),
            battleDataEvent: const Initial(),
            snackbarMessage: SnackbarMessage.empty(),
            isPlaying: false,
            isPlayerReady: false,
            isBuffering: [false, false],
            songIndex: -1,
            currentDuration: Duration.zero,
            totalDuration: Duration.zero);

  MainScreenState copyWith(
          {int? index,
          bool? isVote,
          bool? isBeginBattle,
          bool? isNoMusic,
          Statistics? statistics,
          List<Genre>? allGenre,
          int? userId,
          String? userName,
          String? userEmail,
          String? userDb,
          String? userImage,
          String? fileUrl,
          DataEvent? homeDataEvent,
          DataEvent? mySongDataEvent,
          DataEvent? battleDataEvent,
          SnackbarMessage? snackbarMessage,
          bool? isPlaying,
          bool? isPlayerReady,
          List<bool>? isBuffering,
          int? songIndex,
          Duration? currentDuration,
          Duration? totalDuration}) =>
      MainScreenState(
          index: index ?? this.index,
          isVote: isVote ?? this.isVote,
          isBeginBattle: isBeginBattle ?? this.isBeginBattle,
          statistics: statistics ?? this.statistics,
          isNoMusic: isNoMusic ?? this.isNoMusic,
          userName: userName ?? this.userName,
          userEmail: userEmail ?? this.userEmail,
          userId: userId ?? this.userId,
          allGenre: allGenre ?? this.allGenre,
          userImage: userImage ?? this.userImage,
          fileUrl: fileUrl ?? this.fileUrl,
          userDb: userDb ?? this.userDb,
          homeDataEvent: homeDataEvent ?? this.homeDataEvent,
          mySongDataEvent: mySongDataEvent ?? this.mySongDataEvent,
          battleDataEvent: battleDataEvent ?? this.battleDataEvent,
          snackbarMessage: snackbarMessage ?? this.snackbarMessage,
          isPlaying: isPlaying ?? this.isPlaying,
          isPlayerReady: isPlayerReady ?? this.isPlayerReady,
          isBuffering: isBuffering ?? this.isBuffering,
          songIndex: songIndex ?? this.songIndex,
          totalDuration: totalDuration ?? this.totalDuration,
          currentDuration: currentDuration ?? this.currentDuration);

  @override
  // TODO: implement props
  List<Object?> get props => [
        index,
        isVote,
        isNoMusic,
        statistics,
        allGenre,
        homeDataEvent,
        mySongDataEvent,
        userDb,
        userImage,
        battleDataEvent,
        snackbarMessage,
        userName,
        userId,
        userEmail,
        fileUrl,
        isPlaying,
        isBeginBattle,
        isPlayerReady,
        isBuffering,
        songIndex,
        currentDuration,
        totalDuration
      ];
}
