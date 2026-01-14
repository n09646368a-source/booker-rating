import 'package:booker/model/profile_responce_model.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final ProfileResponceModel profile;
  UserProfileLoaded(this.profile);
}

class UserProfileError extends UserProfileState {
  final String message;
  UserProfileError(this.message);
}