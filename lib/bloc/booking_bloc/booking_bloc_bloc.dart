import 'package:booker/bloc/booking_bloc/booking_bloc_evevt.dart';
import 'package:booker/service/booking_server.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booker/bloc/booking_bloc/booking_bloc_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingServer bookingServer;

  BookingBloc({required this.bookingServer}) : super(BookingInitial()) {
 on<SendBookingEvent>((event, emit) async {
  emit(BookingLoading());

  try {
    final res = await bookingServer.bookApartment(
      apartmentId: event.apartmentId,
      startDate: event.startDate,
      endDate: event.endDate,
    );

    final success = res["success"] ?? false;
    final message = res["message"] ?? "Booking request submitted.";

    if (!success) {
      emit(BookingError(message)); // ✅ نعرض رسالة السيرفر بدل الخطأ التقني
      return;
    }

    final data = res["data"] ?? {};
    final totalPrice = data["total_price"] ?? 0;
    final numberOfDays = data["number_of_days"] ?? 0;

    emit(BookingSuccess(
      message: message,
      totalPrice: totalPrice,
      numberOfDays: numberOfDays,
    ));
  } catch (e) {
    emit(BookingError("Something went wrong. Please try again."));
  }
});
    
  }
}