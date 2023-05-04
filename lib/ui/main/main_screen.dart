import 'package:battle_of_bands/extension/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_bloc.dart';
import 'package:battle_of_bands/util/constants.dart';
import 'mian_bloc_state.dart';
import 'nav_items/all_songs/all_songs_screen.dart';
import 'nav_items/battle/battle_screen.dart';
import 'nav_items/home/home_screen.dart';
import 'nav_items/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  static const String route = '/main_screen_route';

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const _homeScreenNavigationKey = PageStorageKey(HomeScreen.key_title);
  static const _battleScreenNavigationKey = PageStorageKey(BattleScreen.key_title);
  static const _allSongsKeyNavigationKey = PageStorageKey(AllSongsScreen.key_title);
  static const _profileKeyNavigationKey = PageStorageKey(ProfileScreen.key_title);
  final _bottomMap = <PageStorageKey<String>, Widget>{};

  @override
  void initState() {
    _bottomMap[_homeScreenNavigationKey] = const HomeScreen(key: _homeScreenNavigationKey);
    _bottomMap[_battleScreenNavigationKey] = const BattleScreen(key: _battleScreenNavigationKey);
    _bottomMap[_allSongsKeyNavigationKey] = const AllSongsScreen(key: _allSongsKeyNavigationKey);
    _bottomMap[_profileKeyNavigationKey] = const ProfileScreen(key: _profileKeyNavigationKey);

    super.initState();
  }

  final _bottomNavItems = <BottomNavigationBarItem>[
     const BottomNavigationBarItem(
        icon: Image(
            image: AssetImage('assets/3x/home.png'),
            width: 24,
            height: 24,
            color: Constants.colorSecondary),
        label: '',
        activeIcon: Image(
            image: AssetImage('assets/3x/home.png'),
            width: 24,
            height: 24,
            color: Constants.colorPrimary)),
    const BottomNavigationBarItem(
        icon: Image(
            image: AssetImage('assets/3x/vote.png'),
            width: 24,
            height: 24,
            color: Constants.colorSecondary),
        label: '',
        activeIcon: Image(
          image: AssetImage('assets/3x/vote.png'),
          width: 24,
          height: 24,
          color: Constants.colorPrimary,
        )),
    const BottomNavigationBarItem(
        icon: Image(
            image: AssetImage('assets/3x/add.png'),
            width: 24,
            height: 26,
            color: Constants.colorSecondary),
        label: '',
        activeIcon: Image(
          image: AssetImage('assets/3x/add.png'),
          width: 24,
          height: 26,
          color:Constants.colorPrimary,
        )),
    const BottomNavigationBarItem(
        icon: Image(
            image: AssetImage('assets/3x/user.png'),
            width: 24,
            height: 24,
            color: Constants.colorSecondary),
        label: '',
        activeIcon: Image(
            image: AssetImage('assets/3x/user.png'),
            width: 24,
            height: 24,
            color: Constants.colorPrimary)),
  ];

  @override
  Widget build(BuildContext context) {
    final sized = context.screenSize;
    final bloc = context.read<MainScreenBloc>();

    return Scaffold(
        key: bloc.scaffoldKey,
        bottomNavigationBar: BlocBuilder<MainScreenBloc, MainScreenState>(
        builder: (_, state) => ClipRRect(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24)),
            child: SizedBox(
              height: 70,
              child: BottomNavigationBar(
                  key: bloc.globalKey,
                  onTap: (int newIndex) {
                    if (state.index == newIndex && newIndex != 3) return;
                    final pageStorageKey = _bottomMap.keys.elementAt(newIndex);
                    final bottomItem = _bottomMap[pageStorageKey];
                    if (bottomItem == null || bottomItem is SizedBox) {
                      final newBottomWidget = _getNavigationWidget(newIndex);
                      _bottomMap[pageStorageKey] = newBottomWidget;
                    }
                    bloc.updateIndex(newIndex);
                  },
                  items: _bottomNavItems,
                  currentIndex: state.index,
                  elevation: 10,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Constants.onScaffoldColor,
                  iconSize: 28,
                  selectedFontSize: 11,
                  unselectedLabelStyle:
                      const TextStyle(color: Constants.colorSecondary),
                  selectedLabelStyle:
                      const TextStyle(color: Constants.colorPrimary),
                  unselectedFontSize: 11,
                  selectedItemColor: Constants.colorPrimary,
                  unselectedItemColor: Constants.colorSecondary,
                  showSelectedLabels: true,
                  showUnselectedLabels: true),
            ),
          )
        ),
        body: BlocBuilder<MainScreenBloc, MainScreenState>(
            builder: (_, state) => IndexedStack(
                index: state.index,
                children: _bottomMap.values.toList())));
  }

  Widget _getNavigationWidget(int index) {
    switch (index) {
      case 0:
        return const HomeScreen(key: _homeScreenNavigationKey);
      case 1:
        return const BattleScreen(key: _battleScreenNavigationKey);
      case 2:
        return const AllSongsScreen(key: _allSongsKeyNavigationKey);
      case 3:
        return const ProfileScreen(key: _profileKeyNavigationKey);
      default:
        return const SizedBox();
    }
  }
}
