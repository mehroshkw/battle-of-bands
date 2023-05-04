import 'package:flutter/material.dart';

import '../util/constants.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String userName;
  final String userEmail;
  final Widget notificationIcon;

  const CustomAppBar({
    required this.userName,
    required this.userEmail,
    required this.notificationIcon,

  });

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
            Text(
              userName,
              style: const TextStyle(
                color: Constants.colorOnSurface,
                fontFamily: Constants.montserratSemibold,
                fontSize: 22,
              ),
            ),
            Text(
              userEmail,
              style: const TextStyle(
                color: Constants.colorOnSurface,
                fontFamily: Constants.montserratLight,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      actions: [
      notificationIcon,
        SizedBox(width: 20,),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppBarWithGenre extends StatelessWidget with PreferredSizeWidget {
  final String screenName;
  final Widget genreField;

  const AppBarWithGenre({
    required this.screenName,
    required this.genreField,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Constants.scaffoldColor,
      padding: EdgeInsets.all(10),
      child:
     Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Container(
           alignment: Alignment.center,
           child: Text(
             screenName,
             style: const TextStyle(
               color: Constants.colorOnSurface,
               fontFamily: Constants.montserratSemibold,
               fontSize: 22,
             ),
           ),
         ),
         SizedBox(height: 20,),
         genreField,
       ],
     ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}