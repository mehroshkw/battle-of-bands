import 'package:battle_of_bands/data/meta_data.dart';
import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/helper/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../backend/server_response.dart';
import '../../../common/app_text_field.dart';
import '../../../common/custom_appbar.dart';
import '../../../helper/dilogue_helper.dart';
import '../../../util/app_strings.dart';
import '../../../util/constants.dart';
import '../main_bloc.dart';
import '../mian_bloc_state.dart';

class BattleScreen extends StatelessWidget {
  static const String key_title = '/battle_screen';

  const BattleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final bloc = context.read<MainScreenBloc>();

    return Column(
      children: [
        BlocListener<MainScreenBloc, MainScreenState>(
            listenWhen: (previous, current) => previous.snackbarMessage != current.snackbarMessage,
            listener: (_, state) async {
              final snackbarMessage = state.snackbarMessage;
              if (snackbarMessage.message.isEmpty) return;
              SnackbarHelper.instance
                ..injectContext(context)
                ..showSnackbar(
                  snackbar: snackbarMessage,
                );
            },
            child: const SizedBox(height: kToolbarHeight - 20)),
        AppBarWithGenre(
          screenName: AppText.BATTLES,
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
                  onSelected: (genre) => bloc.updateBattleByChangeGenreId(genre),
                  child: GenreField(
                    controller: bloc.battlesGenreController,
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
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/battles_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: BlocBuilder<MainScreenBloc, MainScreenState>(builder: (_, state) {
                final battleDataEvent = state.battleDataEvent;
                if (battleDataEvent is Loading) {
                  return const Center(child: CircularProgressIndicator.adaptive(backgroundColor: Constants.colorPrimary));
                } else if (battleDataEvent is Empty || battleDataEvent is Initial) {
                  return const Text(AppText.BATTLE_CONTENT,
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontFamily: Constants.montserratRegular, color: Constants.colorOnSurface));
                } else if (battleDataEvent is Data) {
                  final items = battleDataEvent.data as List<Song>;
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SongWidget(
                        song: items[index],
                        onChanged: () {
                          MaterialDialogHelper.instance()
                            ..injectContext(context)
                            ..showVoteDialogue(positiveClickListener: () {
                              bloc.voteUnVoteBattleSong(items[index]);
                            });
                        },
                      );
                    },
                  );
                } else {
                  return const SizedBox();
                }
              }),
            ),
          ),
        )
      ],
    );
  }
}

class SongWidget extends StatelessWidget {
  final Function onChanged;
  final Song song;

  const SongWidget({Key? key, required this.onChanged, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainScreenBloc>();
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      width: size.width - 30,
      decoration: BoxDecoration(color: Constants.colorPrimaryVariant.withOpacity(0.95), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                      height: 90,
                      width: 90,
                      child: song.user.imagePath.isEmpty ? Image.asset('assets/song_icon.png') : Image.network('$BASE_URL_IMAGE/${song.user.imagePath}', fit: BoxFit.cover))),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        'assets/share.png',
                        height: 30,
                        width: 30,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 10),
                      child: Text(
                        song.title,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontFamily: Constants.montserratBold, fontSize: 20, fontWeight: FontWeight.bold, color: Constants.colorOnPrimary),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                        child: Text(
                          '${AppText.PERFORMER_BAND}${song.bandName}',
                          textAlign: TextAlign.left,

                          style: const TextStyle(
                              fontFamily: Constants.montserratLight,
                              fontSize: 16,
                              color: Constants.colorText),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: size.width,
            child: Image.asset('assets/song_slider.png'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                AppText.SONG_START_TIME,
                style: TextStyle(
                  fontFamily: Constants.montserratLight,
                  color: Constants.colorText,
                ),
              ),
              Text(
                AppText.SONG_END_TIME,
                style: TextStyle(
                  fontFamily: Constants.montserratLight,
                  color: Constants.colorText,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/3x/previous.png', height: 20, width: 20),
              Image.asset('assets/3x/back.png', height: 20, width: 20),
              Image.asset('assets/3x/play_big.png', height: 50, width: 50),
              Image.asset('assets/3x/forward.png', height: 20, width: 20),
              Image.asset('assets/3x/next.png', height: 20, width: 20),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
              height: 35,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Constants.colorPrimary,
                  width: 1,
                ),
                shape: BoxShape.rectangle,
                color: Constants.colorPrimaryVariant.withOpacity(0.95),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                  left: 20.0,
                ),
                child: CustomCheckbox(
                  isChecked: song.isVoted,
                  onChanged: (bool? value) {
                    if (value == null) return;
                      onChanged.call();
                  },
                ),
              ))
        ],
      ),
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final bool isChecked;
  final Function(bool) onChanged;

  const CustomCheckbox({
    Key? key,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainScreenBloc>();
    return InkWell(
      onTap: () {
        onChanged.call(isChecked);
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.transparent,
              ),
              width: 18.0,
              height: 18.0,
              child: isChecked
                  ? null
                  : const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14.0,
                    ),
            ),
          ),
          const Text(
            AppText.VOTE,
            style: TextStyle(
              fontFamily: Constants.montserratLight,
              color: Constants.colorOnSurface,
            ),
          ),
        ],
      ),
    );
  }
}
