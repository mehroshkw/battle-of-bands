import 'dart:io';

import 'package:battle_of_bands/util/app_strings.dart';
import 'package:battle_of_bands/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const _App());
}

final _mySystemTheme = SystemUiOverlayStyle.light.copyWith(
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    statusBarColor: Constants.colorOnSurface);

const _colorScheme = ColorScheme(
    primary: Constants.colorPrimary,
    primaryContainer: Constants.colorPrimaryVariant,
    secondary: Constants.colorSecondaryVariant,
    secondaryContainer: Constants.colorSecondaryVariant,
    surface: Constants.colorSurface,
    background: Constants.colorBackground,
    error: Constants.colorError,
    onPrimary: Constants.colorOnPrimary,
    onSecondary: Constants.colorOnSecondary,
    onSurface: Constants.colorOnSurface,
    onBackground: Constants.colorOnBackground,
    onError: Constants.colorOnError,
    brightness: Brightness.light);

ThemeData _buildAppThemeData() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      colorScheme: _colorScheme,
      primaryColor: Constants.colorPrimary,
      unselectedWidgetColor: Constants.colorOnIcon,
      scaffoldBackgroundColor: Constants.colorOnSurface,
      errorColor: Constants.colorError);
}

class _AppRouter {
  Route _getPageRoute(Widget screen) => Platform.isIOS
      ? CupertinoPageRoute(builder: (_) => screen)
      : MaterialPageRoute(builder: (_) => screen);


  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case SplashScreen.route:
      //   {
      //     const screen = SplashScreen();
      //     return _getPageRoute(screen);
      //   }
      //
    }
    return null;
  }

  void dispose() {}
}

class _App extends StatefulWidget {
  const _App();

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<_App>{
  final _AppRouter __appRouter = _AppRouter();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(_mySystemTheme);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: AppText.APP_NAME,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: __appRouter.onGenerateRoute,
        theme: _buildAppThemeData());
  }
  @override
  void dispose() {
    __appRouter.dispose();
    super.dispose();
  }
}
