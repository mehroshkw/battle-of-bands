import 'package:battle_of_bands/backend/server_response.dart';
import 'package:battle_of_bands/ui/song_details/my_song_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class MySongDetailsBloc extends Cubit<MySongDetailsState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final Song song;

  late StreamSubscription<Duration> durationStreamSubscription;
  late StreamSubscription<ProcessingState> processingStreamSubscription;

  MySongDetailsBloc({required this.song}) : super( MySongDetailsState.initial()) {
    print('Duration --> ${song.fileUrl}');
    final duration = double.tryParse(song.duration.toString());
    if (duration != null) Duration(milliseconds: (duration * 1000).round());
    audioPlayer.setUrl("$BASE_URL_IMAGE/${song.fileUrl}").then((duration) {
      emit(state.copyWith(isPlayerReady: true));
    });

    processingStreamSubscription = audioPlayer.processingStateStream.listen((event) {
      if (event == ProcessingState.completed) {
        emit(state.copyWith(isPlaying: false, currentDuration: const Duration(seconds: 0)));
        audioPlayer.pause();
        audioPlayer.seek(const Duration(seconds: 0));
      }
    });

    durationStreamSubscription = audioPlayer.positionStream.listen((event) {
      if (state.currentDuration.inSeconds == event.inSeconds) {
        // emit(state.copyWith(isPlaying: !state.isPlaying));
        return;
      }
      emit(state.copyWith(currentDuration: event));
    });
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
    currentDuration.inSeconds - 15 < 0
        ? audioPlayer.seek(const Duration(seconds: 0))
        : audioPlayer.seek(Duration(seconds: currentDuration.inSeconds - 10));
  }

  void forwardTenSeconds() {
    if (!state.isPlayerReady) return;
    final currentDuration = state.currentDuration;
    audioPlayer.seek(Duration(seconds: currentDuration.inSeconds + 15));
  }

    String formatDuration(int duration) {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;

    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds = seconds.toString().padLeft(2, '0');

    return '$formattedMinutes:$formattedSeconds';
  }

  double sliderValue() {
    final position = audioPlayer.position;
    final duration = audioPlayer.duration;

    if (position != null && duration != null && duration.inMilliseconds > 0) {
      final currentPosition = position.inMilliseconds.toDouble();
      final totalDuration = duration.inMilliseconds.toDouble();
      final finalDuration = (currentPosition / totalDuration).isNaN ? 1.0 : currentPosition / totalDuration;

      return finalDuration;
    } else {
      return 0.0;
    }
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
