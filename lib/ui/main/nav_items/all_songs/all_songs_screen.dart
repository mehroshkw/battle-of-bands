import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/ui/my_song_details/my_song_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/app_button.dart';
import '../../../../common/app_text_field.dart';
import '../../../../common/custom_appbar.dart';
import '../../../../util/app_strings.dart';
import '../../../../util/constants.dart';
import '../../main_bloc.dart';
import '../../mian_bloc_state.dart';

class AllSongsScreen extends StatelessWidget {
  static const String key_title = '/all_songs';
  const AllSongsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final bloc = context.read<MainScreenBloc>();

    return Scaffold(
      body: Column(
        children: [
        AppBarWithGenre(
        screenName: AppText.MY_SONG,
        genreField:
        BlocBuilder<MainScreenBloc, MainScreenState>(builder: (_, state) {
          return PopupMenuButton<String>(
            enabled: true,
            color: Constants.colorPrimaryVariant,
            shadowColor: Colors.transparent,
            splashRadius: 0,
            elevation: 0,
            padding: EdgeInsets.zero,
            offset: const Offset(0, -20),
            tooltip: '',
            constraints: BoxConstraints(minWidth: size.width - 25),
            position: PopupMenuPosition.under,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            itemBuilder: (context) {
              return ['Rock', 'Pop', 'Classic']
                  .map((String genre) => PopupMenuItem(
                value: genre,
                child: SizedBox(
                  height: 20,
                  child: Text(genre,
                      style: const TextStyle(
                        fontFamily: Constants.montserratMedium,
                        fontSize: 15,
                        color: Constants.colorOnPrimary,
                      )),
                ),
              ))
                  .toList();
            },
            onSelected: (value) =>
            bloc.genreController.text = value.toString(),
            child: GenreField(
              controller: bloc.genreController,
              hint: AppText.GENRE,
              readOnly: true,
              textInputType: TextInputType.text,
              isError: false,
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Constants.colorOnSurface,
                size: 20,
              ),
            ),
          );
        }),
      ),
          Expanded(
            child: Container(
              width: size.width,
              height: size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 6,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppText.DATE,
                          style: TextStyle(
                            fontFamily: Constants.montserratLight,
                            color: Constants.colorOnSurface.withOpacity(0.7),
                          ),
                        ),
                        SongTile(url: index.isOdd
                            ?'assets/song_icon2.png'
                          :'assets/song_icon.png' ,),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width-30,
            height: 50,
            child: AppButton(text: 'Upload Song', onClick: (){
              Navigator.pushNamed(context, MySongDetailScreen.route);
            },
            color: Constants.colorPrimary,
            ),
          )
      ])
    );
  }
}

class SongTile extends StatelessWidget {
  final String url;
  // final Function onChanged;
  const SongTile({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainScreenBloc>();
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      width: size.width - 30,
      decoration: BoxDecoration(
          color: Constants.colorPrimaryVariant.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [

          Image.asset(url,width: 60,height: 55),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppText.SONG_NAME,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: Constants.montserratSemibold,
                      fontSize: 16,
                      color: Constants.colorOnPrimary),
                ),
                const Text(
                  AppText.PERFORMER_BAND,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: Constants.montserratLight,
                      fontSize: 14,
                      color: Constants.colorPrimary),
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
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/play.png'),
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: Text(
                  AppText.VOTES,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: Constants.montserratSemibold,
                      fontSize: 14,
                      color: Constants.colorOnPrimary),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}