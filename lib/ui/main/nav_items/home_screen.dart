import 'package:battle_of_bands/backend/server_response.dart';
import 'package:battle_of_bands/data/meta_data.dart';
import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/ui/song_details/my_song_details.dart';
import 'package:battle_of_bands/util/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/app_text_field.dart';
import '../../../common/custom_appbar.dart';
import '../../../util/constants.dart';
import '../main_bloc.dart';
import '../mian_state.dart';

class HomeScreen extends StatelessWidget {
  static const String key_title = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainScreenBloc>();
    final size = context.screenSize;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: BlocBuilder<MainScreenBloc, MainScreenState>(
                buildWhen: (previous, current) =>
                    previous.userEmail != current.userEmail ||
                    previous.userName != current.userName,
                builder: (_, state) => CustomAppBar(
                    userName: state.userName,
                    userEmail: state.userEmail,
                    notificationIcon: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) =>
                                  const NotificationView()));
                        },
                        child: Image.asset('assets/Group 12408.png'))))),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: const Text(AppText.STATISTICS,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: Constants.montserratMedium,
                          fontSize: 18,
                          color: Constants.colorOnPrimary))),
              const RoundedContainer(),
              const SizedBox(height: 20),
              Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: const Text(AppText.LEADERBOARD,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: Constants.montserratMedium,
                          fontSize: 22,
                          color: Constants.colorOnPrimary))),
              BlocBuilder<MainScreenBloc, MainScreenState>(
                  buildWhen: (previous, current) =>
                      previous.allGenre != current.allGenre,
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
                        constraints: BoxConstraints(minWidth: size.width - 48),
                        position: PopupMenuPosition.under,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        itemBuilder: (context) {
                          return state.allGenre
                              .map((Genre genre) => PopupMenuItem(
                                  value: genre,
                                  child: SizedBox(
                                      height: 20,
                                      child: Text(genre.title,
                                          style: const TextStyle(
                                            fontFamily:
                                                Constants.montserratMedium,
                                            fontSize: 15,
                                            color: Constants.colorOnPrimary,
                                          )))))
                              .toList();
                        },
                        onSelected: (genre) =>
                            bloc.updateLeaderBoardByChangeGenreId(genre),
                        child: GenreField(
                            controller: bloc.leaderBoardGenreController,
                            hint: AppText.GENRE,
                            isError: false,
                            suffixIcon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Constants.colorOnSurface,
                                size: 20),
                            textInputType: TextInputType.text));
                  }),
              BlocBuilder<MainScreenBloc, MainScreenState>(
                  buildWhen: (previous, current) =>
                      previous.leaderBoardDataEvent !=
                      current.leaderBoardDataEvent,
                  builder: (_, state) {
                    final leaderBoardDataEvent = state.leaderBoardDataEvent;
                    if (leaderBoardDataEvent is Loading) {
                      return SizedBox(
                          height: size.height / 3,
                          child: const Center(
                              child: CircularProgressIndicator.adaptive(
                                  backgroundColor: Constants.colorPrimary)));
                    } else if (leaderBoardDataEvent is Empty ||
                        leaderBoardDataEvent is Initial) {
                      return Center(
                          child: Column(children: [
                        Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset('assets/leaderboard.png',
                                height: 70, width: 70)),
                        const Text(AppText.LEADERBOARD_RANKING_CONTENT,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: Constants.montserratSemibold,
                                color: Constants.colorOnSurface)),
                        const SizedBox(height: 5),
                        const Text(AppText.LEADER_BOARD_CONTENT_DUMMY,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: Constants.montserratRegular,
                                color: Constants.colorText)),
                      ]));
                    } else if (leaderBoardDataEvent is Data) {
                      final items = leaderBoardDataEvent.data as List<Song>;
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (_, index) => _SingleLeaderboardItem(
                              index: index,
                              song: items[index],
                              onclick: () => Navigator.pushNamed(
                                  context, MySongDetailScreen.route,
                                  arguments: [false, items[index]])));
                    }
                    return const SizedBox();
                  })
            ])));
  }
}

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
        height: size.height / 3.5,
        width: size.width,
        child: BlocBuilder<MainScreenBloc, MainScreenState>(
            buildWhen: (p, c) =>
                p.statistics.totalUploads != c.statistics.totalUploads,
            builder: (_, state) => Row(children: [
                  Column(children: [
                    Expanded(
                        child: Container(
                            width: 170,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [
                                      0.6,
                                      1.0
                                    ],
                                    colors: [
                                      Constants.colorPrimary,
                                      Constants.colorGradientDark
                                    ]),
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(AppText.TOTAL_UPLOADS,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: Constants.montserratMedium,
                                        fontSize: 12,
                                        color: Constants.colorOnPrimary,
                                      )),
                                  Expanded(
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                              '${state.statistics.totalUploads}',
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  fontFamily: Constants
                                                      .montserratMedium,
                                                  fontSize: 26,
                                                  color: Constants
                                                      .colorOnPrimary))))
                                ]))),
                    Expanded(
                        child: Container(
                            height: 105,
                            width: 170,
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.5, 1.0],
                                  colors: [
                                    Constants.colorPrimary,
                                    Constants.colorGradientDark,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(AppText.TOTAL_BATTLES,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily:
                                              Constants.montserratMedium,
                                          fontSize: 12,
                                          color: Constants.colorOnPrimary)),
                                  Expanded(
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                              '${state.statistics.totalBattles}',
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  fontFamily: Constants
                                                      .montserratMedium,
                                                  fontSize: 26,
                                                  color: Constants
                                                      .colorOnPrimary))))
                                ])))
                  ]),
                  const SizedBox(width: 8),
                  Container(
                      height: 220,
                      width: 133,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [
                                0.5,
                                1.0
                              ],
                              colors: [
                                Constants.colorPrimary,
                                Constants.colorGradientDark
                              ]),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(AppText.TOTAL_WINS,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: Constants.montserratMedium,
                                  fontSize: 12,
                                  color: Constants.colorOnPrimary,
                                )),
                            Expanded(
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Text('${state.statistics.totalWins}',
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            fontFamily:
                                                Constants.montserratMedium,
                                            fontSize: 26,
                                            color: Constants.colorOnPrimary)))),
                            const Divider(
                                color: Constants.scaffoldColor, thickness: 1),
                            const SizedBox(height: 10),
                            const Text(AppText.TOTAL_LOSES,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: Constants.montserratMedium,
                                    fontSize: 12,
                                    color: Constants.colorOnPrimary)),
                            Expanded(
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                        '${state.statistics.totalLoses}',
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            fontFamily:
                                                Constants.montserratMedium,
                                            fontSize: 26,
                                            color: Constants.colorOnPrimary))))
                          ]))
                ])));
  }
}

