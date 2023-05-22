import 'package:equatable/equatable.dart';

class ChangePasswordScreenState extends Equatable {
  final String errorText;
  final bool passwordError;
  final bool newPasswordError;
  final bool confirmPasswordError;

  const ChangePasswordScreenState(
      {required this.errorText,
      required this.passwordError,
      required this.newPasswordError,
      required this.confirmPasswordError});

  const ChangePasswordScreenState.initial()
      : this(
            errorText: '',
            newPasswordError: false,
            confirmPasswordError: false,
            passwordError: false);

  ChangePasswordScreenState copyWith(
          {bool? passwordError,
          bool? newPasswordError,
          bool? confirmPasswordError,
          String? errorText}) =>
      ChangePasswordScreenState(
          errorText: errorText ?? this.errorText,
          passwordError: passwordError ?? this.passwordError,
          newPasswordError: newPasswordError ?? this.newPasswordError,
          confirmPasswordError:
              confirmPasswordError ?? this.confirmPasswordError);

  @override
  List<Object> get props =>
      [passwordError, newPasswordError, confirmPasswordError, errorText];

  @override
  bool get stringify => true;
}
