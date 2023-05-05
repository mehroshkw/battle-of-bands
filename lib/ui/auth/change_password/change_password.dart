import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:flutter/material.dart';

import '../../../common/app_button.dart';
import '../../../common/app_text_field.dart';
import '../../../common/custom_appbar.dart';
import '../../../util/app_strings.dart';
import '../../../util/constants.dart';

class ChangePassword extends StatelessWidget {
  static const String route = '/change_password_screen';
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;

    return Scaffold(
      appBar: const CustomAppbar(screenName: AppText.CHANGE_PASSORD,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.only(top:30.0, bottom: 30),
              child: Image.asset('assets/logo.png', height: size.height/5, width: size.width/3 ,),
            ),
            SizedBox(height: 20,),
            Container(
              alignment: Alignment.centerLeft,
              child:  const Text(AppText.ENTER_OLD_PASSWORD,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: Constants.montserratRegular,
                      fontSize: 16,
                      color: Constants.colorOnPrimary)),
            ),
            SizedBox(
              width: size.width,
              height: 70,
              child: const AppTextField(hint: AppText.STARS,
                // controller: controller.oldPasswordController,
                textInputType: TextInputType.visiblePassword,
                isError: false,
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
            SizedBox(
              width: size.width,
              height: 70,
              child: const AppTextField(hint: AppText.STARS,
                textInputType: TextInputType.visiblePassword,
                // controller: controller.passwordController,
                isError: false,
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
            SizedBox(
              width: size.width,
              height: 70,
              child: const AppTextField(hint: AppText.STARS,
                textInputType: TextInputType.visiblePassword,
                // controller: controller.passwordController,
                isError: false,
              ),
            ),

            const SizedBox(height: 40,),
            SizedBox(
              height: 50,
              width: size.width,
              child: AppButton(text: AppText.CHANGE_PASSORD, onClick: (){
               Navigator.pop(context);
              },
                color: Constants.colorPrimary,),
            ),
          ],
        ),
      ),
    );
  }
}
