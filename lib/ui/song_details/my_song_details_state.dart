import 'package:equatable/equatable.dart';
import '../../data/snackbar_message.dart';

class MySongDetailsState extends Equatable {
  final SnackbarMessage snackbarMessage;
  final bool isPlaying;
  final bool isPlayerReady;
  final Duration currentDuration;

  const MySongDetailsState(
      {
      required this.snackbarMessage,
        this.isPlaying = false,
        this.isPlayerReady = false,
        this.currentDuration = Duration.zero,
      });

  MySongDetailsState.initial()
      : this(
            snackbarMessage: SnackbarMessage.empty(),
    isPlaying: false,
    isPlayerReady: false,
    currentDuration: Duration.zero
  );

  MySongDetailsState copyWith(
          {
          SnackbarMessage? snackbarMessage,
          bool? isPlaying,
          bool? isPlayerReady,
          Duration? currentDuration,
          }) =>
      MySongDetailsState(
          snackbarMessage: snackbarMessage ?? this.snackbarMessage,
      isPlaying: isPlaying ?? this.isPlaying,
      isPlayerReady: isPlayerReady ?? this.isPlayerReady,
      currentDuration: currentDuration ?? this.currentDuration,
      );

  @override
  // TODO: implement props
  List<Object?> get props =>
      [snackbarMessage, isPlaying, isPlayerReady, currentDuration];
}
