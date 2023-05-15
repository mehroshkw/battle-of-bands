import 'package:equatable/equatable.dart';

import '../../data/meta_data.dart';

class EditProfileState extends Equatable {
  final String errorText;
  final bool emailError;
  final String imageUrl;
  final DataEvent fileDataEvent;



  const EditProfileState(
      {required this.errorText, required this.emailError, required this.imageUrl,
        required this.fileDataEvent,});

   const EditProfileState.initial() : this(errorText: '',  emailError: false, imageUrl: '',
    fileDataEvent: const Initial());

  EditProfileState copyWith({bool? emailError, String? errorText, String? imageUrl, DataEvent? fileDataEvent,}) =>
      EditProfileState(
        fileDataEvent: fileDataEvent ?? this.fileDataEvent,
        imageUrl: imageUrl ?? this.imageUrl,
          errorText: errorText ?? this.errorText,
          emailError: emailError ?? this.emailError,
          );

  @override
  List<Object> get props => [emailError, errorText, imageUrl, fileDataEvent,];

  @override
  bool get stringify => true;
}
