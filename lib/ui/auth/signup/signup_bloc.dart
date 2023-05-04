import 'package:battle_of_bands/ui/auth/signup/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/snackbar_message.dart';

class SignupBloc extends Cubit<SignUpScreenBlocState> {
  /// Text Editing Controllers
final TextEditingController nameController = TextEditingController();
final TextEditingController dobController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();


  void togglePassword() => emit(state.copyWith(isNotShowPassword: !state.isNotShowPassword));

  void toggleConfirmPassword() => emit(state.copyWith(isNotShowConfirmPassword: !state.isNotShowConfirmPassword));

  SignupBloc():super( SignUpScreenBlocState.initial());
  void updateEmailError(String error) => emit(state.copyWith(emailError: error));

  void updateNamelError(String error) => emit(state.copyWith(nameError: error));

  void updateDOBError(String error) => emit(state.copyWith(dobError: error));

  void updatePasswordError(String error) => emit(state.copyWith(passwordError: error));

  void updateConfirmPasswordError(String error) => emit(state.copyWith(confirmPasswordError: error));

void handleDateFromDate(DateTime dateTime) {
  print('date time==================.$dateTime');
  final formattedDatetime = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  // emit(state.copyWith(dobError: ''));
  dobController.text = formattedDatetime;
}

  void _emitSnackbar(SnackbarMessage message) {
    emit(state.copyWith(snackbarMessage: message));
    _sendEmptySnackbar();
  }

  void _sendEmptySnackbar() =>
      Future.delayed(const Duration(seconds: 1)).then((_) => emit(state.copyWith(snackbarMessage: const SnackbarMessage.empty())));

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();


    return super.close();
  }
}