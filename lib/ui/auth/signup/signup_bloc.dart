import 'package:battle_of_bands/ui/auth/signup/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../backend/server_response.dart';
import '../../../backend/shared_web_services.dart';
import '../../../helper/shared_preference_helper.dart';

class SignupBloc extends Cubit<SignUpScreenBlocState> {

  final SharedWebService _sharedWebService = SharedWebService.instance();


  /// Text Editing Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void togglePassword() =>
      emit(state.copyWith(isNotShowPassword: !state.isNotShowPassword));

  void toggleConfirmPassword() => emit(state.copyWith(
      isNotShowConfirmPassword: !state.isNotShowConfirmPassword));

  SignupBloc() : super(const SignUpScreenBlocState.initial());

  void updateNameError(bool value, String errorText) =>
      emit(state.copyWith(nameError: value, errorText: errorText));

  void updateDOBError(bool value, String errorText) =>
      emit(state.copyWith(dobError: value, errorText: errorText));

  void updateEmailError(bool value, String errorText) =>
      emit(state.copyWith(emailError: value, errorText: errorText));

  void updatePasswordError(bool value, String errorText) =>
      emit(state.copyWith(passwordError: value, errorText: errorText));

  void updateConfirmPasswordError(bool value, String errorText) =>
      emit(state.copyWith(confirmPasswordError: value, errorText: errorText));

  void handleDateFromDate(DateTime dateTime) {
    final formattedDatetime =
        '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    dobController.text = formattedDatetime;
  }


  Future<IBaseResponse> signup() async {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final dob = dobController.text;
    final response = await _sharedWebService.signup(name, email, password, dob);
    if (response.status && response.user != null) {
      await SharedPreferenceHelper.instance().insertUser(response.user!);
    }
    return response;
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    dobController.dispose();
    return super.close();
  }
}
