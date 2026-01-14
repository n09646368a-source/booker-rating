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