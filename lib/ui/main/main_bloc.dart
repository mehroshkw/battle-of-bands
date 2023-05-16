import 'package:battle_of_bands/backend/shared_web_services.dart';
import 'package:battle_of_bands/data/meta_data.dart';
import 'package:battle_of_bands/ui/main/mian_bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../backend/server_response.dart';
import '../../data/snackbar_message.dart';
import '../../helper/network_helper.dart';
import '../../helper/shared_preference_helper.dart';
import '../../util/app_strings.dart';

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

  NetworkHelper get _networkHelper => NetworkHelper.instance();

  MainScreenBloc() : super(MainScreenState.initial()) {
    getAllGenre();
    getUser();
    getStatistics();
    getUser();
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
    emit(state.copyWith(userEmail: user.emailAddress, userName: user.name, userId: user.id, userDb: user.dateOfBirth, userImage: user.imagePath));
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

  Future<void> updateBattleByChangeGenreId(Genre genre) async {
    battlesGenreController.text = genre.title;
    emit(state.copyWith(battleDataEvent: const Loading()));
    final user = await sharedPreferenceHelper.user;
    if (user == null) return;
    final battleSongs = await _sharedWebService.getAllSongs(genre.id, user.id);
    if (battleSongs.isEmpty) {
      emit(state.copyWith(battleDataEvent: const Empty(message: '')));
      return;
    }
    emit(state.copyWith(battleDataEvent: Data(data: battleSongs)));
  }

  Future<void> voteUnVoteBattleSong(Song song) async {
    if (!(await _networkHelper.isNetworkConnected)) {
      emit(state.copyWith(snackbarMessage: SnackbarMessage.error(message: AppText.LIMITED_NETWORK_CONNECTION)));
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(snackbarMessage: SnackbarMessage.empty()));
      return;
    }
    final user = await sharedPreferenceHelper.user;
    if (user == null) {
      emit(state.copyWith(snackbarMessage: SnackbarMessage.error(message: AppText.LIMITED_NETWORK_CONNECTION)));
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(snackbarMessage: SnackbarMessage.empty()));
      return;
    }
    DataEvent lastBattleDataEvent = state.battleDataEvent;
    final isVoted = !song.isVoted;
    final updateSong = song.copyWith(isVoted: isVoted, votesCount: isVoted ? song.votesCount + 1 : song.votesCount - 1);
    if (lastBattleDataEvent is Data) {
      final songs = lastBattleDataEvent.data as List<Song>;
      final indexOfSong = songs.indexWhere((element) => element.id == song.id);
      if (indexOfSong != -1) {
        songs.removeAt(indexOfSong);
        songs.insert(indexOfSong, updateSong);
        emit(state.copyWith(battleDataEvent: Data(data: List.of(songs))));
      }
    }
    try {
      await _sharedWebService.voteUnVote(song.id, user.id, isVoted);
    } catch (_) {
      emit(state.copyWith(battleDataEvent: lastBattleDataEvent));
    }
  }

  Future<void> updateMySongs(Song song) async {

    print('new song-------------------->$song');
    final mySongDataEvent=state.mySongDataEvent;
    if(mySongDataEvent is Data){
      final songData=mySongDataEvent.data as List<Song>;
      songData.insert(0, song);
      emit(state.copyWith(mySongDataEvent: Data(data: songData)));
    }
  }

  void toggleVote() {
    emit(state.copyWith(isVote: !state.isVote));
  }

  void logout() {
    sharedPreferenceHelper.clear();
  }
}
