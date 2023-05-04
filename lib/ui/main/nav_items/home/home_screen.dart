import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/app_text_field.dart';
import '../../../../common/custom_appbar.dart';
import '../../../../util/constants.dart';
import '../../main_bloc.dart';
import '../../mian_bloc_state.dart';

class HomeScreen extends StatelessWidget {
  static const String key_title = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainScreenBloc>();
    final size = context.screenSize;
    return Scaffold(
      appBar: CustomAppBar(userName: 'Hello Diana', userEmail: 'dian@email.com', notificationIcon: Image.asset('assets/Group 12408.png',),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              alignment: Alignment.centerLeft,
              child:  const Text('Statistics',
                  textAlign: TextAlign.left,
                  style:
                  TextStyle(fontFamily: Constants.montserratMedium, fontSize: 18, color: Constants.colorOnPrimary)),
            ),
            RoundedContainer(),
            const SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              alignment: Alignment.centerLeft,
              child:  const Text('Leaderboard',
                  textAlign: TextAlign.left,
                  style:
                  TextStyle(fontFamily: Constants.montserratMedium, fontSize: 22, color: Constants.colorOnPrimary)),
            ),
        BlocBuilder<MainScreenBloc, MainScreenState>(
            builder: (_, state) {
                return PopupMenuButton<String>(
                  enabled: true,
                  color: Constants.colorPrimaryVariant,
                  shadowColor: Colors.transparent,
                  splashRadius: 0,
                  elevation: 0,

                  padding: EdgeInsets.zero,
                  offset: Offset(0,-20),
                  tooltip: '',
                  constraints: BoxConstraints(
                      minWidth: size.width - 48),
                  position: PopupMenuPosition.under,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  itemBuilder: (context) {
                    return [ 'Rock', 'Pop', 'Classic']
                        .map((String genre) =>
                        PopupMenuItem(
                          value: genre,
                          child: SizedBox(
                            height: 20,
                            child: Text(genre, style: const TextStyle(
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
                    hint: 'Genre',
                    readOnly: true,
                    textInputType: TextInputType.text,
                    isError: false,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: Constants.colorOnSurface,
                      size: 20,),),
                );

            }),
          ],
        ),
      )
    );
  }
}

class RoundedContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;

    return Container(
      height: size.height / 3.5,
      width: size.width,
      child: Row(
        children: [
          Column(
            children: [
              Container(
                height: 105,
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
                      'Total Uploads',
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
                        child: const Text(
                          '86',
                          textAlign: TextAlign.left,
                          style: TextStyle(
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
              const SizedBox(height: 8),
              Container(
                height: 105,
                width: 170,
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
                      'Total Battles',
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
                        child: const Text(
                          '66',
                          textAlign: TextAlign.left,
                          style: TextStyle(
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
                  'Total wins',
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
                    child: const Text('36',
                        textAlign: TextAlign.left,
                        style:
                        TextStyle(
                            fontFamily: Constants.montserratMedium, fontSize: 26, color: Constants.colorOnPrimary)),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10,),
                const Text('Total Losses',
                    textAlign: TextAlign.left,
                    style:
                    TextStyle(fontFamily: Constants.montserratMedium, fontSize: 12, color: Constants.colorOnPrimary)),
                Expanded(child: Container(
                  alignment: Alignment.center,
                  child: const Text('30',
                      textAlign: TextAlign.left,
                      style:
                      TextStyle(fontFamily: Constants.montserratMedium, fontSize: 26, color: Constants.colorOnPrimary)),
                ),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
