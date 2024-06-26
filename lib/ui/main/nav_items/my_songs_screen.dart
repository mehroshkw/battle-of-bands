import 'package:battle_of_bands/backend/server_response.dart';
import 'package:battle_of_bands/data/meta_data.dart';
import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/ui/song_details/my_song_details.dart';
import 'package:battle_of_bands/ui/upload_song/upload_song_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/app_button.dart';
import '../../../common/app_text_field.dart';
import '../../../common/custom_appbar.dart';
import '../../../common/error_try_again.dart';
import '../../../common/single_song_item_widget.dart';
import '../../../util/app_strings.dart';
import '../../../util/constants.dart';
import '../main_bloc.dart';
import '../main_state.dart';

class AllSongsScreen extends StatelessWidget {
  static const String key_title = '/all_songs';

  const AllSongsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final bloc = context.read<MainScreenBloc>();

    return Column(children: [
      const SizedBox(height: kToolbarHeight - 20),
      AppBarWithGenre(
          screenName: AppText.MY_SONG,
          genreField: BlocBuilder<MainScreenBloc, MainScreenState>(
              buildWhen: (previous, current) => previous.allGenre != current.allGenre,
              builder: (_, state) {
                return PopupMenuButton<Genre>(
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
                      return state.allGenre
                          .map((Genre genre) => PopupMenuItem(
                                value: genre,
                                child: SizedBox(
                                  height: 20,
                                  child: Text(genre.title,
                                      style: const TextStyle(
                                        fontFamily: Constants.montserratMedium,
                                        fontSize: 15,
                                        color: Constants.colorOnPrimary,
                                      )),
                                ),
                              ))
                          .toList();
                    },
                    onSelected: (genre) => bloc.updateMySongsByChangeGenreId(genre),
                    child: GenreField(
                        controller: bloc.genreController,
                        hint: AppText.GENRE,
                        readOnly: true,
                        textInputType: TextInputType.text,
                        isError: false,
                        suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: Constants.colorOnSurface, size: 20)));
              })),
      BlocBuilder<MainScreenBloc, MainScreenState>(
          buildWhen: (p, c) => p.mySongDataEvent != c.mySongDataEvent,
          builder: (_, state) {
            final mySongDataEvent = state.mySongDataEvent;
            if (mySongDataEvent is Loading) {
              return SizedBox(
                  height: size.height / 2, child: const Center(child: CircularProgressIndicator(backgroundColor: Constants.colorPrimary, color: Constants.colorOnPrimary)));
            } else if (mySongDataEvent is Empty || mySongDataEvent is Initial) {
              return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                const SizedBox(height: 60),
                Image.asset('assets/no_music.png', height: 70, width: 70),
                const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(AppText.NO_SONG, style: TextStyle(fontSize: 20, fontFamily: Constants.montserratRegular, color: Constants.colorOnSurface))),
                const SizedBox(height: 10),
                const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text(
                      AppText.MY_SONGS_SHOW_HERE,
                      style: TextStyle(fontSize: 20, fontFamily: Constants.montserratRegular, color: Constants.colorOnSurface),
                      textAlign: TextAlign.center,
                    )),
                const SizedBox(height: 50)
              ]);
            } else if (mySongDataEvent is Data) {
              final items = mySongDataEvent.data as List<Song>;
              return Expanded(
                  child: SizedBox(
                      width: size.width,
                      height: size.height,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: items.length,
                              itemBuilder: (_, index) {
                                final song = items;
                                return GestureDetector(
                                    onTap: () => Navigator.pushNamed(context, MySongDetailScreen.route, arguments: [true, song, index]),
                                    child: SingeSongItemWidget(song: song[index]));
                              }))));
            } else if (mySongDataEvent is Error) {
              return SizedBox(
                height: size.height / 2,
                child: Center(
                  child: ErrorTryAgain(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    positiveClickListener:()=> bloc.updateMySongsByChangeGenreId,
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
      SizedBox(
          width: size.width - 30,
          height: 50,
          child: AppButton(
              text: 'Upload Song',
              onClick: () async {
                final result = await Navigator.pushNamed(context, UploadSongScreen.route);
                if (result == null) return;
                bloc.updateMySongs(result as Song);
              },
              color: Constants.colorPrimary))
    ]);
  }
}
