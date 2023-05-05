import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/app_text_field.dart';
import '../../../../common/custom_appbar.dart';
import '../../../../helper/dilogue_helper.dart';
import '../../../../helper/material_dialogue_content.dart';
import '../../../../util/app_strings.dart';
import '../../../../util/constants.dart';
import '../../main_bloc.dart';
import '../../mian_bloc_state.dart';

class BattleScreen extends StatelessWidget {
  static const String key_title = '/battle_screen';

  const BattleScreen({Key? key}) : super(key: key);

  Future<void> _showDialogue(MainScreenBloc bloc, BuildContext context, MaterialDialogHelper dialogHelper) async {
    dialogHelper
      ..injectContext(context)
      ..showProgressDialog("Processing");
    try {
      dialogHelper.dismissProgress();
      dialogHelper.showVoteDialogue();

    } catch (_) {
      dialogHelper.dismissProgress();
      dialogHelper.showMaterialDialogWithContent(MaterialDialogContent.networkError(), () => _showDialogue(bloc, context, dialogHelper));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final bloc = context.read<MainScreenBloc>();

    return Scaffold(
        body: Column(
      children: [
        AppBarWithGenre(
          screenName: AppText.BATTLES,
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
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/battles_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return SongWidget(onChanged: (){
                    _showDialogue(bloc, context, MaterialDialogHelper.instance());
                  },);
                },
              ),
            ),
          ),
        )
      ],
    ));
  }
}

class SongWidget extends StatelessWidget {
  final Function onChanged;
  const SongWidget({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainScreenBloc>();
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      height: size.height / 2.8,
      width: size.width - 30,
      decoration: BoxDecoration(
          color: Constants.colorPrimaryVariant.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.asset('assets/song_icon.png')),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: size.width / 1.75,
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
                  Container(
                    padding: const EdgeInsets.only(bottom: 10, left: 10),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      AppText.SONG_NAME,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: Constants.montserratBold,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Constants.colorOnPrimary),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10, left: 10),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      AppText.PERFORMER_BAND,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: Constants.montserratLight,
                          fontSize: 16,
                          color: Constants.colorOnPrimary),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: size.width,
            child: Image.asset('assets/song_slider.png'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppText.SONG_START_TIME,
                style: TextStyle(
                  fontFamily: Constants.montserratLight,
                  color: Constants.colorOnSurface.withOpacity(0.7),
                ),
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
              child: BlocBuilder<MainScreenBloc, MainScreenState>(
                  builder: (_, state) {
                return Row(
                  children: [
                    // Theme(
                    //   data: ThemeData(
                    //     checkboxTheme: CheckboxThemeData(
                    //       fillColor: MaterialStateProperty.all(Colors.transparent),
                    //       shape: RoundedRectangleBorder(
                    //         side: BorderSide(width: 1, color: Colors.white),
                    //         borderRadius: BorderRadius.circular(4),
                    //       ),
                    //       side: BorderSide(
                    //         color: Constants.colorOnSurface,
                    //       ),
                    //
                    //     ),
                    //   ),
                    //   child: Checkbox(
                    //     value: state.isVote,
                    //     onChanged: (bool? value) {
                    //       if(value==null)return;
                    //       bloc.toggleVote();
                    //     },
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                        left: 20.0,
                      ),
                      child: CustomCheckbox(
                        isChecked: state.isVote,
                        onChanged: (bool? value) {
                          if (value == null) return;
                          bloc.toggleVote();
                          if (value) {
                            onChanged.call();
                          }
                        },
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
                );
              }))
        ],
      ),
    );
  }
}

class CustomCheckbox extends StatefulWidget {
  final bool isChecked;
  final Function(bool) onChanged;

  const CustomCheckbox({
    Key? key,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
          widget.onChanged(_isChecked);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(4.0),
          color: _isChecked ? Colors.transparent : Colors.transparent,
        ),
        width: 18.0,
        height: 18.0,
        child: _isChecked
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 14.0,
              )
            : null,
      ),
    );
  }
}
