
import 'package:flutter/material.dart';

import '../util/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String userEmail;
  final Widget notificationIcon;

  const CustomAppBar(
      {super.key,
      required this.userName,
      required this.userEmail,
      required this.notificationIcon});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Constants.scaffoldColor,
        automaticallyImplyLeading: false,
        title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName,
                      style: const TextStyle(
                          color: Constants.colorOnSurface,
                          fontFamily: Constants.montserratSemibold,
                          fontSize: 22)),
                  Text(userEmail,
                      style: const TextStyle(
                          color: Constants.colorText,
                          fontFamily: Constants.montserratLight,
                          fontSize: 16))
                ])),
        actions: [
          notificationIcon,
          const SizedBox(
            width: 20,
          )
        ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


class AppBarWithGenre extends StatelessWidget implements  PreferredSizeWidget {
  final String screenName;
  final Widget genreField;

  const AppBarWithGenre(
      {super.key, required this.screenName, required this.genreField});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  alignment: Alignment.center,
                  child: Text(screenName,
                      style: const TextStyle(
                          color: Constants.colorOnSurface,
                          fontFamily: Constants.montserratSemibold,
                          fontSize: 22))),
              const SizedBox(
                height: 20,
              ),
              genreField,
            ]));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String screenName;

  const CustomAppbar({Key? key, required this.screenName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Constants.scaffoldColor,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          screenName,
          style: const TextStyle(
            color: Constants.colorOnSurface,
            fontFamily: Constants.montserratRegular,
            fontSize: 22,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Constants.colorOnSurface),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

