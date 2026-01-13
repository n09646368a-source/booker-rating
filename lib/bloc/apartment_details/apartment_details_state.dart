import 'package:booker/model/apartment_details_model.dart';

abstract class ApartmentDetailsState {}

class ApartmentDetailsInitial extends ApartmentDetailsState {}

class ApartmentDetailsLoading extends ApartmentDetailsState {}

class ApartmentDetailsSuccess extends ApartmentDetailsState {
  final ApartmentDetailsModel details;
  ApartmentDetailsSuccess(this.details);
}

class ApartmentDetailsFailure extends ApartmentDetailsState {
  final String error;
  ApartmentDetailsFailure(this.error);
}