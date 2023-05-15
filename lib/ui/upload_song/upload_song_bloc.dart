import 'dart:io';

import 'package:battle_of_bands/backend/server_response.dart';
import 'package:battle_of_bands/data/meta_data.dart';
import 'package:battle_of_bands/ui/upload_song/upload_song_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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


  UploadSongBloc():super(const UploadSongState.initial());

  void updateNameError(bool value, String errorText) => emit(state.copyWith(nameError: value, errorText: errorText));

  void updateGenreError(bool value, String errorText) => emit(state.copyWith(genreError: value, errorText: errorText));

  void updatebBandNameError(bool value, String errorText) => emit(state.copyWith(bandNameError: value, errorText: errorText));

  void updateErrorText(String error) => emit(state.copyWith(errorText: error));


  void toggleVote() {
    emit(state.copyWith(isShowTrim:  !state.isShowTrim));
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['wav', 'mp3', 'aac', 'm4a', 'wma'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

    } else {
      // User canceled the picker
    }
  }

  Future<AddSongResponse?> addNotes() async {
    final user = await sharedPreferenceHelper.user;
    if (user == null) return null;

    final int userId = user.id;
    final String genreId = genreController.text;
    final String externalUrl = urlController.text;
    final String title = songTitleController.text;
    final String bandName = bandNameController.text;
    final String song = "audioPath.value";

    final body = {
      'id': userId.toString(),
      'title': title,
      'genreId': genreId,
      'bandName': bandName,
      'externalUrl': externalUrl,
    };
    final response = await _sharedWebService.addSong(body,song);
    final data = state.dataEvent;
    // if(data is !Data){
    //   state.dataEvent = Data(data: <SongResponse>[response.songs!]);
    // }
    if (data is Data) {
      final notes = data.data as List<SongResponse>;
      final tempList=List.of(notes);
      tempList.add(response.songs!);
      // state.dataEvent = Data(data: tempList);
    }
    return response;
  }
}
