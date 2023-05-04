import 'package:battle_of_bands/ui/auth/forget_password/forget_password_controller.dart';
import 'package:battle_of_bands/ui/auth/forget_password/forget_password_screen.dart';
import 'package:battle_of_bands/ui/auth/login/login_bloc.dart';
import 'package:battle_of_bands/ui/auth/login/login_screen.dart';
import 'package:battle_of_bands/ui/auth/signup/signup_bloc.dart';
import 'package:battle_of_bands/ui/auth/signup/signup_screen.dart';
import 'package:battle_of_bands/ui/main/main_bloc.dart';
import 'package:battle_of_bands/ui/main/main_screen.dart';
import 'package:battle_of_bands/ui/splash_screen.dart';
import 'package:battle_of_bands/util/app_strings.dart';
import 'package:battle_of_bands/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'helper/bottom_sheet_helper.dart';

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
    brightness: Brightness.light);

ThemeData _buildAppThemeData() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      primaryColor: Constants.colorPrimary,
      unselectedWidgetColor: Constants.colorOnIcon,
      scaffoldBackgroundColor: Constants.scaffoldColor,
      colorScheme: _colorScheme.copyWith(error: Constants.colorError));
}

class _AppRouter {
  Route _getPageRoute(Widget screen) =>
      Platform.isIOS ? CupertinoPageRoute(builder: (_) => screen) : MaterialPageRoute(builder: (_) => screen);

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

class _AppState extends State<_App> {
  final _AppRouter __appRouter = _AppRouter();

  @override
  void initState() {
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

// /// all pages with screen and their specific controllers will register here...
// final List<GetPage<dynamic>> _pages = [
//   GetPage(
//       name: SplashScreen.route,
//       page: () {
//         const screen = SplashScreen();
//         return screen;
//       }),
//   GetPage(
//       name: LoginScreen.route,
//       page: () {
//         const screen = LoginScreen();
//         return screen;
//       },
//       binding: BindingsBuilder(() => Get.lazyPut(() {
//             return LoginController();
//           }))),
//   GetPage(
//       name: ForgetPasswordScreen.route,
//       page: () {
//         const screen = ForgetPasswordScreen();
//         return screen;
//       },
//       binding: BindingsBuilder(() => Get.lazyPut(() {
//         return ForgetPasswordController();
//       }))),
//   GetPage(
//       name: SignupScreen.route,
//       page: () {
//         const screen = SignupScreen();
//         return screen;
//       },
//       binding: BindingsBuilder(() => Get.lazyPut(() {
//         return SignupController();
//       }))),
//   GetPage(
//       name: MainScreen.route,
//       page: () {
//         const screen = MainScreen();
//         return screen;
//       },
//       binding: BindingsBuilder(() => Get.lazyPut(() {
//         return MainScreenController();
//       }))),
// ];
//
// /// top-level dependencies will register here...
// final Bindings _bindings = BindingsBuilder(() {
//   Get.lazyPut(() => BottomSheetHelper.instance());
//   // Get.lazyPut(() => SharedPreferenceHelper.instance());
//   // Get.lazyPut(() => SharedWebService.instance());
// });
//
// const _cupertinoThemeData = CupertinoThemeData(
//     brightness: Brightness.light,
//     primaryColor: Constants.scaffoldColor,
//     primaryContrastingColor: Constants.scaffoldColor,
//     barBackgroundColor: Constants.scaffoldColor,
//     scaffoldBackgroundColor: Constants.scaffoldColor);
//
// final _androidThemeData = ThemeData(
//     cardColor: Constants.colorOnSecondary,
//     colorScheme: const ColorScheme(
//         brightness: Brightness.light,
//         primary: Constants.colorPrimary,
//         onPrimary: Constants.scaffoldColor,
//         secondary: Constants.colorSecondary,
//         onSecondary: Constants.colorOnSecondary,
//         secondaryContainer: Constants.colorPrimaryVariant,
//         error: Constants.colorError,
//         onError: Constants.colorOnError,
//         background: Constants.scaffoldColor,
//         onBackground: Constants.onScaffoldColor,
//         surface: Constants.scaffoldColor,
//         onSurface: Constants.colorOnSurface),
//     brightness: Brightness.light,
//     useMaterial3: true);
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // await SharedPreferenceHelper.initializeSharedPreferences();
//
//   runApp(GetMaterialApp(
//       theme: _androidThemeData,
//       title: AppText.APP_NAME,
//       themeMode: ThemeMode.system,
//       initialRoute: SplashScreen.route,
//       debugShowCheckedModeBanner: false,
//       getPages: _pages,
//       initialBinding: _bindings));
// }
