import 'package:equatable/equatable.dart';

import '../../../data/base_cubit_state.dart';
import '../../../data/snackbar_message.dart';

class ForgetPasswordState extends Equatable {
  final String errorText;
  final bool emailError;

   ForgetPasswordState(
      {
        required this.errorText, required this.emailError
      });

   ForgetPasswordState.initial()
      : this(errorText: '',  emailError: false);

  ForgetPasswordState copyWith(
      {
        bool? passwordError, String? errorText, bool? emailError
       }) =>
      ForgetPasswordState(
        errorText: errorText ?? this.errorText,
        emailError: emailError ?? this.emailError);


  @override
  List<Object> get props =>
      [emailError, errorText];
}
