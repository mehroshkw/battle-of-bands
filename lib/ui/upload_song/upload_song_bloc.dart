import 'package:battle_of_bands/backend/server_response.dart';
import 'package:battle_of_bands/data/meta_data.dart';
import 'package:battle_of_bands/ui/upload_song/upload_song_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../backend/shared_web_services.dart';
import '../../helper/shared_preference_helper.dart';

class UploadSongBloc extends Cubit<UploadSongState> {
  BuildContext? textFieldContext;
  TextEditingController genreController = TextEditingController();
  TextEditingController songTitleController = TextEditingController();
  TextEditingController bandNameController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  final SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper.instance();

  final SharedWebService _sharedWebService = SharedWebService.instance();

  UploadSongBloc() : super(UploadSongState.initial()) {
    getAllGenre();
  }

  void updateNameError(bool value, String errorText) => emit(state.copyWith(nameError: value, errorText: errorText));

  void updateGenreError(bool value, String errorText) => emit(state.copyWith(genreError: value, errorText: errorText));

  void updateBandNameError(bool value, String errorText) => emit(state.copyWith(bandNameError: value, errorText: errorText));

  void updateErrorText(String error) => emit(state.copyWith(errorText: error));

  getAllGenre() async {
    final allGenre = await _sharedWebService.getAllGenre();
    emit(state.copyWith(allGenre: allGenre));
  }
  void changeGenre(Genre genre){
    genreController.text=genre.title;
    emit(state.copyWith(genreId: genre.id));
  }

  Future<void> updateFilePath(String filePath) async {
   emit(state.copyWith(file: XFile(filePath)));
  }

  Future<AddSongResponse?> uploadSong() async {
    final user = await sharedPreferenceHelper.user;
    if (user == null) return null;
    final String userId = user.id.toString();
    final String genreId = state.genreId.toString();
    final String externalUrl = urlController.text;
    final String title = songTitleController.text;
    final String bandName = bandNameController.text;
    final String songPath = state.file.path;

    final body = {
      'AppUserId': userId,
      'title': title,
      'GenreIds': genreId,
      'bandName': bandName,
      'ExternalUrl': 'https://www.google.com/',
    };
    print(body);
    final response = await _sharedWebService.addSong(body, songPath);
    print("response ======> $response");
    return response;
  }
}
