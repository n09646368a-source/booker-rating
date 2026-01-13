import 'dart:io';

abstract class ApartmentEvent {
  const ApartmentEvent();
}

class SubmitApartment extends ApartmentEvent {
  final String city;
  final String governorate;
  final String rentPrice;
  final String apartmentSpace;
  final String rooms;
  final String floor;
  final String bathrooms;
  final File apartmentImage;

  const SubmitApartment({
    required this.city,
    required this.governorate,
    required this.rentPrice,
    required this.apartmentSpace,
    required this.rooms,
    required this.floor,
    required this.bathrooms,
    required this.apartmentImage,
  });
}