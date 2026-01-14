import 'package:booker/bloc/reservation_bloc/reservation_event.dart';
import 'package:booker/bloc/reservation_bloc/reservation_state.dart';
import 'package:booker/service/bookingreservation_server.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  final ReservationServer server;
  final String token;

  ReservationBloc({required this.server, required this.token})
      : super(ReservationInitial()) {
    on<LoadReservationsEvent>((event, emit) async {
      emit(ReservationLoading());
      try {
        final data = await server.getMyReservations(token);
        emit(ReservationLoaded(
          active: data["active"]!,
          cancelled: data["cancelled"]!,
           all: data["all"]!,
        ));
      } catch (e) {
        emit(ReservationError(e.toString()));
      }
    });

    on<CancelReservationEvent>((event, emit) async {
      emit(ReservationLoading());
      try {
        await server.cancelReservation(event.id, token);
        add(LoadReservationsEvent());
      } catch (e) {
        emit(ReservationError(e.toString()));
      }
    });

    on<UpdateReservationEvent>((event, emit) async {
      emit(ReservationLoading());
      try {
        await server.updateReservation(
          id: event.id,
          token: token,
          startDate: event.startDate,
          endDate: event.endDate,
        );
        add(LoadReservationsEvent());
      } catch (e) {
        emit(ReservationError(e.toString()));
      }
    });
  }
}