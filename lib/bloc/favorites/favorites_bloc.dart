import 'package:booker/service/favorites_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booker/bloc/favorites/favorites_event.dart';
import 'package:booker/bloc/favorites/favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesService service;

  FavoritesBloc({required this.service}) : super(FavoritesInitial()) {
    on<LoadFavorites>((event, emit) async {
      emit(FavoritesLoading());
      try {
        final apartments = await service.fetchFavorites();
        emit(FavoritesLoaded(apartments));
      } catch (e) {
        emit(FavoritesError(e.toString()));
      }
    });
  }
}
