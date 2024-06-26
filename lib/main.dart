import 'package:battle_of_bands/backend/server_response.dart';
import 'package:battle_of_bands/ui/auth/change_password/change_password.dart';
import 'package:battle_of_bands/ui/auth/change_password/change_password_bloc.dart';
import 'package:battle_of_bands/ui/auth/forget_password/forget_pass_bloc.dart';
import 'package:battle_of_bands/ui/auth/forget_password/forget_password_screen.dart';
import 'package:battle_of_bands/ui/auth/login/login_bloc.dart';
import 'package:battle_of_bands/ui/auth/login/login_screen.dart';
import 'package:battle_of_bands/ui/auth/signup/signup_bloc.dart';
import 'package:battle_of_bands/ui/auth/signup/signup_screen.dart';
import 'package:battle_of_bands/ui/edit_profile/edit_profile.dart';
import 'package:battle_of_bands/ui/edit_profile/edit_profile_bloc.dart';
import 'package:battle_of_bands/ui/main/main_bloc.dart';
import 'package:battle_of_bands/ui/main/main_screen.dart';
import 'package:battle_of_bands/ui/song_details/my_song_details.dart';
import 'package:battle_of_bands/ui/song_details/my_song_details_bloc.dart';
import 'package:battle_of_bands/ui/splash_screen.dart';
import 'package:battle_of_bands/ui/upload_song/upload_song_bloc.dart';
import 'package:battle_of_bands/ui/upload_song/upload_song_screen.dart';
import 'package:battle_of_bands/util/app_strings.dart';
import 'package:battle_of_bands/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import 'helper/shared_preference_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceHelper.initializeSharedPreferences();
  runApp(const _App());
}

const _colorScheme = ColorScheme(
    primary: Constants.colorPrimary,
    primaryContainer: Constants.colorPrimaryVariant,
    secondary: Constants.colorSecondary,
    secondaryContainer: Constants.colorSecondaryVariant,
    surface: Constants.colorSurface,
    background: Constants.colorBackground,
    error: Constants.colorError,
    onPrimary: Constants.colorOnPrimary,
    onSecondary: Constants.colorOnSecondary,
    onSurface: Constants.colorOnSecondary,
    onBackground: Constants.colorOnBackground,
    onError: Constants.colorOnError,
    brightness: Brightness.dark);

ThemeData _buildAppThemeData() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      primaryColor: Constants.colorPrimary,
      unselectedWidgetColor: Constants.colorOnIcon,
      scaffoldBackgroundColor: Constants.scaffoldColor,
      colorScheme: _colorScheme.copyWith(error: Constants.colorError));
}

class _AppRouter {
  Route _getPageRoute(Widget screen) => Platform.isIOS ? CupertinoPageRoute(builder: (_) => screen) : MaterialPageRoute(builder: (_) => screen);

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.route:
        {
          const screen = SplashScreen();
          return _getPageRoute(screen);
        }
      case LoginScreen.route:
        {
          const screen = LoginScreen();
          return MaterialPageRoute(builder: (_) => BlocProvider(create: (_) => LoginBloc(), child: screen));
        }
      case SignupScreen.route:
        {
          const screen = SignupScreen();
          return MaterialPageRoute(builder: (_) => BlocProvider(create: (_) => SignupBloc(), child: screen));
        }
      case MainScreen.route:
        {
          const screen = MainScreen();
          return MaterialPageRoute(builder: (_) => BlocProvider(create: (_) => MainScreenBloc(), child: screen));
        }
      case MySongDetailScreen.route:
        {
          final arguments = settings.arguments as List<dynamic>;
          final bool isMySong = arguments[0] as bool;
          final song = arguments[1] as List<Song>;
          final int index = arguments[2] as int;
          final screen = MySongDetailScreen(isMySong: isMySong);
          return MaterialPageRoute(builder: (_) => BlocProvider(create: (_) => MySongDetailsBloc(song: song, index: index), child: screen));
        }
      case UploadSongScreen.route:
        {
          const screen = UploadSongScreen();
          return MaterialPageRoute(builder: (_) => BlocProvider(create: (_) => UploadSongBloc(), child: screen));
        }
      case ChangePassword.route:
        {
          const screen = ChangePassword();
          return MaterialPageRoute(builder: (_) => BlocProvider(create: (_) => ChangePasswordScreenBloc(), child: screen));
        }
      case EditProfile.route:
        {
          const screen = EditProfile();
          return MaterialPageRoute(builder: (_) => BlocProvider(create: (_) => EditProfileBloc(), child: screen));
        }
      case ForgetPasswordScreen.route:
        {
          const screen = ForgetPasswordScreen();
          return MaterialPageRoute(builder: (_) => BlocProvider(create: (_) => ForgetPasswordBloc(), child: screen));
        }
    }
    return null;
  }
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    final appRouter = _AppRouter();
    return MaterialApp(title: AppText.APP_NAME, debugShowCheckedModeBanner: false, onGenerateRoute: appRouter.onGenerateRoute, theme: _buildAppThemeData());
  }
}
