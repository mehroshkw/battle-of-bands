import 'package:battle_of_bands/backend/shared_web_services.dart';
import 'package:battle_of_bands/data/meta_data.dart';
import 'package:battle_of_bands/ui/main/mian_bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../backend/server_response.dart';
import '../../helper/shared_preference_helper.dart';

class MainScreenBloc extends Cubit<MainScreenState> {
  BuildContext? textFieldContext;
  Key inputKey = GlobalKey();
  final GlobalKey globalKey = GlobalKey(debugLabel: 'btm_app_bar');
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController leaderBoardGenreController = TextEditingController();
  TextEditingController battlesGenreController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  final SharedWebService _sharedWebService = SharedWebService.instance();
  final SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper.instance();

  MainScreenBloc() : super(MainScreenState.initial()) {
    getAllGenre();
    getUser();
    getStatistics();
  }

  getStatistics() async {
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    final statistics = await _sharedWebService.getStatistics(user.id);
    emit(state.copyWith(statistics: statistics));
  }

  getAllGenre() async {
    final allGenre = await _sharedWebService.getAllGenre();
    emit(state.copyWith(allGenre: allGenre));
  }

  Future<void> getUser() async {
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    emit(state.copyWith(userEmail: user.emailAddress, userName: user.name, userId: user.id));
  }

  void updateIndex(int index) {
    emit(state.copyWith(index: index));
  }

  Future<void> updateLeaderBoardByChangeGenreId(Genre genre) async {
    leaderBoardGenreController.text = genre.title;
    emit(state.copyWith(leaderBoardDataEvent: const Loading()));
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    final leaderBoard = await _sharedWebService.getLeaderboard(genre.id, user.id);
    if (leaderBoard.isEmpty) {
      emit(state.copyWith(leaderBoardDataEvent: const Empty(message: '')));
      return;
    }
    emit(state.copyWith(leaderBoardDataEvent: Data(data: leaderBoard)));
  }

  Future<void> updateMySongsByChangeGenreId(Genre genre) async {
    genreController.text = genre.title;
    emit(state.copyWith(mySongDataEvent: const Loading()));
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    final mySongs = await _sharedWebService.getAllMySongs(genre.id, user.id);
    if (mySongs.isEmpty) {
      emit(state.copyWith(mySongDataEvent: const Empty(message: '')));
      return;
    }
    emit(state.copyWith(mySongDataEvent: Data(data: mySongs)));
  }

  void toggleVote() {
    emit(state.copyWith(isVote: !state.isVote));
  }

  void toggleNoMusic() {
    emit(state.copyWith(isNoMusic: !state.isNoMusic));
  }
}
