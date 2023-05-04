import '../../../data/base_cubit_state.dart';
import '../../../data/snackbar_message.dart';

class LoginBlocState extends BaseCubitState {
  final String navigationRoute;
  final String emailError;
  final String passwordError;

  const LoginBlocState(
      {
        required this.navigationRoute,
        required SnackbarMessage snackbarMessage,
        required this.emailError,
        required this.passwordError,
      })
      : super(snackbarMessage);

  const LoginBlocState.initial()
      : this(
      navigationRoute: '',
      snackbarMessage: const SnackbarMessage.empty(),
      emailError: '',
      passwordError: '',
    );

  LoginBlocState copyWith(
      {
        String? navigationRoute,
        SnackbarMessage? snackbarMessage,
        String? emailError,
        String? passwordError,
       }) =>
      LoginBlocState(
          navigationRoute: navigationRoute ?? this.navigationRoute,
          snackbarMessage: snackbarMessage ?? this.snackbarMessage,
          emailError: emailError ?? this.emailError,
          passwordError: passwordError ?? this.passwordError);


  @override
  List<Object> get props =>
      [ navigationRoute, super.props, emailError, passwordError];
}
