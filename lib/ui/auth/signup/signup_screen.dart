import 'dart:io';
import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/ui/auth/signup/signup_bloc.dart';
import 'package:battle_of_bands/ui/auth/signup/signup_state.dart';
import 'package:flutter/cupertino.dart';
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

class SignupScreen extends StatelessWidget {
  static const String route = '/signup_screen';

  const SignupScreen({Key? key}) : super(key: key);

  Future<void> _signup(SignupBloc bloc, BuildContext context,
      MaterialDialogHelper dialogHelper) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog(AppText.CREATING_ACCOUNT);
    try {
      final response = await bloc.signup();
      dialogHelper.dismissProgress();
      final snackbarHelper = SnackbarHelper.instance..injectContext(context);

      if (!response.status) {
        snackbarHelper.showSnackbar(
            snackbar: SnackbarMessage.error(message: response.message));
        return;
      }
      snackbarHelper.showSnackbar(
          snackbar: SnackbarMessage.success(
              message: AppText.ACCOUNT_CREATED_SUCCESSFULLY));
      Future.delayed(const Duration(seconds: 1)).then((_) =>
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.route, (route) => false));
    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showMaterialDialogWithContent(
          MaterialDialogContent.networkError(),
          () => _signup(bloc, context, dialogHelper));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignupBloc>();
    final size = context.screenSize;
    return Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 30),
                  child: Image.asset('assets/logo.png',
                      height: size.height / 5, width: size.width / 3)),
              const Text(AppText.SIGN_UP,
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
                  child: const Text(AppText.FULL_NAME,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: Constants.montserratMedium,
                          fontSize: 16,
                          color: Constants.colorOnPrimary))),
              BlocBuilder<SignupBloc, SignUpScreenBlocState>(
                buildWhen: (previous, current) =>
                    previous.nameError != current.nameError,
                builder: (_, state) => SizedBox(
                  width: size.width,
                  height: 70,
                  child: AppTextField(
                    hint: AppText.ENTER_FULL_NAME,
                    controller: bloc.nameController,
                    textInputType: TextInputType.text,
                    onChanged: (String? value) {
                      if (value == null) return;
                      if (value.isNotEmpty && state.nameError) {
                        bloc.updateNameError(false, '');
                        return;
                      }
                    },
                    isError: state.nameError,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(AppText.DOB,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: Constants.montserratMedium,
                          fontSize: 16,
                          color: Constants.colorOnPrimary))),
              BlocBuilder<SignupBloc, SignUpScreenBlocState>(
                  buildWhen: (previous, current) =>
                      previous.dobError != current.dobError,
                  builder: (_, state) => SizedBox(
                      width: size.width,
                      height: 70,
                      child: AppTextField(
                          hint: AppText.Enter_DOB,
                          readOnly: true,
                          enabled: false,
                          controller: bloc.dobController,
                          textInputType: TextInputType.datetime,
                          onChanged: (String? value) {
                            if (value == null) return;
                            if (value.isNotEmpty && state.dobError) {
                              bloc.updateDOBError(false, '');
                            }
                          },
                          isError: state.dobError,
                          suffixIcon: Image.asset('assets/3x/calendar.png',
                              height: 20, width: 20),
                          onSuffixClick: () async {
                            context.unfocus();
                            final currentDatetime = DateTime.now();
                            if (Platform.isAndroid) {
                              final dateTime = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(1980),
                                  firstDate: DateTime(1980),
                                  lastDate: DateTime.now(),
                                  builder: (context, child) => Theme(
                                      data: Theme.of(context), child: child!));
                              if (dateTime == null) return;
                              bloc.handleDateFromDate(dateTime);
                            } else {
                              showModalBottomSheet(
                                  enableDrag: false,
                                  context: context,
                                  builder: (_) => CupertinoDatePicker(
                                      backgroundColor: Constants.scaffoldColor,
                                      onDateTimeChanged:
                                          bloc.handleDateFromDate,
                                      maximumDate: DateTime(
                                          currentDatetime.year,
                                          currentDatetime.month,
                                          currentDatetime.day - 1),
                                      mode: CupertinoDatePickerMode.date,
                                      initialDateTime:
                                          DateTime(currentDatetime.year - 2)));
                            }
                          },
                          textInputAction: TextInputAction.done))),
              Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(AppText.EMAIL_ADDRESS,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: Constants.montserratMedium,
                          fontSize: 16,
                          color: Constants.colorOnPrimary))),
              BlocBuilder<SignupBloc, SignUpScreenBlocState>(
                  buildWhen: (previous, current) =>
                      previous.emailError != current.emailError,
                  builder: (_, state) => SizedBox(
                      width: size.width,
                      height: 70,
                      child: AppTextField(
                          hint: AppText.ENTER_EMAIL,
                          controller: bloc.emailController,
                          textInputType: TextInputType.emailAddress,
                          onChanged: (String? value) {
                            if (value == null) return;
                            if (value.isNotEmpty && state.emailError) {
                              bloc.updateEmailError(false, '');
                            }
                          },
                          isError: state.emailError))),
              Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(AppText.PASSWORD,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: Constants.montserratMedium,
                          fontSize: 16,
                          color: Constants.colorOnPrimary))),
              BlocBuilder<SignupBloc, SignUpScreenBlocState>(
                  buildWhen: (previous, current) =>
                      {previous.isNotShowPassword && previous.passwordError} !=
                      {current.isNotShowPassword && current.passwordError},
                  builder: (_, state) => SizedBox(
                      width: size.width,
                      height: 70,
                      child: AppTextField(
                          isObscure: state.isNotShowPassword,
                          hint: AppText.ENTER_PASSWORD,
                          controller: bloc.passwordController,
                          textInputType: TextInputType.visiblePassword,
                          onChanged: (String? value) {
                            if (value == null) return;
                            if (value.isNotEmpty && state.passwordError) {
                              bloc.updatePasswordError(false, '');
                            }
                          },
                          isError: state.passwordError,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              bloc.togglePassword();
                            },
                            child: state.isNotShowPassword
                                ? Image.asset('assets/3x/view-password.png',
                                    height: 20, width: 20)
                                : const Icon(Icons.visibility,
                                    color: Constants.colorPrimary, size: 20),
                          )))),
              Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(AppText.CONFIRM_PASS,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: Constants.montserratMedium,
                          fontSize: 16,
                          color: Constants.colorOnPrimary))),
              BlocBuilder<SignupBloc, SignUpScreenBlocState>(
                  buildWhen: (previous, current) =>
                      {
                        previous.isNotShowConfirmPassword &&
                            previous.confirmPasswordError
                      } !=
                      {
                        current.isNotShowConfirmPassword &&
                            current.confirmPasswordError
                      },
                  builder: (_, state) => SizedBox(
                      width: size.width,
                      height: 70,
                      child: AppTextField(
                          isObscure: state.isNotShowConfirmPassword,
                          hint: AppText.ENTER_CONFIRM_PASS,
                          controller: bloc.confirmPasswordController,
                          textInputType: TextInputType.visiblePassword,
                          onChanged: (String? value) {
                            if (value == null) return;
                            if (value.isNotEmpty &&
                                state.confirmPasswordError) {
                              bloc.updateConfirmPasswordError(false, '');
                            }
                          },
                          isError: state.confirmPasswordError,
                          suffixIcon: GestureDetector(
                              onTap: () {
                                bloc.toggleConfirmPassword();
                              },
                              child: state.isNotShowConfirmPassword
                                  ? Image.asset('assets/3x/view-password.png',
                                      height: 20, width: 20)
                                  : const Icon(Icons.visibility,
                                      color: Constants.colorPrimary,
                                      size: 20))))),
              const SizedBox(height: 10),
              BlocBuilder<SignupBloc, SignUpScreenBlocState>(
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
                                      fontSize: 12))
                            ]));
                  }),
              const SizedBox(height: 20),
              SizedBox(
                  height: 50,
                  width: size.width,
                  child: AppButton(
                      text: AppText.SIGN_UP,
                      onClick: () {
                        context.unfocus();
                        final password = bloc.passwordController.text;
                        final confirmPassword =
                            bloc.confirmPasswordController.text;
                        if (bloc.nameController.text.isEmpty) {
                          bloc.updateNameError(true, AppText.NAME_EMPTY);
                          return;
                        }
                        if (bloc.dobController.text.isEmpty) {
                          bloc.updateDOBError(true, AppText.DOB_EMPTY);
                          return;
                        }
                        final email = bloc.emailController.text;
                        if (email.isEmpty) {
                          bloc.updateEmailError(
                              true, AppText.EMAIL_FIELD_CANNOT_BE_EMPTY);
                          return;
                        }

                        if (bloc.passwordController.text.isEmpty) {
                          bloc.updatePasswordError(
                              true, AppText.PASSWORD_FIELD_CANNOT_BE_EMPTY);
                          return;
                        }

                        if (bloc.confirmPasswordController.text.isEmpty) {
                          bloc.updateConfirmPasswordError(true,
                              AppText.CONFIRM_PASSWORD_FIELD_CANNOT_BE_EMPTY);
                          return;
                        }
                        if (password != confirmPassword) {
                          bloc.updateConfirmPasswordError(true,
                              AppText.PASSWORD_AND_CONFIRM_PASSWORD_NOT_MATCH);
                          return;
                        }
                        _signup(bloc, context, MaterialDialogHelper.instance());
                        return;
                      },
                      color: Constants.colorPrimary)),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(AppText.HAVE_ACCOUNT,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: Constants.montserratRegular,
                        fontSize: 16,
                        color: Constants.colorOnPrimary)),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(AppText.LOGIN,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: Constants.montserratRegular,
                            fontSize: 16,
                            color: Constants.colorPrimary)))
              ]),
              const SizedBox(height: 10)
            ])));
  }
}
