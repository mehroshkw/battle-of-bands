import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helper/shared_preference_helper.dart';
import 'auth/login/login_screen.dart';
import 'main/main_screen.dart';


class SplashScreen extends StatefulWidget {
  static const String route = '/';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getUser();
    super.initState();
  }

  Future<void> getUser() async {
    final user = SharedPreferenceHelper.instance().isUserLoggedIn;
    final route = user ? MainScreen.route : LoginScreen.route;
    Future.delayed(const Duration(milliseconds: 1500)).then((_) {
      Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    return Container(
        width: size.width,
        height: size.height,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/bg_splash.png'),
              fit: BoxFit.fill,
            ),
            color: Constants.scaffoldColor),
        child:  Image.asset('assets/logo.png', height: size.height/2, width:  size.width/1.6,),
    );
  }
}

