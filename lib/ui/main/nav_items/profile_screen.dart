import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/ui/auth/change_password/change_password.dart';
import 'package:battle_of_bands/ui/auth/login/login_screen.dart';
import 'package:battle_of_bands/ui/main/mian_bloc_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../backend/server_response.dart';
import '../../../common/app_button.dart';
import '../../../helper/dilogue_helper.dart';
import '../../../util/app_strings.dart';
import '../../../util/constants.dart';
import '../../edit_profile/edit_profile.dart';
import '../main_bloc.dart';

class ProfileScreen extends StatelessWidget {
  static const String key_title = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final bloc = context.read<MainScreenBloc>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.scaffoldColor,
        title: const Text("My Profile", style: TextStyle(color: Constants.colorOnSurface, fontFamily: Constants.montserratBold)),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: () async {
                final result = await Navigator.pushNamed(context, EditProfile.route);
                if (result==true) bloc.getUser();
              },
              child: Image.asset('assets/edit.png'))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// IMAGE
            BlocBuilder<MainScreenBloc, MainScreenState>(
                buildWhen: (previous, current) => previous.userImage != current.userImage,
                builder: (_, state) {
                  ImageProvider image;
                  if (state.userImage.isNotEmpty) {
                    image = NetworkImage('$BASE_URL_IMAGE/${state.userImage}');
                  } else {
                    image = const AssetImage('assets/profile.png');
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100), border: Border.all(color: Constants.colorPrimary), image: DecorationImage(image: image, fit: BoxFit.cover)),
                      width: 120,
                      height: 120,
                    ),
                  );
                }),
            BlocBuilder<MainScreenBloc, MainScreenState>(
              buildWhen: (previous, current) => previous.userName != current.userName,
              builder: (_, state) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  state.userName,
                  style: const TextStyle(
                    color: Constants.colorOnSurface,
                    fontFamily: Constants.montserratMedium,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
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
                BlocBuilder<MainScreenBloc, MainScreenState>(
                  buildWhen: (previous, current) => previous.userEmail != current.userEmail,
                  builder: (_, state) => Text(
                    state.userEmail,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: Constants.montserratLight,
                      color: Constants.colorOnSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(
                color: Constants.colorOnSurface,
              ),
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
                BlocBuilder<MainScreenBloc, MainScreenState>(
                  buildWhen: (previous, current) => previous.userDb != current.userDb,
                  builder: (_, state) => Text(
                    state.userDb,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: Constants.montserratLight,
                      color: Constants.colorOnSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(
                color: Constants.colorOnSurface,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ChangePassword.route,
                    );
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
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(
                color: Constants.colorOnSurface,
              ),
            ),
            const SizedBox(
              height: 140,
            ),
            SizedBox(
              width: size.width - 30,
              height: 50,
              child: AppButton(
                text: AppText.LOGOUT,
                onClick: () {
                  MaterialDialogHelper.instance()
                    ..injectContext(context)
                    ..showLogOutDialogue(positiveClickListener: () {
                      bloc.logout();
                      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.route, (route) => false);
                    });
                },
                color: Constants.colorPrimary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
