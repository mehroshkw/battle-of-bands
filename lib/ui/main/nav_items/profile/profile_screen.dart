import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/ui/auth/change_password/change_password.dart';
import 'package:battle_of_bands/ui/auth/edit_profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/app_button.dart';
import '../../../../helper/dilogue_helper.dart';
import '../../../../helper/material_dialogue_content.dart';
import '../../../../util/app_strings.dart';
import '../../../../util/constants.dart';
import '../../main_bloc.dart';

class ProfileScreen extends StatelessWidget {
  static const String key_title = '/profile';
  const ProfileScreen({Key? key}) : super(key: key);

  Future<void> _showDialogue(MainScreenBloc bloc, BuildContext context, MaterialDialogHelper dialogHelper) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog("Processing");
    try {
      dialogHelper.dismissProgress();
      dialogHelper.showLogOutDialogue();

    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showMaterialDialogWithContent(MaterialDialogContent.networkError(), () => _showDialogue(bloc, context, dialogHelper));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final bloc = context.read<MainScreenBloc>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.scaffoldColor,
        title: const Text("My Profile", style: TextStyle(
          color: Constants.colorOnSurface,
          fontFamily: Constants.montserratBold
        )),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, EditProfile.route,);
              },
              child: Image.asset('assets/edit.png'))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding:  const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// IMAGE
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100), child: const Image(image: AssetImage('assets/profile.png'))),
              ),
         Container(
           padding: const EdgeInsets.all(20.0),
           width: size.width,
           alignment: Alignment.center,
           child: const Text(
             AppText.DIANA_AGRON,
             style: TextStyle(
               color: Constants.colorOnSurface,
               fontFamily: Constants.montserratMedium,
               fontSize: 24,
             ),
           ),
         ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppText.EMAIL,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: Constants.montserratRegular,
                      color: Constants.colorOnSurface,
                    ),
                  ),
                  Text(
                    AppText.USER_EMAIL,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: Constants.montserratLight,
                      color: Constants.colorOnSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(color: Constants.colorOnSurface,),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppText.DOB,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: Constants.montserratRegular,
                      color: Constants.colorOnSurface,
                    ),
                  ),
                  Text(
                    AppText.DoB,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: Constants.montserratLight,
                      color: Constants.colorOnSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(color: Constants.colorOnSurface,),
              ),
              Row(children:  [
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, ChangePassword.route,);
                  },
                  child: const Text(
                    AppText.CHANGE_PASSORD,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: Constants.montserratRegular,
                      color: Constants.colorPrimary,
                    ),
                  ),
                ),
              ],),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(color: Constants.colorOnSurface,),
              ),
              const SizedBox(height: 140,),
              SizedBox(
                width: size.width - 30,
                height: 50,
                child: AppButton(
                  text: AppText.LOGOUT,
                  onClick: () {
                    _showDialogue(bloc, context, MaterialDialogHelper.instance());
                  },
                  color: Constants.colorPrimary,
                ),
              )
            ],
          ),
          ),
        ),
    );
  }
}

