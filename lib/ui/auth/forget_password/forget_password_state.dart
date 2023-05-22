import 'package:equatable/equatable.dart';

class ForgetPasswordState extends Equatable {
  final String errorText;
  final bool emailError;

  const ForgetPasswordState(
      {required this.errorText, required this.emailError});

  const ForgetPasswordState.initial() : this(errorText: '', emailError: false);

  ForgetPasswordState copyWith(
          {bool? passwordError, String? errorText, bool? emailError}) =>
      ForgetPasswordState(
          errorText: errorText ?? this.errorText,
          emailError: emailError ?? this.emailError);

  @override
  List<Object> get props => [emailError, errorText];
}
