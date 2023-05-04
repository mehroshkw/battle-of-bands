import 'package:flutter/material.dart';

class AllSongsScreen extends StatelessWidget {
  static const String key_title = '/all_songs';
  const AllSongsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('All songs'),
      ),
    );
  }
}
