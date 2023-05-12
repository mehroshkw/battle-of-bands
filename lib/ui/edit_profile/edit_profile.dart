import 'package:battle_of_bands/common/custom_appbar.dart';
import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/util/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/app_button.dart';
import '../../../common/app_text_field.dart';
import '../../../util/constants.dart';

class EditProfile extends StatelessWidget {
  static const String route = '/edit_profile_screen';

  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;

    return Scaffold(
        appBar: const CustomAppbar(
          screenName: AppText.EDIT_PROFILE,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(
                            image: AssetImage('assets/profile.png'))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        getImg();
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/img_button.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30,),
              Container(
                alignment: Alignment.centerLeft,
                child:  const Text(AppText.FULL_NAME,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: Constants.montserratRegular,
                        fontSize: 16,
                        color: Constants.colorOnPrimary)),
              ),
              SizedBox(
                width: size.width,
                height: 70,
                child: const AppTextField(hint: "Diana Agron",
                  // controller: controller.oldPasswordController,
                  textInputType: TextInputType.text,
                  isError: false,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(AppText.DOB,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: Constants.montserratRegular,
                        fontSize: 16,
                        color: Constants.colorOnPrimary)),
              ),
              SizedBox(
                width: size.width,
                height: 70,
                child: const AppTextField(hint: '25 July 1996',
                  textInputType: TextInputType.datetime,
                  // controller: controller.passwordController,
                  isError: false,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(AppText.EMAIL_ADDRESS,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: Constants.montserratRegular,
                        fontSize: 16,
                        color: Constants.colorOnPrimary)),
              ),
              SizedBox(
                width: size.width,
                height: 70,
                child: const AppTextField(hint: AppText.USER_EMAIL,
                  textInputType: TextInputType.emailAddress,
                  // controller: controller.passwordController,
                  isError: false,
                ),
              ),

              const SizedBox(height: 40,),
              SizedBox(
                height: 50,
                width: size.width,
                child: AppButton(text: AppText.SAVE, onClick: (){
                  Navigator.pop(context);
                },
                  color: Constants.colorPrimary,),
              ),
            ],
          ),
        ));
  }
  Future<void> getImg() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image==null)return;
  }
}
