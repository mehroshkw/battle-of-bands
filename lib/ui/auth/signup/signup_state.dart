

import '../../../data/base_cubit_state.dart';
import '../../../data/snackbar_message.dart';

class SignUpScreenBlocState extends BaseCubitState {
  final bool isNotShowPassword;
  final bool isNotShowConfirmPassword;
  final String emailError;
  final String passwordError;
  final String confirmPasswordError;
  final String nameError;
  final String dobError;
  final String navigationRoute;
  final String emailVerificationError;


  const SignUpScreenBlocState(
      {required this.isNotShowPassword,
        required this.isNotShowConfirmPassword,
        required this.nameError,
        required this.dobError,
        required SnackbarMessage message,
        required this.emailError,
        required this.passwordError,
        required this.confirmPasswordError,
        required this.navigationRoute,
        required this.emailVerificationError,
        })
      : super(message);

  const SignUpScreenBlocState.initial()
      : this(
      isNotShowPassword: true,
      isNotShowConfirmPassword: true,
      message: const SnackbarMessage.empty(),
      emailError: '',
      passwordError: '',
      dobError: '',
      nameError: '',
      navigationRoute: '',
      emailVerificationError: '',
      confirmPasswordError: '',
     );

  SignUpScreenBlocState copyWith(
      {bool? isNotShowPassword,
        bool? isNotShowConfirmPassword,
        SnackbarMessage? snackbarMessage,
        String? emailError,
        String? nameError,
        String? dobError,
        String? navigationRoute,
        DateTime? dateFromDate,
        String? passwordError,
        String? emailVerificationError,
        String? confirmPasswordError,
        }) =>
      SignUpScreenBlocState(
          isNotShowPassword: isNotShowPassword ?? this.isNotShowPassword,
          message: snackbarMessage ?? this.snackbarMessage,
          emailError: emailError ?? this.emailError,
          navigationRoute: navigationRoute ?? this.navigationRoute,
          passwordError: passwordError ?? this.passwordError,
          emailVerificationError: emailVerificationError ?? this.emailVerificationError,
          confirmPasswordError: confirmPasswordError ?? this.confirmPasswordError,
          isNotShowConfirmPassword: isNotShowConfirmPassword ?? this.isNotShowConfirmPassword,
          nameError: nameError ?? this.nameError,
        dobError: dobError ?? this.dobError,
      );

  @override
  List<Object> get props => [
    isNotShowPassword,
    emailVerificationError,
    isNotShowConfirmPassword,
    super.props,
    emailError,
    passwordError,
    confirmPasswordError,
    navigationRoute,
  ];
  @override
  bool get stringify => true;
}
