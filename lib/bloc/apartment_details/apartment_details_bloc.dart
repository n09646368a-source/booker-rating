import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booker/bloc/apartment_details/apartment_details_event.dart';
import 'package:booker/bloc/apartment_details/apartment_details_state.dart';
import 'package:booker/service/details_service.dart';

class ApartmentDetailsBloc extends Bloc<ApartmentDetailsEvent, ApartmentDetailsState> {
  final ApartmentDetails repository;

  ApartmentDetailsBloc(this.repository) : super(ApartmentDetailsInitial()) {
    on<LoadApartmentDetails>((event, emit) async {
      emit(ApartmentDetailsLoading());
      try {
        final details = await repository.fetchApartmentDetails(event.apartmentId);
        emit(ApartmentDetailsSuccess(details));
      } catch (e) {
        emit(ApartmentDetailsFailure(e.toString()));
      }
    });
  }
}