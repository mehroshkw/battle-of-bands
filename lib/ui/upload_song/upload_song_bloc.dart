import 'dart:io';
import 'package:battle_of_bands/backend/server_response.dart';
import 'package:battle_of_bands/ui/upload_song/upload_song_state.dart';
import 'package:easy_audio_trimmer/easy_audio_trimmer.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../backend/shared_web_services.dart';
import '../../helper/shared_preference_helper.dart';

class UploadSongBloc extends Cubit<UploadSongState> {
  final TextEditingController genreController = TextEditingController();
  final TextEditingController songTitleController = TextEditingController();
  final TextEditingController bandNameController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper.instance();
  final SharedWebService _sharedWebService = SharedWebService.instance();
  final Trimmer trimmer = Trimmer();
  double end = 0.0;
  double start = 0.0;

  UploadSongBloc() : super(UploadSongState.initial()) {
    getAllGenre();
  }

  void updateNameError(bool value, String errorText) => emit(state.copyWith(nameError: value, errorText: errorText));

  void updateGenreError(bool value, String errorText) => emit(state.copyWith(genreError: value, errorText: errorText));

  void updateBandNameError(bool value, String errorText) => emit(state.copyWith(bandNameError: value, errorText: errorText));

  void updateErrorText(String error) => emit(state.copyWith(errorText: error));

  Future<void> getAllGenre() async {
    final allGenre = await _sharedWebService.getAllGenre();
    if (isClosed) return;
    emit(state.copyWith(allGenre: allGenre));
  }

  void changeGenre(Genre genre) {
    genreController.text = genre.title;
    emit(state.copyWith(genreId: genre.id));
  }

  Future<void> updateFilePath(String? filePath) async {
    if (filePath == null) return;

    final file = File(filePath);
    emit(state.copyWith(isLoading: true, file: file));
    final duration = await trimmer.loadAudio(audioFile: file);
    // print('duration-------------->$duration');duration

    emit(state.copyWith(isLoading: false));
  }



  Future<void> trimmerSaveFile() => trimmer.saveTrimmedAudio(
      startValue: start,
      endValue: end,
      audioFileName: DateTime.now().millisecondsSinceEpoch.toString(),
      onSave: (trimmedFile) {
        final tempFile = trimmer!.currentAudioFile;
        print("tempfile ======================>>> $tempFile");
        print('Trimmed File --> $trimmedFile');
        final duration = (end - start) / 1000;
        print('duration---------------->$duration');

        if (trimmedFile == null) return;
        emit(state.copyWith(duration: duration, file: File(trimmedFile)));
      });

  Future<AddSongResponse?> uploadSong() async {
    final user = await sharedPreferenceHelper.user;
    if (user == null) return null;
    await trimmerSaveFile();
    await Future.delayed(const Duration(seconds: 2));
    final String userId = user.id.toString();
    final String genreId = state.genreId.toString();
    final String externalUrl = urlController.text;
    final String title = songTitleController.text;
    final String bandName = bandNameController.text;

    final String songPath = state.file.path;
    final double duration = state.duration;
    final body = {
      'AppUserId': userId,
      'title': title,
      'GenreIds': genreId,
      'bandName': bandName,
      'ExternalUrl': 'https://www.google.com/',
      'duration': duration.toString()
    };
    return await _sharedWebService.addSong(body, songPath);
  }

  Future<void> playTrimmedSong() async {
    final isPlayingBack = await trimmer.audioPlaybackControl(startValue: state.start, endValue: state.end);
    emit(state.copyWith(isPlaying: isPlayingBack));
  }

  void isPlayingUpdate(bool value) {
    if (isClosed) return;
    emit(state.copyWith(isPlaying: value));
  }

  @override
  Future<void> close() async {
    print('Close....');
    await trimmer.audioPlayer?.dispose();
    trimmer.dispose();
    return super.close();
  }
}
