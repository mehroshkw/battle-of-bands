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
import '../../../util/app_strings.dart';
import '../../main/main_screen.dart';
import '../login/login_screen.dart';

class SignupScreen extends StatelessWidget {
  static const String route = '/signup_screen';

  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignupBloc>();
    final size = context.screenSize;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 30),
                child: Image.asset(
                  'assets/logo.png',
                  height: size.height / 5,
                  width: size.width / 3,
                ),
              ),
              const Text(AppText.SIGN_UP,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: Constants.montserratBold, fontSize: 30, color: Constants.colorPrimary)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Text(AppText.DUMMY_DESC,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontFamily: Constants.montserratRegular, fontSize: 12, color: Constants.colorSurface)),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 25),
                child: Divider(
                  color: Constants.colorOnBorder,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(AppText.FULL_NAME,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontFamily: Constants.montserratMedium, fontSize: 16, color: Constants.colorOnPrimary)),
              ),
              BlocBuilder<SignupBloc, SignUpScreenBlocState>(
                buildWhen: (previous, current) => previous.nameError != current.nameError,
                builder: (_, state) => SizedBox(
                  width: size.width,
                  height: 70,
                  child: AppTextField(
                    hint: AppText.ENTER_FULL_NAME,
                    controller: bloc.nameController,
                    textInputType: TextInputType.text,
                    isError: false,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(AppText.DOB,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontFamily: Constants.montserratMedium, fontSize: 16, color: Constants.colorOnPrimary)),
              ),
              BlocBuilder<SignupBloc, SignUpScreenBlocState>(
                // buildWhen: (previous, current) => previous.isNotShowPassword != current.isNotShowPassword,
                builder: (_, state) => SizedBox(
                  width: size.width,
                  height: 70,
                  child: AppTextField(
                    hint: AppText.Enter_DOB,
                    controller: bloc.dobController,
                    textInputType: TextInputType.datetime,
                    isError: false,
                    suffixIcon: Image.asset(
                      'assets/3x/calendar.png',
                      height: 20,
                      width: 20,
                    ),
                    onSuffixClick: () async {
                      context.unfocus();
                      final currentDatetime = DateTime.now();
                      if (Platform.isAndroid) {
                        final dateTime = await showDatePicker(
                            context: context,
                            initialDate: DateTime(1980),
                            firstDate: DateTime(1980),
                            lastDate: DateTime.now(),
                            builder: (context, child) => Theme(data: Theme.of(context), child: child!));
                        if (dateTime == null) return;
                        bloc.handleDateFromDate(dateTime);
                      } else {
                        showModalBottomSheet(
                            enableDrag: false,
                            context: context,
                            builder: (_) => SizedBox(
                                height: context.size!.height / 3.2,
                                child: CupertinoDatePicker(
                                    onDateTimeChanged: bloc.handleDateFromDate,
                                    maximumDate: DateTime(currentDatetime.year, currentDatetime.month, currentDatetime.day - 1),
                                    mode: CupertinoDatePickerMode.date,
                                    initialDateTime: DateTime(currentDatetime.year - 2))));
                      }
                    },
                  textInputAction: TextInputAction.done,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(AppText.EMAIL_ADDRESS,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontFamily: Constants.montserratMedium, fontSize: 16, color: Constants.colorOnPrimary)),
              ),
              BlocBuilder<SignupBloc, SignUpScreenBlocState>(
                buildWhen: (previous, current) => previous.emailError != current.emailError,
                builder: (_, state) => SizedBox(
                  width: size.width,
                  height: 70,
                  child: AppTextField(
                    hint: AppText.ENTER_EMAIL,
                    controller: bloc.emailController,
                    textInputType: TextInputType.emailAddress,
                    onChanged: (String? text) {
                      if (text == null) return;
                      if (!text.contains('@') || !text.contains('.') || text.isEmpty) {
                        bloc.updateEmailError(AppText.INVALID_EMAIL);
                        return;
                      }
                      bloc.updateEmailError('');
                    },
                    isError: false,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(AppText.PASSWORD,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontFamily: Constants.montserratMedium, fontSize: 16, color: Constants.colorOnPrimary)),
              ),
              BlocBuilder<SignupBloc, SignUpScreenBlocState>(
                buildWhen: (previous, current) => previous.isNotShowPassword != current.isNotShowPassword,
                builder: (_, state) => SizedBox(
                    width: size.width,
                    height: 70,
                    child: AppTextField(
                      isObscure: state.isNotShowPassword,
                      hint: AppText.ENTER_PASSWORD,
                      controller: bloc.passwordController,
                      textInputType: TextInputType.visiblePassword,
                      isError: false,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          bloc.togglePassword();
                        },
                        child: state.isNotShowPassword
                            ? Image.asset(
                          'assets/3x/view-password.png',
                          height: 20,
                          width: 20,
                        )
                            : Icon(
                          Icons.visibility,
                          color: Constants.colorPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
        ),

              Container(
                alignment: Alignment.centerLeft,
                child: const Text(AppText.CONFIRM_PASS,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontFamily: Constants.montserratMedium, fontSize: 16, color: Constants.colorOnPrimary)),
              ),
              BlocBuilder<SignupBloc, SignUpScreenBlocState>(
                buildWhen: (previous, current) => previous.isNotShowConfirmPassword != current.isNotShowConfirmPassword,
                builder: (_, state) => SizedBox(
                    width: size.width,
                    height: 70,
                    child: AppTextField(
                      isObscure: state.isNotShowConfirmPassword,
                      hint: AppText.ENTER_CONFIRM_PASS,
                      controller: bloc.confirmPasswordController,
                      textInputType: TextInputType.visiblePassword,
                      isError: false,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          bloc.toggleConfirmPassword();
                        },
                        child: state.isNotShowConfirmPassword
                            ? Image.asset(
                          'assets/3x/view-password.png',
                          height: 20,
                          width: 20,
                        )
                            : Icon(
                          Icons.visibility,
                          color: Constants.colorPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
        ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: size.width,
                child: AppButton(
                  text: AppText.SIGN_UP,
                  onClick: () {
                    Navigator.pushNamedAndRemoveUntil(context, MainScreen.route, (_) => false);
                  },
                  color: Constants.colorPrimary,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(AppText.HAVE_ACCOUNT,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: Constants.montserratRegular, fontSize: 16, color: Constants.colorOnPrimary)),
                  GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, LoginScreen.route,);
                      Navigator.pop(context);
                    },
                    child: const Text(AppText.LOGIN,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: Constants.montserratRegular, fontSize: 16, color: Constants.colorPrimary)),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),

      ),
    );
  }
}
