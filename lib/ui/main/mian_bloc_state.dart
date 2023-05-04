import 'package:equatable/equatable.dart';

class MainScreenState extends Equatable {
  final int index;
  final bool isVote;

  const MainScreenState({
    required this.index,
    required this.isVote,
  });

  const MainScreenState.initial()
      : this(
          index: 0,
          isVote: true,
        );

  MainScreenState copyWith({
    int? index,
    bool? isVote}) =>
      MainScreenState(
          index: index ?? this.index, isVote: isVote ?? this.isVote);

  @override
  // TODO: implement props
  List<Object?> get props => [index, isVote];
}
