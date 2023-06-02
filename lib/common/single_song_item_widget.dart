import 'package:battle_of_bands/ui/main/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../backend/server_response.dart';
import '../util/app_strings.dart';
import '../util/constants.dart';

class SingeSongItemWidget extends StatelessWidget {
  final Song song;
  const SingeSongItemWidget({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainScreenBloc>();
    final Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(song.date,
            style: TextStyle(
              fontFamily: Constants.montserratLight,
              color: Constants.colorOnSurface.withOpacity(0.7),
            )),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          width: size.width - 30,
          decoration: BoxDecoration(color: Constants.colorPrimaryVariant.withOpacity(0.95), borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Image.asset('assets/song_icon2.png', width: 60, height: 55),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontFamily: Constants.montserratSemibold, fontSize: 16, color: Constants.colorOnPrimary),
                    ),
                    Text(
                      song.bandName,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontFamily: Constants.montserratLight, fontSize: 14, color: Constants.colorPrimary),
                    ),
                    Text(
                      bloc.formatDuration(song.duration.toInt()),
                      style: TextStyle(
                        fontFamily: Constants.montserratLight,
                        color: Constants.colorOnSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/play.png'),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      '${AppText.VOTES} ${song.votesCount}',
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontFamily: Constants.montserratSemibold, fontSize: 14, color: Constants.colorOnPrimary),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
