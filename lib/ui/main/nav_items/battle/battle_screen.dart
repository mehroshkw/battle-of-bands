import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/app_text_field.dart';
import '../../../../common/custom_appbar.dart';
import '../../../../util/constants.dart';
import '../../main_bloc.dart';
import '../../mian_bloc_state.dart';

class BattleScreen extends StatelessWidget {
  static const String key_title = '/battle_screen';
  const BattleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final bloc = context.read<MainScreenBloc>();

    return Scaffold(
      body: Column(
        children: [
          AppBarWithGenre(screenName: 'Battles',
            genreField:  BlocBuilder<MainScreenBloc, MainScreenState>(
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
                        minWidth: size.width - 25),
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
          ),
          Expanded(
            child: Container(
              width: size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/battles_bg.png'),
                  fit: BoxFit.cover,
                ),
            ),
            
            ),
          )
        ],
      )
    );
  }
}
