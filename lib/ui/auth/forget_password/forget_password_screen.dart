import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:battle_of_bands/util/constants.dart';
import '../../../common/app_button.dart';
import '../../../common/app_text_field.dart';
import '../../../util/app_strings.dart';

class ForgetPasswordScreen extends StatelessWidget {
  static const String route = '/forget_password_screen';
  const ForgetPasswordScreen({Key? key}) : super(key: key);

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
              padding: const EdgeInsets.only(top:30.0, bottom: 30),
              child: Image.asset('assets/logo.png', height: size.height/5, width: size.width/3 ,),
            ),

            const Text(AppText.FORGET_PASSWORD,
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
              padding: EdgeInsets.only(top:10.0, bottom: 25),
              child: Divider(color:Constants.colorOnBorder,),
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
              child:  AppTextField(
                // controller: controller.emailController,
                hint: AppText.ENTER_EMAIL, textInputType: TextInputType.emailAddress, isError: false,
              ),
            ),
            const SizedBox(height: 40,),
            SizedBox(
              height: 50,
              width: size.width,
              child: AppButton(text: AppText.SEND, onClick: (){
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
