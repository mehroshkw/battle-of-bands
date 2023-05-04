import 'package:battle_of_bands/data/snackbar_message.dart';
import 'package:equatable/equatable.dart';

abstract class BaseCubitState extends Equatable {
  final SnackbarMessage snackbarMessage;

  const BaseCubitState(this.snackbarMessage);

  @override
  List<Object> get props => [snackbarMessage];
}
