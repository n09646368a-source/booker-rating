
import 'package:booker/service/home_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booker/bloc/home/home_event.dart';
import 'package:booker/bloc/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApartmentService service;

  HomeBloc({required this.service}) : super(HomeInitial()) {
    on<LoadApartments>((event, emit) async {
      emit(HomeLoading());
      try {
        final apartments = await service.fetchApartments();
        emit(HomeLoaded(apartments));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });

    on<FilterApartments>((event, emit) async {
      emit(HomeLoading());
      try {
        final apartments = await service.filterApartments(event.toJson());
        emit(HomeLoaded(apartments));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}