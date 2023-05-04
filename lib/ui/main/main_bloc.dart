import 'package:battle_of_bands/ui/main/mian_bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/meta_data.dart';


class MainScreenBloc extends Cubit<MainScreenState> {

  BuildContext? textFieldContext;
  Key inputKey = GlobalKey();
  final GlobalKey globalKey = GlobalKey(debugLabel: 'btm_app_bar');
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController genreController = TextEditingController();

  MainScreenBloc():super(MainScreenState.initial());


  void updateIndex(int index) {
   emit(state.copyWith(index: index));
  }

  // void toggleSwitch() {
  //   isSwitch.value = !isSwitch.value;
  // }
}