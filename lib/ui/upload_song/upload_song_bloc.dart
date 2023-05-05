import 'package:battle_of_bands/ui/upload_song/upload_song_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class UploadSongBloc extends Cubit<UploadSongState> {

  BuildContext? textFieldContext;
  TextEditingController genreController = TextEditingController();
  TextEditingController songTitleController = TextEditingController();
  TextEditingController bandNameController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  UploadSongBloc():super(const UploadSongState.initial());

  void toggleVote() {
    emit(state.copyWith(isShowTrim:  !state.isShowTrim));
  }
}
