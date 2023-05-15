import 'package:equatable/equatable.dart';

import '../../data/meta_data.dart';

class UploadSongState extends Equatable {
  final bool isShowTrim;
  final DataEvent dataEvent;
  final String errorText;
  final bool nameError;
  final bool genreError;
  final bool bandNameError;

  const UploadSongState({
    required this.isShowTrim,
    required this.dataEvent,
    required this.errorText,
    required this.nameError,
    required this.genreError,
    required this.bandNameError,
  });

  const UploadSongState.initial()
      : this(
            isShowTrim: false,
            dataEvent: const Initial(),
            errorText: '',
            nameError: false,
            genreError: false,
            bandNameError: false);

  UploadSongState copyWith(
          {bool? isShowTrim,
          DataEvent? dataEvent,
          bool? nameError,
          bool? genreError,
          bool? bandNameError,
          String? errorText}) =>
      UploadSongState(
        isShowTrim: isShowTrim ?? this.isShowTrim,
        dataEvent: dataEvent ?? this.dataEvent,
        errorText: errorText ?? this.errorText,
        nameError: nameError ?? this.nameError,
        genreError: genreError ?? this.genreError,
        bandNameError: bandNameError ?? this.bandNameError,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [isShowTrim, dataEvent, errorText, nameError, bandNameError, genreError];
}
