import 'package:booker/bloc/show_profile_bloc/show_profile_event.dart';
import 'package:booker/bloc/show_profile_bloc/show_profile_state.dart';
import 'package:booker/service/show_profile_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserProfileServer server;

  UserProfileBloc({required this.server}) : super(UserProfileInitial()) {
    on<LoadUserProfileEvent>((event, emit) async {
      emit(UserProfileLoading());
      try {
        final profile = await server.getProfile();
        emit(UserProfileLoaded(profile));
      } catch (e) {
        emit(UserProfileError(e.toString()));
      }
    });
  }
}