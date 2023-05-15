
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../backend/server_response.dart';
import '../../../backend/shared_web_services.dart';
import 'change_password_screen_state.dart';


class ChangePasswordScreenBloc extends Cubit<ChangePasswordScreenState> {
  ChangePasswordScreenBloc() : super(const ChangePasswordScreenState.initial());
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController newPasswordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  final SharedWebService _sharedWebService = SharedWebService.instance();

  void updatePasswordError(bool value, String errorText) => emit(state.copyWith(passwordError: value, errorText: errorText));

  void updateNewPasswordError(bool value, String errorText) => emit(state.copyWith(newPasswordError: value, errorText: errorText));

  void updateConfirmPasswordError(bool value, String errorText) => emit(state.copyWith(confirmPasswordError: value, errorText: errorText));

  void updateErrorText(String error) => emit(state.copyWith(errorText: error));


  Future<IBaseResponse> changePassword() async {
    final response = await _sharedWebService.changePassword(passwordTextController.text, newPasswordTextController.text);
    if (response.status) {
      passwordTextController.text = '';
      newPasswordTextController.text = '';
      confirmPasswordTextController.text = '';
    }
    print("${response.status} and ${response.message}");
    return response;
  }

  @override
  Future<void> close() {
    passwordTextController.dispose();
    newPasswordTextController.dispose();
    confirmPasswordTextController.dispose();
    return super.close();
  }



}



