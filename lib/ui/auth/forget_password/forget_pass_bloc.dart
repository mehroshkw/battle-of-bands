import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../backend/server_response.dart';
import '../../../backend/shared_web_services.dart';
import 'forget_password_state.dart';

class ForgetPasswordBloc extends Cubit<ForgetPasswordState> {
  /// Text Editing Controllers
  final TextEditingController emailController = TextEditingController();
  final SharedWebService _sharedWebService = SharedWebService.instance();

  ForgetPasswordBloc() : super(const ForgetPasswordState.initial());

  void updateErrorText(String error) => emit(state.copyWith(errorText: error));

  void updateEmailError(bool value, String errorText) =>
      emit(state.copyWith(emailError: value, errorText: errorText));

  Future<IBaseResponse> forgetPassword() async {
    final String email = emailController.text;
    final response = await _sharedWebService.forgetPassword(email);
    if (response.status && response.user != null) {
      return response;
    }
    return response;
  }

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }
}
