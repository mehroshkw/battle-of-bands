import 'package:battle_of_bands/backend/shared_web_services.dart';
import 'package:battle_of_bands/ui/main/mian_bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/meta_data.dart';
import '';

class MainScreenBloc extends Cubit<MainScreenState> {
  BuildContext? textFieldContext;
  Key inputKey = GlobalKey();
  final GlobalKey globalKey = GlobalKey(debugLabel: 'btm_app_bar');
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController leaderBoardGenreController = TextEditingController();
  TextEditingController battlesGenreController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  final SharedWebService _sharedWebService = SharedWebService.instance();

  MainScreenBloc() : super(MainScreenState.initial()) {
    getStatistics();
  }

  getStatistics() async {
    final statistics = await _sharedWebService.getStatistics(4);
    emit(state.copyWith(statistics: statistics));
  }

  void updateIndex(int index) {
    emit(state.copyWith(index: index));
  }

  void toggleVote() {
    emit(state.copyWith(isVote: !state.isVote));
  }

  void toggleNoMusic() {
    emit(state.copyWith(isNoMusic: !state.isNoMusic));
  }
}
