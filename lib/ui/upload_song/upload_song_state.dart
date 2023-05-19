import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../backend/server_response.dart';
import '../../data/meta_data.dart';

class UploadSongState extends Equatable {
  final bool isShowTrim;
  final DataEvent dataEvent;
  final String errorText;
  final bool nameError;
  final bool genreError;
  final List<Genre> allGenre;
  final XFile file;
  final int genreId;
   double duration;
   double end;
   double start;
  final bool bandNameError;

   UploadSongState({
    required this.isShowTrim,
    required this.dataEvent,
    required this.errorText,
    required this.nameError,
    required this.genreId,
    required this.genreError,
    required this.allGenre,
    required this.file,
    required this.bandNameError,
    required this.duration,
    required this.start,
    required this.end,
  });

  UploadSongState.initial()
      : this(
            isShowTrim: false,
            dataEvent: const Initial(),
            errorText: '',
            nameError: false,
            genreError: false,
            allGenre: <Genre>[],
            bandNameError: false,
            genreId: -1,
            file: XFile(''),
            duration: 0.0,
            start: 0.0,
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
          XFile? file,
          double? duration,
          double? start,
          double? end}) =>
      UploadSongState(
        isShowTrim: isShowTrim ?? this.isShowTrim,
        dataEvent: dataEvent ?? this.dataEvent,
        errorText: errorText ?? this.errorText,
        allGenre: allGenre ?? this.allGenre,
        nameError: nameError ?? this.nameError,
        genreError: genreError ?? this.genreError,
        genreId: genreId ?? this.genreId,
        file: file ?? this.file,
        bandNameError: bandNameError ?? this.bandNameError,
        duration: duration ?? this.duration,
        start: start ?? this.start,
        end: end ?? this.end,
      );

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
        end
      ];
}
