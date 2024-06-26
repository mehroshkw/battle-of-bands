import 'package:battle_of_bands/backend/server_response.dart';
import 'package:battle_of_bands/ui/song_details/my_song_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class MySongDetailsBloc extends Cubit<MySongDetailsState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final List<Song> song;
  int index;

  late StreamSubscription<Duration> durationStreamSubscription;
  late StreamSubscription<ProcessingState> processingStreamSubscription;

  MySongDetailsBloc({required this.song, required this.index}) : super(MySongDetailsState.initial()) {
    emit(state.copyWith(index: index));
    songPlayer(index);
  }

  Future<void> songPlayer(int index) async {
    final duration = await audioPlayer.setUrl('$BASE_URL_DATA/${song[index].fileUrl}');
    emit(state.copyWith(totalDuration: duration, isPlayerReady: true, index: index));
    processingStreamSubscription = audioPlayer.processingStateStream.listen((event) {
      if (event == ProcessingState.completed) {
        emit(state.copyWith(isPlaying: false, currentDuration: const Duration(seconds: 0)));
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
    final seekDuration = Duration(seconds: currentDuration.inSeconds - 10);

    if (seekDuration.inSeconds < 0) {
      audioPlayer.seek(const Duration(seconds: 0));
    } else {
      audioPlayer.seek(seekDuration);
    }
  }

  void forwardTenSeconds() {
    if (!state.isPlayerReady) return;

    final currentDuration = state.currentDuration;
    final seekDuration = Duration(seconds: currentDuration.inSeconds + 10);

    if (audioPlayer.duration != null && seekDuration >= audioPlayer.duration!) {
      // Song has ended, do not perform seek forward
      return;
    }

    audioPlayer.seek(seekDuration);
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
    if (duration != null && duration.inMilliseconds > 0) {
      final currentPosition = position.inMilliseconds.toDouble();
      final totalDuration = duration.inMilliseconds.toDouble();
      final finalDuration = (currentPosition / totalDuration).isNaN ? 1.0 : currentPosition / totalDuration;
      return finalDuration;
    } else {
      return 0.0;
    }
  }

  void playPreviousSong() {
    if (index > 0) {
      index--;
      songPlayer(index);
    }
  }

  void playNextSong() {

    if (index < song.length - 1) {
      index++;
      songPlayer(index);
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
