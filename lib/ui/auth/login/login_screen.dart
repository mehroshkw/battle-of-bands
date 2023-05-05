import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:battle_of_bands/util/constants.dart';
import '../../../common/app_button.dart';
import '../../../common/app_text_field.dart';
import '../../../util/app_strings.dart';
import '../../main/main_screen.dart';
import '../forget_password/forget_password_screen.dart';
import '../signup/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String route = '/login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    return Scaffold(
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
                      color: Constants.colorSurface)),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 25),
              child: Divider(
                color: Constants.colorOnBorder,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(AppText.EMAIL,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: Constants.montserratMedium,
                      fontSize: 16,
                      color: Constants.colorOnPrimary)),
            ),
            SizedBox(
              width: size.width,
              height: 70,
              child: const AppTextField(
                hint: AppText.ENTER_EMAIL,
                // controller: controller.emailController,
                textInputType: TextInputType.emailAddress,
                isError: false,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(AppText.PASSWORD,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: Constants.montserratMedium,
                      fontSize: 16,
                      color: Constants.colorOnPrimary)),
            ),
            SizedBox(
              width: size.width,
              height: 70,
              child: const AppTextField(
                hint: AppText.ENTER_PASSWORD,
                textInputType: TextInputType.visiblePassword,
                // controller: controller.passwordController,
                isError: false,
              ),
            ),
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
                        color: Constants.colorPrimary)),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 50,
              width: size.width,
              child: AppButton(
                text: AppText.LOGIN,
                onClick: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, MainScreen.route, (_) => false);
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
                          color: Constants.colorPrimary)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
