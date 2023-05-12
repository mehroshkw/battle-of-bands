import 'package:battle_of_bands/backend/server_response.dart';
import 'package:battle_of_bands/backend/shared_web_services.dart';
import 'package:equatable/equatable.dart';

class MainScreenState extends Equatable {
  final int index;
  final bool isVote;
  final bool isNoMusic;
  final int totalUploads;
  final int totalWins;
  final int totalLoses;
  final int totalBattles;
  final Statistics statistics;

  const MainScreenState(
      {required this.index,
      required this.isVote,
      required this.isNoMusic,
      required this.totalWins,
      required this.totalLoses,
      required this.totalUploads,
        required this.statistics,
      required this.totalBattles});

   MainScreenState.initial() : this(index: 0, isVote: false, isNoMusic: true, totalUploads: 0, totalWins: 0, totalLoses: 0, totalBattles: 0,statistics:  Statistics(totalUploads: 0, totalWins: 0, totalBattles: 0, totalLoses: 0));

  MainScreenState copyWith({int? index, bool? isVote, bool? isNoMusic, int? totalUploads, int? totalWins, int? totalLoses, int? totalBattles,Statistics? statistics}) => MainScreenState(
      index: index ?? this.index,
      isVote: isVote ?? this.isVote,
      statistics: statistics??this.statistics,
      isNoMusic: isNoMusic ?? this.isNoMusic,
      totalLoses: totalLoses ?? this.totalLoses,
      totalWins: totalWins ?? this.totalWins,
      totalUploads: totalUploads ?? this.totalUploads,
      totalBattles: totalBattles ?? this.totalBattles);

  @override
  // TODO: implement props
  List<Object?> get props => [index, isVote, isNoMusic, totalBattles, totalUploads, totalWins, totalLoses,statistics];
}
