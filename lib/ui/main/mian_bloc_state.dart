import 'package:equatable/equatable.dart';

import '../../data/snackbar_message.dart';

class  MainScreenState extends Equatable{
  final int index;
  final bool isSwitch;

  const MainScreenState(
      {
        required this.index,
        required this.isSwitch,
      });

  MainScreenState.initial(): this(
    index: 0,
    isSwitch: true,
  );

  MainScreenState copyWith(
      {
        SnackbarMessage? snackbarMessage,
        int? index,
        bool? isSwitch,
      }) =>
      MainScreenState(
          index: index ?? this.index,
          isSwitch: isSwitch ?? this.isSwitch);

  @override
  // TODO: implement props
  List<Object?> get props => [index, isSwitch,];

}
