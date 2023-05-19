import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/ui/auth/change_password/change_password_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/app_button.dart';
import '../../../common/app_text_field.dart';
import '../../../common/custom_appbar.dart';
import '../../../data/snackbar_message.dart';
import '../../../helper/dilogue_helper.dart';
import '../../../helper/material_dialogue_content.dart';
import '../../../helper/snackbar_helper.dart';
import '../../../util/app_strings.dart';
import '../../../util/constants.dart';
import 'change_password_screen_state.dart';

class ChangePassword extends StatelessWidget {
  static const String route = '/change_password_screen';

  const ChangePassword({Key? key}) : super(key: key);

  Future<void> _changePassword(
      BuildContext context, ChangePasswordScreenBloc bloc) async {
    final dialogHelper = MaterialDialogHelper.instance()
      ..injectContext(context)
      ..showProgressDialog(AppText.UPDATING_PASSWORD);
    try {
      final response = await bloc.changePassword();
      dialogHelper.dismissProgress();
      final snackbarHelper = SnackbarHelper.instance..injectContext(context);
      response.status
          ? snackbarHelper.showSnackbar(
              snackbar:
                  SnackbarMessage.success(message: AppText.PASSWORD_CHANGED))
          : snackbarHelper.showSnackbar(
              snackbar: SnackbarMessage.error(message: response.message));
    } catch (_) {
      dialogHelper
        ..dismissProgress()
        ..showMaterialDialogWithContent(MaterialDialogContent.networkError(),
            () => _changePassword(context, bloc));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final bloc = context.read<ChangePasswordScreenBloc>();

    return Scaffold(
      appBar: const CustomAppbar(
        screenName: AppText.CHANGE_PASSORD,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 30),
              child: Image.asset(
                'assets/logo.png',
                height: size.height / 5,
                width: size.width / 3,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(AppText.ENTER_OLD_PASSWORD,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: Constants.montserratRegular,
                      fontSize: 16,
                      color: Constants.colorOnPrimary)),
            ),
            BlocBuilder<ChangePasswordScreenBloc, ChangePasswordScreenState>(
              buildWhen: (previous, current) =>
                  previous.newPasswordError != current.newPasswordError,
              builder: (_, state) => SizedBox(
                width: size.width,
                height: 70,
                child: AppTextField(
                  hint: AppText.STARS,
                  controller: bloc.passwordTextController,
                  textInputType: TextInputType.visiblePassword,
                  onChanged: (String? value) {
                    if (value == null) return;
                    if (value.isNotEmpty && state.passwordError)
                      bloc.updateNewPasswordError(false, '');
                  },
                  isError: state.passwordError,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(AppText.ENTER_NEW_PASSWORD,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: Constants.montserratRegular,
                      fontSize: 16,
                      color: Constants.colorOnPrimary)),
            ),
            BlocBuilder<ChangePasswordScreenBloc, ChangePasswordScreenState>(
              buildWhen: (previous, current) =>
                  previous.newPasswordError != current.newPasswordError,
              builder: (_, state) => SizedBox(
                width: size.width,
                height: 70,
                child: AppTextField(
                  hint: AppText.STARS,
                  textInputType: TextInputType.visiblePassword,
                  controller: bloc.newPasswordTextController,
                  onChanged: (String? value) {
                    if (value == null) return;
                    if (value.isNotEmpty && state.newPasswordError)
                      bloc.updateNewPasswordError(false, '');
                  },
                  isError: state.newPasswordError,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(AppText.CONFIRM_NEW_PASSWORD,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: Constants.montserratRegular,
                      fontSize: 16,
                      color: Constants.colorOnPrimary)),
            ),
            BlocBuilder<ChangePasswordScreenBloc, ChangePasswordScreenState>(
              buildWhen: (previous, current) =>
                  previous.confirmPasswordError != current.confirmPasswordError,
              builder: (_, state) => SizedBox(
                width: size.width,
                height: 70,
                child: AppTextField(
                  hint: AppText.STARS,
                  textInputType: TextInputType.visiblePassword,
                  controller: bloc.confirmPasswordTextController,
                  onChanged: (String? value) {
                    if (value == null) return;
                    if (value.isNotEmpty && state.confirmPasswordError)
                      bloc.updateConfirmPasswordError(false, '');
                  },
                  isError: state.confirmPasswordError,
                ),
              ),
            ),
            BlocBuilder<ChangePasswordScreenBloc, ChangePasswordScreenState>(
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
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              width: size.width,
              child: AppButton(
                text: AppText.CHANGE_PASSORD,
                onClick: () {
                  final password = bloc.passwordTextController.text;
                  if (password.isEmpty) {
                    bloc.updatePasswordError(
                        true, AppText.PASSWORD_FIELD_CANNOT_BE_EMPTY);
                    return;
                  }
                  final newPassword = bloc.newPasswordTextController.text;
                  if (newPassword.isEmpty) {
                    bloc.updateNewPasswordError(
                        true, AppText.NEW_PASSWORD_FIELD_CANNOT_BE_EMPTY);
                    return;
                  }
                  final confirmPassword =
                      bloc.confirmPasswordTextController.text;
                  if (confirmPassword.isEmpty) {
                    bloc.updateConfirmPasswordError(
                        true, AppText.CONFIRM_PASSWORD_FIELD_CANNOT_BE_EMPTY);
                    return;
                  }
                  if (newPassword != confirmPassword) {
                    bloc.updateConfirmPasswordError(
                        true, AppText.BOTH_PASSWORD_DOES_NOT_MATCH);
                    return;
                  }
                  _changePassword(context, bloc);
                },
                color: Constants.colorPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
