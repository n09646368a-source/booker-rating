import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booker/bloc/profile_bloc/profile_event.dart';
import 'package:booker/bloc/profile_bloc/profile_state.dart';
import 'package:booker/service/profil_auth_service.dart';

class VerifyProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  VerifyProfileBloc(this.repository) : super(ProfileInitial()) {
    on<SubmitProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        final result = await repository.submitProfile(
          firstName: event.firstName,
          lastName: event.lastName,
          dateOfBirth: event.dateOfBirth,
          personalImage: event.personalImage,
          idImage: event.idImage,
        );
        emit(ProfileSuccess(result)); // ✅ يرجع الموديل مع الصور
      } catch (e) {
        emit(ProfileFailure(e.toString()));
      }
    });
  }
}