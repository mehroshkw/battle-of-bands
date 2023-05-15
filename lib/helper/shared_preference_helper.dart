import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend/server_response.dart';

SharedPreferences? _sharedPreferences;

@immutable
class SharedPreferenceHelper {
  static const String _USER = 'SharedPreferenceHelper.user';
  static const String _IS_SIGN_UP_PROFILE_COMPLETE = 'SharedPreferenceHelper.is_sign_up_profile_complete';

  static SharedPreferenceHelper? _instance;

  const SharedPreferenceHelper._();

  static SharedPreferenceHelper instance() {
    _instance ??= const SharedPreferenceHelper._();
    return _instance!;
  }

  static Future<void> initializeSharedPreferences() async => _sharedPreferences = await SharedPreferences.getInstance();

  bool get isUserLoggedIn => _sharedPreferences?.containsKey(_USER) ?? false;
  Future<LoginResponse?> get user async {
    final userSerialization = _sharedPreferences?.getString(_USER);
    if (userSerialization == null) return null;
    try {
      return LoginResponse.fromJson(json.decode(userSerialization));
    } catch (_) {
      return null;
    }
  }
  Future<void> insertUser(LoginResponse user) async {
    print('ghgygygy');
    final userSerialization = json.encode(user.toJson());
    print('7777');
    _sharedPreferences?.setString(_USER, userSerialization);
  }

  set isSignupComplete(bool value) => _sharedPreferences?.setBool(_IS_SIGN_UP_PROFILE_COMPLETE, value);

  bool get isSignupComplete => _sharedPreferences?.getBool(_IS_SIGN_UP_PROFILE_COMPLETE) ?? false;

  Future<void> clear() async => _sharedPreferences?.clear();
}