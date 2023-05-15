import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../backend/server_response.dart';
import '../../../backend/shared_web_services.dart';
import '../../../helper/shared_preference_helper.dart';
import 'login_state.dart';

class LoginBloc extends Cubit<LoginBlocState>{

  /// Text Editing Controllers
 final TextEditingController emailController = TextEditingController();
 final TextEditingController passwordController = TextEditingController();
 final SharedWebService _sharedWebService = SharedWebService.instance();

  LoginBloc():super( LoginBlocState.initial());

 void updateErrorText(String error) => emit(state.copyWith(errorText: error));

 void updateEmailError(bool value, String errorText) => emit(state.copyWith(emailError: value, errorText: errorText));

 void updatePasswordError(bool value, String errorText) => emit(state.copyWith(passwordError: value, errorText: errorText));

 Future<IBaseResponse> login() async {
   final String email = emailController.text;
   final String password = passwordController.text;
   print('email: $email');
   print('pass: $password');
   final response = await _sharedWebService.login(email, password);
   print("reached here========");
   if (response.status && response.user != null) {
     print('Hell --> ${response.user}');
     await SharedPreferenceHelper.instance().insertUser(response.user!);
   }
   return response;
 }

 @override
 Future<void> close() {
   emailController.dispose();
   passwordController.dispose();
   return super.close();
 }

}