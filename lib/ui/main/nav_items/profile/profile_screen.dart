import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const String key_title = '/profile';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('profile'),
      ),
    );
  }
}
