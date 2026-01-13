import 'package:booker/model/apartment_model.dart';

abstract class ApartmentState {
  const ApartmentState();
}

class ApartmentInitial extends ApartmentState {}

class ApartmentLoading extends ApartmentState {}

class ApartmentSuccess extends ApartmentState {
  final ApartmentModel apartment;
  const ApartmentSuccess(this.apartment);
}

class ApartmentError extends ApartmentState {
  final String message;
  const ApartmentError(this.message);
}