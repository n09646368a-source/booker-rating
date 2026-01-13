abstract class VerifyState {}
bool isError = false;
class VerifyInitState extends VerifyState {}

class VerifyLoadingState extends VerifyState {}

class VerifySuccessState extends VerifyState {
  final String message;
  final String token;

  VerifySuccessState({
    required this.message,
    required this.token,
  });
}

class VerifyErrorState extends VerifyState {
  
  final String error;
  VerifyErrorState({required this.error});
}