import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:battle_of_bands/ui/my_song_details.dart';
import 'package:battle_of_bands/util/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/app_text_field.dart';
import '../../../common/custom_appbar.dart';
import '../../../util/constants.dart';
import '../main_bloc.dart';
import '../mian_bloc_state.dart';

class HomeScreen extends StatelessWidget {
  static const String key_title = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainScreenBloc>();
    final size = context.screenSize;
    return Scaffold(
        appBar: CustomAppBar(
          userName: 'Hello Diana',
          userEmail: 'dian@email.com',
          notificationIcon: GestureDetector(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context, _, __) => NotificationView()));
            },
            child: Image.asset(
              'assets/Group 12408.png',
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                alignment: Alignment.centerLeft,
                child: const Text(AppText.STATISTICS,
                    textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 18, color: Constants.colorOnPrimary)),
              ),
              const RoundedContainer(),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                alignment: Alignment.centerLeft,
                child: const Text(AppText.LEADERBOARD,
                    textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 22, color: Constants.colorOnPrimary)),
              ),
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
                  constraints: BoxConstraints(minWidth: size.width - 48),
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
                  onSelected: (value) => bloc.leaderBoardGenreController.text = value.toString(),
                  child: GenreField(
                    controller: bloc.leaderBoardGenreController,
                    hint: AppText.GENRE,
                    isError: false,
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Constants.colorOnSurface,
                      size: 20,
                    ),
                    textInputType: TextInputType.text,
                  ),
                );
              }),
              const _SingleLeaderboardItem(rankNumber: '1st', isCrown: true, color: Constants.colorYellow, image: 'assets/3x/song_icon.png', vote: 150),
              const _SingleLeaderboardItem(rankNumber: '2st', isCrown: false, color: Color(0xffC0C0C0), image: 'assets/3x/song_icon.png', vote: 110),
              const _SingleLeaderboardItem(rankNumber: '3st', isCrown: false, color: Constants.colorPrimary, image: 'assets/3x/song_icon.png', vote: 100)
            ],
          ),
        ));
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
      child: BlocBuilder<MainScreenBloc,MainScreenState>(
        builder: (_,state)=>
         Row(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    width: 170,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.6, 1.0],
                        colors: [
                          Constants.colorPrimary,
                          Constants.colorGradientDark,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppText.TOTAL_UPLOADS,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: Constants.montserratMedium,
                            fontSize: 12,
                            color: Constants.colorOnPrimary,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child:  Text(
                              '${state.statistics.totalUploads}',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontFamily: Constants.montserratMedium,
                                fontSize: 26,
                                color: Constants.colorOnPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppText.TOTAL_BATTLES,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: Constants.montserratMedium,
                            fontSize: 12,
                            color: Constants.colorOnPrimary,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child:  Text(
                              '${state.statistics.totalBattles}',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontFamily: Constants.montserratMedium,
                                fontSize: 26,
                                color: Constants.colorOnPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Container(
              height: 220,
              width: 133,
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
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text(
                    AppText.TOTAL_WINS,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: Constants.montserratMedium,
                      fontSize: 12,
                      color: Constants.colorOnPrimary,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child:  Text('${state.statistics.totalWins}', textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 26, color: Constants.colorOnPrimary)),
                    ),
                  ),
                  const Divider(color: Constants.scaffoldColor, thickness: 1),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(AppText.TOTAL_LOSES, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 12, color: Constants.colorOnPrimary)),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child:  Text('${state.statistics.totalLoses}', textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 26, color: Constants.colorOnPrimary)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SingleLeaderboardItem extends StatelessWidget {
  final String rankNumber;
  final bool isCrown;
  final Color color;
  final String image;
  final int vote;

  const _SingleLeaderboardItem({required this.rankNumber, required this.isCrown, required this.color, required this.image, required this.vote});

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;

    return SizedBox(
      child: Stack(alignment: Alignment.center, children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, MySongDetailScreen.route, arguments: false),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isCrown ? 90 : 30),
              Text(rankNumber, textAlign: TextAlign.left, style: const TextStyle(fontFamily: Constants.montserratMedium, fontSize: 18, color: Constants.colorOnPrimary)),
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(10),
                height: 75,
                width: size.width,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(width: 0.5, color: Constants.colorGreen), color: Constants.colorPrimaryVariant),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Image(image: AssetImage('assets/3x/play.png'), width: 30, height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('00:30', textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.montserratRegular, fontSize: 14, color: Constants.colorGradientDark)),
                        Text(AppText.PERFORMER_BANDNAME, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.montserratMedium, fontSize: 14, color: color)),
                        Text('Vote $vote',
                            textAlign: TextAlign.left, style: const TextStyle(fontFamily: Constants.montserratRegular, fontSize: 14, color: Constants.colorOnPrimary)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            isCrown ? const Image(image: AssetImage('assets/crown.png'), width: 30, height: 30) : const SizedBox(),
            Container(
              width: isCrown ? 100 : 70,
              height: isCrown ? 100 : 70,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 4, color: color), image: DecorationImage(image: AssetImage(image))),
            )
          ],
        )
      ]),
    );
  }
}

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.scaffoldColor.withOpacity(0.6),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              margin: const EdgeInsets.only(top: 80.0, left: 20, right: 20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Constants.colorSecondaryVariant.withOpacity(0.8)),
              child: Column(
                children: const [
                  NotificationTile(),
                  Divider(color: Constants.colorOnSurface),
                  NotificationTile(),
                  Divider(color: Constants.colorOnSurface),
                  NotificationTile(),
                  Divider(color: Constants.colorOnSurface),
                  NotificationTile(),
                  Divider(color: Constants.colorOnSurface),
                  NotificationTile(),
                ],
              ),
            ),
            Expanded(child: Container(color: Colors.transparent))
          ],
        ));
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset('assets/notification_img.png'),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                '${AppText.SONG_NAME} ep.5 ',
                style: TextStyle(fontSize: 13, color: Constants.colorPrimary, fontFamily: Constants.montserratRegular),
              ),
              Text(
                'song',
                style: TextStyle(fontSize: 13, color: Constants.colorOnSurface, fontFamily: Constants.montserratRegular),
              ),
            ],
          ),
          const Text(
            'is in a battle field',
            style: TextStyle(fontSize: 14, color: Constants.colorOnSurface, fontFamily: Constants.montserratRegular),
          ),
        ],
      ),
      trailing: Image.asset('assets/close.png'),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
