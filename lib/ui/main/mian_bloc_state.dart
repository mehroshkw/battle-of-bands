import 'package:equatable/equatable.dart';

class MainScreenState extends Equatable {
  final int index;
  final bool isVote;
  final bool isNoMusic;


  const MainScreenState({
    required this.index,
    required this.isVote,
    required this.isNoMusic,
  });

  const MainScreenState.initial()
      : this(
          index: 0,
          isVote: false,
          isNoMusic: true,
        );

  MainScreenState copyWith({
    int? index,
    bool? isVote,
    bool? isNoMusic
  }) =>
      MainScreenState(
          index: index ?? this.index, isVote: isVote ?? this.isVote, isNoMusic : isNoMusic ?? this.isNoMusic);

  @override
  // TODO: implement props
  List<Object?> get props => [index, isVote, isNoMusic];
}
