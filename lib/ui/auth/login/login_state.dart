import 'package:equatable/equatable.dart';

import '../../../data/base_cubit_state.dart';
import '../../../data/snackbar_message.dart';

class LoginBlocState extends Equatable {
  final String errorText;
  final bool emailError;
  final bool passwordError;

   LoginBlocState(
      {
        required this.errorText, required this.passwordError, required this.emailError
      });

   LoginBlocState.initial()
      : this(errorText: '', passwordError: false, emailError: false);

  LoginBlocState copyWith(
      {
        bool? passwordError, String? errorText, bool? emailError
       }) =>
      LoginBlocState(
        errorText: errorText ?? this.errorText,
        passwordError: passwordError ?? this.passwordError,
        emailError: emailError ?? this.emailError);


  @override
  List<Object> get props =>
      [emailError, passwordError, errorText];
}
