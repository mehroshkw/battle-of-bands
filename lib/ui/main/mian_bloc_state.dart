import 'package:battle_of_bands/backend/server_response.dart';
import 'package:battle_of_bands/data/meta_data.dart';
import 'package:equatable/equatable.dart';

class MainScreenState extends Equatable {
  final int index;
  final bool isVote;
  final bool isNoMusic;
  final Statistics statistics;
  final List<Genre> allGenre;
  final int userId;
  final String userName;
  final String userEmail;
  final String userDb;
  final String userImage;
  final DataEvent leaderBoardDataEvent;
  final DataEvent mySongDataEvent;

  const MainScreenState(
      {required this.index,
      required this.isVote,
      required this.isNoMusic,
      required this.statistics,
      required this.allGenre,
      required this.userId,
      required this.userName,
      required this.userEmail,
      required this.userDb,
      required this.userImage,
      required this.leaderBoardDataEvent,
      required this.mySongDataEvent});

  MainScreenState.initial()
      : this(
            index: 0,
            isVote: false,
            isNoMusic: true,
            statistics: Statistics(totalUploads: 0, totalWins: 0, totalBattles: 0, totalLoses: 0),
            allGenre: <Genre>[],
            userId: -1,
            userName: '',
            userEmail: '',
            userDb: '',
            userImage: '',
            leaderBoardDataEvent: const Initial(),
            mySongDataEvent: const Initial());

  MainScreenState copyWith(
          {int? index,
          bool? isVote,
          bool? isNoMusic,
          Statistics? statistics,
          List<Genre>? allGenre,
          int? userId,
          String? userName,
          String? userEmail,
          String? userDb,
          String? userImage,
          DataEvent? leaderBoardDataEvent,
          DataEvent? mySongDataEvent}) =>
      MainScreenState(
          index: index ?? this.index,
          isVote: isVote ?? this.isVote,
          statistics: statistics ?? this.statistics,
          isNoMusic: isNoMusic ?? this.isNoMusic,
          userName: userName ?? this.userName,
          userEmail: userEmail ?? this.userEmail,
          userId: userId ?? this.userId,
          allGenre: allGenre ?? this.allGenre,
          userImage: userImage ?? this.userImage,
          userDb: userDb ?? this.userDb,
          leaderBoardDataEvent: leaderBoardDataEvent ?? this.leaderBoardDataEvent,
          mySongDataEvent: mySongDataEvent ?? this.mySongDataEvent);

  @override
  // TODO: implement props
  List<Object?> get props => [index, isVote, isNoMusic, statistics, allGenre, leaderBoardDataEvent, mySongDataEvent, userDb, userImage];
}
