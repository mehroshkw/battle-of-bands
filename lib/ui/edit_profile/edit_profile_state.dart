import 'package:equatable/equatable.dart';
import '../../data/meta_data.dart';

class EditProfileState extends Equatable {
  final String errorText;
  final bool emailError;
  final String imageUrl;
  final bool dobError;
  final DataEvent fileDataEvent;

  const EditProfileState(
      {required this.errorText,
      required this.emailError,
      required this.imageUrl,
        required this.dobError,
        required this.fileDataEvent});

  const EditProfileState.initial()
      : this(
            errorText: '',
            emailError: false,
            imageUrl: '',
      dobError: false,
      fileDataEvent: const Initial());

  EditProfileState copyWith({
    bool? emailError,
    String? errorText,
    String? imageUrl,
    bool? dobError,
    DataEvent? fileDataEvent,
  }) =>
      EditProfileState(
          fileDataEvent: fileDataEvent ?? this.fileDataEvent,
          imageUrl: imageUrl ?? this.imageUrl,
          errorText: errorText ?? this.errorText,
          emailError: emailError ?? this.emailError,
        dobError: dobError ?? this.dobError);

  @override
  List<Object> get props => [emailError, errorText, imageUrl, fileDataEvent, dobError];

  @override
  bool get stringify => true;
}
