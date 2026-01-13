abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final String message;
  final int totalPrice;
  final int numberOfDays;

  BookingSuccess({
    required this.message,
    required this.totalPrice,
    required this.numberOfDays,
  });
}

class BookingError extends BookingState {
  final String error;

  BookingError(this.error);
}

