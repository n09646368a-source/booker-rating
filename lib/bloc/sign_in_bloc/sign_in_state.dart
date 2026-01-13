abstract class SignInState {}

class SignInInitState extends SignInState {}

class SignInLoadingState extends SignInState {}

class SignInSuccessState extends SignInState {
  final String message;
  final bool isApproved;

  SignInSuccessState({required this.message, required this.isApproved});
}

class SignInErrorState extends SignInState {
  final String error;
  SignInErrorState({required this.error});
}