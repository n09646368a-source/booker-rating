import 'package:booker/model/apartment_model.dart';

abstract class FavoritesState {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<ApartmentModel> apartments;

  const FavoritesLoaded(this.apartments);
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);
}
