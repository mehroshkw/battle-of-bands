import 'package:battle_of_bands/backend/shared_web_services.dart';
import 'package:battle_of_bands/ui/main/mian_bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  int? id = 0;
  String? name = '';
  String? email = '';
  String? dob = '';
  String? img = '';

  MainScreenBloc() : super(MainScreenState.initial()) {
    getStatistics();
    getUser();
  }


  getStatistics() async {
    final statistics = await _sharedWebService.getStatistics(4);
    emit(state.copyWith(statistics: statistics));
  }

  // get user from shared preferences
  Future<void> getUser() async {
    print("fgfgggggg");
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    id = user.id;
    name = user.name;
    email = user.emailAddress;
    dob = user.dateOfBirth;
    img = user.imagePath;
    print("valueee from shared preferences======> $name, $email, $dob, $img, $id");
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

  void logout() {
    sharedPreferenceHelper.clear();
  }
}
