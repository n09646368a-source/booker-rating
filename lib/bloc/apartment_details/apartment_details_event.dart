abstract class ApartmentDetailsEvent {}

class LoadApartmentDetails extends ApartmentDetailsEvent {
  final int apartmentId;
  LoadApartmentDetails(this.apartmentId);
}