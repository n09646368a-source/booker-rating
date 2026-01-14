import 'package:booker/model/profile_responce_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final ProfileResponceModel profile;
  ProfileSuccess(this.profile);
}

class ProfileFailure extends ProfileState {
  final String error;
  ProfileFailure(this.error);
}

