import 'package:booker/model/reservation_model.dart';

abstract class ReservationState {}

class ReservationInitial extends ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationLoaded extends ReservationState {
  final List<ReservationModel> active;
  final List<ReservationModel> cancelled;
  final List<ReservationModel> all;

  ReservationLoaded({
    required this.active,
    required this.cancelled,
    required this.all,
  });
}

class ReservationError extends ReservationState {
  final String message;
  ReservationError(this.message);
}

class ReservationRatingLoading extends ReservationState {}

class ReservationRatedState extends ReservationState {}

class ReservationErrorState extends ReservationState {
  final String message;

  ReservationErrorState(this.message);
}
