abstract class BookingEvent {}

class SendBookingEvent extends BookingEvent {
  final int apartmentId;
  final String startDate;
  final String endDate;

  SendBookingEvent({
    required this.apartmentId,
    required this.startDate,
    required this.endDate,
  });
}