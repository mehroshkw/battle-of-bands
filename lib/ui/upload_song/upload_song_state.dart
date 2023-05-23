import 'dart:io';
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
  final File file;
  final bool isLoading;
  final int genreId;
  double duration;
  double end;
  double start;
  bool isPlaying;
  final bool bandNameError;

  UploadSongState(
      {required this.isShowTrim,
      required this.dataEvent,
      required this.errorText,
      required this.nameError,
      required this.genreId,
      required this.genreError,
      required this.allGenre,
      required this.file,
      required this.isLoading,
      required this.bandNameError,
      required this.duration,
      required this.start,
      this.isPlaying = false,
      required this.end});

  UploadSongState.initial()
      : this(
            isShowTrim: false,
            dataEvent: const Initial(),
            errorText: '',
            nameError: false,
            genreError: false,
            allGenre: <Genre>[],
            bandNameError: false,
            isLoading: false,
            genreId: -1,
            file: File(''),
            duration: 0.0,
            start: 0.0,
            isPlaying: false,
            end: 0.0);

  UploadSongState copyWith(
          {bool? isShowTrim,
          DataEvent? dataEvent,
          bool? nameError,
          bool? genreError,
          bool? bandNameError,
          List<Genre>? allGenre,
          String? errorText,
          int? genreId,
          File? file,
          double? duration,
          bool? isLoading,
          bool? isPlaying,
          double? start,
          double? end}) =>
      UploadSongState(
          isShowTrim: isShowTrim ?? this.isShowTrim,
          dataEvent: dataEvent ?? this.dataEvent,
          errorText: errorText ?? this.errorText,
          allGenre: allGenre ?? this.allGenre,
          isLoading: isLoading ?? this.isLoading,
          nameError: nameError ?? this.nameError,
          genreError: genreError ?? this.genreError,
          genreId: genreId ?? this.genreId,
          file: file ?? this.file,
          bandNameError: bandNameError ?? this.bandNameError,
          duration: duration ?? this.duration,
          start: start ?? this.start,
          isPlaying: isPlaying ?? this.isPlaying,
          end: end ?? this.end);

  @override
  // TODO: implement props
  List<Object?> get props => [
        isShowTrim,
        dataEvent,
        errorText,
        nameError,
        bandNameError,
        genreError,
        allGenre,
        genreId,
        file,
        duration,
        start,
        end,
        isLoading,
        isPlaying
      ];
}
