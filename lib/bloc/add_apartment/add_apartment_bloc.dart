import 'package:booker/service/add_apartment_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booker/bloc/add_apartment/add_apartment_event.dart';
import 'package:booker/bloc/add_apartment/add_apartment_state.dart';

class ApartmentBloc extends Bloc<ApartmentEvent, ApartmentState> {
  final ApartmentRepository repository;

  ApartmentBloc({required this.repository}) : super(ApartmentInitial()) {
    on<SubmitApartment>((event, emit) async {
      emit(ApartmentLoading());
      try {
        final apartment = await repository.submitApartment(
          city: event.city,
          governorate: event.governorate,
          rentPrice: event.rentPrice,
          apartmentSpace: event.apartmentSpace,
          rooms: event.rooms,
          floor: event.floor,
          bathrooms: event.bathrooms,
          apartmentImage: event.apartmentImage,
        );
        emit(ApartmentSuccess(apartment));
      } catch (e) {
        emit(ApartmentError(e.toString()));
      }
    });
  }
}