class _SingleLeaderboardItem extends StatelessWidget {
  final Song song;
  final int index;
  final Function() onclick;

  const _SingleLeaderboardItem(
      {required this.index, required this.song, required this.onclick});

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    ImageProvider image = const AssetImage('assets/3x/song_icon.png');
    if (song.user.imagePath.isNotEmpty) {
      image = NetworkImage('$BASE_URL_DATA/${song.user.imagePath}');
    }

    return SizedBox(
        child: Stack(alignment: Alignment.center, children: [
      GestureDetector(
          onTap: onclick,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: index == 0 ? 90 : 30),
            Text('${index + 1}${ranking(index)}',
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontFamily: Constants.montserratMedium,
                    fontSize: 18,
                    color: Constants.colorOnPrimary)),
            Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(10),
                height: 75,
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 0.5, color: Constants.colorGreen),
                    color: Constants.colorPrimaryVariant),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Image(
                          image: AssetImage('assets/3x/play.png'),
                          width: 30,
                          height: 30),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatDuration(song.duration.toInt()),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontFamily: Constants.montserratRegular,
                                    fontSize: 14,
                                    color: Constants.colorGradientDark)),
                            Text('Perform/${song.bandName}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: Constants.montserratMedium,
                                    fontSize: 14,
                                    color: colorGet(index))),
                            Text('Vote ${song.votesCount}',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontFamily: Constants.montserratRegular,
                                    fontSize: 14,
                                    color: Constants.colorOnPrimary))
                          ])
                    ]))
          ])),
      Column(children: [
        index == 0
            ? const Image(
                image: AssetImage('assets/crown.png'), width: 30, height: 30)
            : const SizedBox(),
        Container(
            width: index == 0 ? 100 : 70,
            height: index == 0 ? 100 : 70,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 4, color: colorGet(index)),
                image: DecorationImage(image: image, fit: BoxFit.cover)))
      ])
    ]));
  }

  String formatDuration(int duration) {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;

    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds = seconds.toString().padLeft(2, '0');

    return '$formattedMinutes:$formattedSeconds';
  }

  colorGet(int index) {
    switch (index) {
      case 0:
        return Constants.colorYellow;
      case 1:
        return const Color(0xffC0C0C0);
      default:
        return Constants.colorPrimary;
    }
  }

  ranking(int index) {
    switch (index) {
      case 0:
        return 'st';
      case 1:
        return 'nd';
      case 2:
        return 'rd';
      default:
        return 'th';
    }
  }
}

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.scaffoldColor.withOpacity(0.6),
        body: Column(children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              margin: const EdgeInsets.only(top: 80.0, left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Constants.colorSecondaryVariant.withOpacity(0.8)),
              child: Column(children: const [
                NotificationTile(),
                Divider(color: Constants.colorOnSurface),
                NotificationTile(),
                Divider(color: Constants.colorOnSurface),
                NotificationTile(),
                Divider(color: Constants.colorOnSurface),
                NotificationTile(),
                Divider(color: Constants.colorOnSurface),
                NotificationTile()
              ])),
          Expanded(child: Container(color: Colors.transparent))
        ]));
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset('assets/notification_img.png'),
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [
          Text('${AppText.SONG_NAME} ep.5 ',
              style: TextStyle(
                  fontSize: 13,
                  color: Constants.colorPrimary,
                  fontFamily: Constants.montserratRegular)),
          Text('song',
              style: TextStyle(
                  fontSize: 13,
                  color: Constants.colorOnSurface,
                  fontFamily: Constants.montserratRegular))
        ]),
        const Text('is in a battle field',
            style: TextStyle(
                fontSize: 14,
                color: Constants.colorOnSurface,
                fontFamily: Constants.montserratRegular))
      ]),
      trailing: Image.asset('assets/close.png'),
      onTap: () {
        Navigator.pop(context);
      }
    );
  }
}
