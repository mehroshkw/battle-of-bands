import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/util/app_strings.dart';
import 'package:flutter/material.dart';
import '../../common/custom_appbar.dart';
import '../../util/constants.dart';

class MySongDetailScreen extends StatelessWidget {
  static const String route = '/my_song_details_screen';

  const MySongDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    return  Scaffold(
      appBar: const CustomAppbar(screenName: AppText.MY_SONG,),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                AppText.GENRE_NAME,
                style: TextStyle(
                  fontFamily: Constants.montserratRegular,
                  color: Constants.colorPrimary,
                  fontSize: 18
                ),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppText.DATE,
                  style: TextStyle(
                    fontFamily: Constants.montserratLight,
                    color: Constants.colorOnSurface.withOpacity(0.7),
                  ),
                ),
                Image.asset('assets/share.png'),
              ],
            ),
        SizedBox(height: 10,),
        Container(
          width: size.width-20,
          height: size.height/3,
          decoration:  BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/song_img.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20)
          ),
        )
          ],
        ),
      )
    );
  }
}
