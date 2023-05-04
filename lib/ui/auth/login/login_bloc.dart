import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/snackbar_message.dart';
import 'login_state.dart';

class LoginBloc extends Cubit<LoginBlocState>{

  /// Text Editing Controllers
 final TextEditingController emailController = TextEditingController();
 final TextEditingController passwordController = TextEditingController();

  LoginBloc():super(const LoginBlocState.initial());

  void updateEmailError(String error) => emit(state.copyWith(emailError: error));

  void updatePasswordError(String error) => emit(state.copyWith(passwordError: error));

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
   return super.close();
 }

}