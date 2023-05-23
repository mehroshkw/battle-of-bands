import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/ui/auth/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:battle_of_bands/util/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/app_button.dart';
import '../../../common/app_text_field.dart';
import '../../../data/snackbar_message.dart';
import '../../../helper/dilogue_helper.dart';
import '../../../helper/material_dialogue_content.dart';
import '../../../helper/snackbar_helper.dart';
import '../../../util/app_strings.dart';
import '../../main/main_screen.dart';
import '../forget_password/forget_password_screen.dart';
import '../signup/signup_screen.dart';
import 'login_bloc.dart';

class LoginScreen extends StatelessWidget {
  static const String route = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  Future<void> _login(LoginBloc bloc, BuildContext context,
      MaterialDialogHelper dialogHelper) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(AppText.LOGGING);
    try {
      final response = await bloc.login();
      dialogHelper.dismissProgress();
      final snackbarHelper = SnackbarHelper.instance..injectContext(context);

      if (!response.status) {
        snackbarHelper.showSnackbar(
            snackbar: SnackbarMessage.error(message: response.message));
        return;
      }
      snackbarHelper.showSnackbar(
          snackbar:
              SnackbarMessage.success(message: AppText.SUCCESSFULLY_LOGGED_IN));
      Future.delayed(const Duration(seconds: 1)).then((_) =>
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.route, (route) => false));
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showMaterialDialogWithContent(
          MaterialDialogContent.networkError(),
          () => _login(bloc, context, dialogHelper));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoginBloc>();
    final size = context.screenSize;
    return Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 30),
                  child: Image.asset('assets/logo.png',
                      height: size.height / 5, width: size.width / 3)),
              const Text(AppText.LOGIN,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: Constants.montserratBold,
                      fontSize: 30,
                      color: Constants.colorPrimary)),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Text(AppText.DUMMY_DESC,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: Constants.montserratRegular,
                          fontSize: 12,
                          color: Constants.colorSurface))),
              const Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 25),
                  child: Divider(color: Constants.colorOnBorder)),
              Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(AppText.EMAIL,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: Constants.montserratMedium,
                          fontSize: 16,
                          color: Constants.colorOnPrimary))),
              BlocBuilder<LoginBloc, LoginBlocState>(
                  buildWhen: (previous, current) =>
                      previous.emailError != current.emailError,
                  builder: (_, state) => SizedBox(
                      width: size.width,
                      height: 70,
                      child: AppTextField(
                          hint: AppText.ENTER_EMAIL,
                          controller: bloc.emailController,
                          textInputType: TextInputType.emailAddress,
                          isError: state.emailError,
                          onChanged: (String? value) {
                            if (value == null) return;
                            if (value.isNotEmpty && state.emailError)
                              bloc.updateEmailError(false, '');
                          }))),
              Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(AppText.PASSWORD,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: Constants.montserratMedium,
                          fontSize: 16,
                          color: Constants.colorOnPrimary))),
              BlocBuilder<LoginBloc, LoginBlocState>(
                  buildWhen: (previous, current) =>
                      previous.passwordError != current.passwordError,
                  builder: (_, state) => SizedBox(
                      width: size.width,
                      height: 70,
                      child: AppTextField(
                        hint: AppText.ENTER_PASSWORD,
                        textInputType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        controller: bloc.passwordController,
                        onChanged: (String? value) {
                          if (value == null) return;
                          if (value.isNotEmpty && state.passwordError)
                            bloc.updatePasswordError(false, '');
                        },
                        isError: state.passwordError,
                      ))),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ForgetPasswordScreen.route);
                  },
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: const Text(AppText.FORGET_PASSWORD,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: Constants.montserratRegular,
                              fontSize: 14,
                              color: Constants.colorPrimary)))),
              BlocBuilder<LoginBloc, LoginBlocState>(
                  buildWhen: (previous, current) =>
                      previous.errorText != current.errorText,
                  builder: (_, state) {
                    if (state.errorText.isEmpty) return const SizedBox();
                    return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 7),
                        margin: const EdgeInsets.only(bottom: 20, top: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Constants.colorError)),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: Constants.colorError),
                              const SizedBox(width: 5),
                              Text(state.errorText,
                                  style: const TextStyle(
                                      color: Constants.colorError,
                                      fontFamily: Constants.montserratRegular,
                                      fontSize: 14))
                            ]));
                  }),
              const SizedBox(height: 30),
              SizedBox(
                  height: 50,
                  width: size.width,
                  child: AppButton(
                    text: AppText.LOGIN,
                    onClick: () {
                      FocusScope.of(context).unfocus();
                      if (bloc.emailController.text.isEmpty) {
                        bloc.updateEmailError(
                            true, AppText.EMAIL_FIELD_CANNOT_BE_EMPTY);
                        return;
                      }
                      if (bloc.passwordController.text.isEmpty) {
                        bloc.updatePasswordError(
                            true, AppText.PASSWORD_FIELD_CANNOT_BE_EMPTY);
                        return;
                      }
                      _login(bloc, context, MaterialDialogHelper.instance());
                    },
                    color: Constants.colorPrimary,
                  )),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(AppText.DONT_HAVE_ACCOUNT,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: Constants.montserratRegular,
                        fontSize: 16,
                        color: Constants.colorOnPrimary)),
                GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        SignupScreen.route,
                      );
                    },
                    child: const Text(AppText.SIGN_UP,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: Constants.montserratRegular,
                            fontSize: 16,
                            color: Constants.colorPrimary))),
              ])
            ])));
  }
}
