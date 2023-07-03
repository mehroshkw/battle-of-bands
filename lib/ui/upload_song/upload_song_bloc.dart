import 'dart:developer';
import 'dart:io';
import 'package:battle_of_bands/backend/server_response.dart';
import 'package:battle_of_bands/data/exception.dart';
import 'package:battle_of_bands/extension/primitive_extension.dart';
import 'package:battle_of_bands/ui/upload_song/upload_song_state.dart';
import 'package:easy_audio_trimmer/easy_audio_trimmer.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import '../../backend/shared_web_services.dart';
import '../../helper/shared_preference_helper.dart';
import 'package:path/path.dart' as path;

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

    FFmpegKitConfig.enableLogCallback((log) {
      final message = log.getMessage();
      print('Error flutter ffmpeg --> $message');
    });
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
    print('file ==========================> $file');
    emit(state.copyWith(isLoading: true, file: file));
    await trimmer.loadAudio(audioFile: file);
    print("start === $start, end=== $end");
    emit(state.copyWith(isLoading: false));
  }

  /// using flutter ffmpeg kit package
  Future<String?> getTrimmedAudioFile() async {
    int startTrimmer = start ~/ 1000;
    int endTrimmer = end ~/ 1000;
    print('Start Trimmer: $startTrimmer');
    print('End Trimmer: $endTrimmer');
    final inputPath = state.file.path;
    final String inputPathFileName = inputPath.split('/').last;
    print("inputFileName ======= $inputPathFileName");

    final Directory dir = await getTemporaryDirectory();

    String outPath;
    String cmd;
    if (inputPath.endsWith('mp3')) {
      outPath = '${dir.path}/${inputPathFileName.replaceAll(path.extension(inputPathFileName), '')}.mp3';
      cmd = '-i $inputPath -ss ${startTrimmer.toHumanReadableTime()} -to ${endTrimmer.toHumanReadableTime()} -c copy $outPath';
    } else {
      outPath = '${dir.path}/${inputPathFileName.replaceAll(path.extension(inputPathFileName), '')}.aac';
      cmd = '-i $inputPath -ss ${startTrimmer.toHumanReadableTime()} -to ${endTrimmer.toHumanReadableTime()} -c:a aac -b:a 320k $outPath';
    }

    print('Input File Path: $inputPath');

    print('Output File Path: $outPath');

    log('command ==================> $cmd');

    final FFmpegSession session = await FFmpegKit.execute(cmd);
    final sessionState = await session.getState();

    print('Trimming state --> $sessionState');

    // Return code for completed sessions. Will be undefined if session is still running or FFmpegKit fails to run it
    final returnCode = await session.getReturnCode();
    bool isSuccess = ReturnCode.isSuccess(returnCode);
    print('Is Success -- $isSuccess');

    if (!isSuccess) return null;

    final trimmedDuration = (end - start) / 1000;
    print('duration------------->$trimmedDuration');
    emit(state.copyWith(duration: trimmedDuration));

    return outPath;
  }

  Future<AddSongResponse> uploadSong() async {
    final user = await sharedPreferenceHelper.user;
    if (user == null) throw const UserNotFoundException();
    print('start time in method==== $start  , end time in upload method ==== $end');
    final trimmedDuration = (end - start) / 1000;
    print('duration------------->$trimmedDuration');
    emit(state.copyWith(duration: trimmedDuration));
    final outfilePath = await getTrimmedAudioFile();
    print('outfilePath=========== $outfilePath');
    if (outfilePath == null) throw const NoInternetConnectException();

    final String userId = user.id.toString();
    print('userId=========== $userId');
    final String genreId = state.genreId.toString();
    print('genreId=========== $genreId');
    final String externalUrl = urlController.text;
    print('externalUrl=========== $externalUrl');
    final String title = songTitleController.text;
    print('title=========== $title');
    final String bandName = bandNameController.text;
    print('bandName=========== $bandName');

    // final String songPath = state.file.path;
    // print('song===========> $songPath');
    final double duration = state.duration;
    final body = {
      'AppUserId': userId,
      'title': title,
      'GenreIds': genreId,
      'bandName': bandName,
      'ExternalUrl': 'https://www.google.com/',
      'duration': duration.toString()
    };

    // final songResponse =  await _sharedWebService.addSong(body, songPath);
    final songResponse = await _sharedWebService.addSong(body, outfilePath);
    File(outfilePath).delete();
    print('song response =============$songResponse');
    return songResponse;
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
