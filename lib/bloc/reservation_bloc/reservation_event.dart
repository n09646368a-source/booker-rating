abstract class ReservationEvent {}

class LoadReservationsEvent extends ReservationEvent {}

class CancelReservationEvent extends ReservationEvent {
  final int id;
  CancelReservationEvent(this.id);
}

class UpdateReservationEvent extends ReservationEvent {
  final int id;
  final String startDate;
  final String endDate;

  UpdateReservationEvent({
    required this.id,
    required this.startDate,
    required this.endDate,
  });
}

class RateReservationEvent extends ReservationEvent {
  final int id;
  final int rating;
  final String comment;

  RateReservationEvent(this.id, this.rating, this.comment);
}
