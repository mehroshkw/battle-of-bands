import 'package:equatable/equatable.dart';

import '../../backend/server_response.dart';
import '../../data/meta_data.dart';

class UploadSongState extends Equatable {
  final bool isShowTrim;
  final DataEvent dataEvent;
  final String errorText;
  final bool nameError;
  final bool genreError;
  final List<Genre> allGenre;
  final int genreId;

  final bool bandNameError;

  const UploadSongState({
    required this.isShowTrim,
    required this.dataEvent,
    required this.errorText,
    required this.nameError,
    required this.genreId,
    required this.genreError,
    required this.allGenre,
    required this.bandNameError,
  });

  UploadSongState.initial() : this(isShowTrim: false, dataEvent: const Initial(), errorText: '', nameError: false, genreError: false, allGenre: <Genre>[], bandNameError: false,genreId: -1);

  UploadSongState copyWith({bool? isShowTrim, DataEvent? dataEvent, bool? nameError, bool? genreError, bool? bandNameError, List<Genre>? allGenre, String? errorText,int?genreId}) =>
      UploadSongState(
        isShowTrim: isShowTrim ?? this.isShowTrim,
        dataEvent: dataEvent ?? this.dataEvent,
        errorText: errorText ?? this.errorText,
        allGenre: allGenre ?? this.allGenre,
        nameError: nameError ?? this.nameError,
        genreError: genreError ?? this.genreError,
        genreId: genreId??this.genreId,
        bandNameError: bandNameError ?? this.bandNameError,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [isShowTrim, dataEvent, errorText, nameError, bandNameError, genreError,allGenre,genreId];
}
