import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/util/app_strings.dart';
import 'package:flutter/material.dart';
import '../common/custom_appbar.dart';
import '../util/constants.dart';

class MySongDetailScreen extends StatelessWidget {
  static const String route = '/my_song_details_screen';
  final bool isMySong;

  const MySongDetailScreen({Key? key,required this.isMySong}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    return  Scaffold(
      appBar:  CustomAppbar(screenName:isMySong? AppText.MY_SONG:'Song',),
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
            const SizedBox(height: 20,),
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
        const SizedBox(height: 10,),
        Container(
          width: size.width-20,
          height: size.height/3,
          decoration:  BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/song_img.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20)
          ),
        ),
            const SizedBox(height: 20,),
            const Text(
              AppText.SONG_NAME,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: Constants.montserratSemibold,
                  fontSize: 28,
                  color: Constants.colorOnPrimary),
            ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text(
                AppText.PERFORMER_BAND,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: Constants.montserratLight,
                    fontSize: 20,
                    color: Constants.colorOnSurface.withOpacity(0.8)),
            ),
             ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Text(
                AppText.VOTE_98,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: Constants.montserratRegular,
                    fontSize: 16,
                    color: Constants.colorPrimary),
              ),
            ),
            Image.asset('assets/song_slider.png'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppText.SONG_START_TIME,
                  style: TextStyle(
                    fontFamily: Constants.montserratLight,
                    color: Constants.colorOnSurface.withOpacity(0.7),
                  ),
                ),
                Text(
                  AppText.SONG_END_TIME,
                  style: TextStyle(
                    fontFamily: Constants.montserratLight,
                    color: Constants.colorOnSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/3x/previous.png', height: 20, width: 20),
                Image.asset('assets/3x/back.png', height: 20, width: 20),
                Image.asset('assets/3x/play_big.png', height: 60, width: 60),
                Image.asset('assets/3x/forward.png', height: 20, width: 20),
                Image.asset('assets/3x/next.png', height: 20, width: 20),
              ],
            ),
          ],
        ),
      )
    );
  }
}