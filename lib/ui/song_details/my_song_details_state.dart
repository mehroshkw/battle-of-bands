import 'package:equatable/equatable.dart';
import '../../backend/server_response.dart';
import '../../data/snackbar_message.dart';

class MySongDetailsState extends Equatable {
  final SnackbarMessage snackbarMessage;
  final bool isPlaying;
  final bool isPlayerReady;
  final Duration currentDuration;
  final int index;

  const MySongDetailsState({
    required this.snackbarMessage,
    this.isPlaying = false,
    this.isPlayerReady = false,
    this.currentDuration = Duration.zero,
    this.index = 0,
  });

  MySongDetailsState.initial()
      : this(
          snackbarMessage: SnackbarMessage.empty(),
          isPlaying: false,
          isPlayerReady: false,
          currentDuration: Duration.zero,
          index: -1,
        );

  MySongDetailsState copyWith({
    SnackbarMessage? snackbarMessage,
    bool? isPlaying,
    bool? isPlayerReady,
    Duration? currentDuration,
    int? index,
    Song? currentSong,
  }) =>
      MySongDetailsState(
        snackbarMessage: snackbarMessage ?? this.snackbarMessage,
        isPlaying: isPlaying ?? this.isPlaying,
        isPlayerReady: isPlayerReady ?? this.isPlayerReady,
        currentDuration: currentDuration ?? this.currentDuration,
        index: index ?? this.index,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [snackbarMessage, isPlaying, isPlayerReady, currentDuration, index];
}
