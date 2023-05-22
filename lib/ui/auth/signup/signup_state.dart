import 'package:equatable/equatable.dart';

class SignUpScreenBlocState extends Equatable {
  final bool isNotShowPassword;
  final bool isNotShowConfirmPassword;
  final bool emailError;
  final bool passwordError;
  final bool confirmPasswordError;
  final bool nameError;
  final bool dobError;
  final String errorText;

  const SignUpScreenBlocState(
      {required this.isNotShowPassword,
      required this.isNotShowConfirmPassword,
      required this.nameError,
      required this.dobError,
      required this.emailError,
      required this.passwordError,
      required this.confirmPasswordError,
      required this.errorText});

  const SignUpScreenBlocState.initial()
      : this(
            isNotShowPassword: true,
            isNotShowConfirmPassword: true,
            emailError: false,
            passwordError: false,
            dobError: false,
            nameError: false,
            confirmPasswordError: false,
            errorText: '');

  SignUpScreenBlocState copyWith(
          {bool? isNotShowPassword,
          bool? isNotShowConfirmPassword,
          bool? emailError,
          bool? nameError,
          bool? dobError,
          DateTime? dateFromDate,
          bool? passwordError,
          bool? confirmPasswordError,
          String? errorText}) =>
      SignUpScreenBlocState(
          isNotShowPassword: isNotShowPassword ?? this.isNotShowPassword,
          emailError: emailError ?? this.emailError,
          passwordError: passwordError ?? this.passwordError,
          confirmPasswordError:
              confirmPasswordError ?? this.confirmPasswordError,
          isNotShowConfirmPassword:
              isNotShowConfirmPassword ?? this.isNotShowConfirmPassword,
          nameError: nameError ?? this.nameError,
          dobError: dobError ?? this.dobError,
          errorText: errorText ?? this.errorText);

  @override
  List<Object> get props => [
        isNotShowPassword,
        isNotShowConfirmPassword,
        emailError,
        passwordError,
        nameError,
        dobError,
        errorText,
        confirmPasswordError
      ];

  @override
  bool get stringify => true;
}
