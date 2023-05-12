import 'package:battle_of_bands/ui/main/mian_bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/meta_data.dart';
import '../../helper/shared_preference_helper.dart';


class MainScreenBloc extends Cubit<MainScreenState> {

  BuildContext? textFieldContext;
  Key inputKey = GlobalKey();
  final GlobalKey globalKey = GlobalKey(debugLabel: 'btm_app_bar');
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController leaderBoardGenreController = TextEditingController();
  TextEditingController battlesGenreController = TextEditingController();
  TextEditingController genreController = TextEditingController();

   String name= '';
   String email= '';


  final SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper.instance();


  MainScreenBloc():super(const MainScreenState.initial());


  // get user from shared preferences
  Future<void> getUser()  async {
    final user= await sharedPreferenceHelper.user;
    if(user==null)return;
    name = user.name;
    print(name);
    email = user.emailAddress;
    print(email);
  }



  void updateIndex(int index) {
   emit(state.copyWith(index: index));
  }

  void toggleVote() {
    emit(state.copyWith(isVote:  !state.isVote));
  }

  void toggleNoMusic() {
    emit(state.copyWith(isNoMusic:  !state.isNoMusic));
  }
}
