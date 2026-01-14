abstract class HomeEvent {
  const HomeEvent();
}

class LoadApartments extends HomeEvent {
  const LoadApartments();
}

class FilterApartments extends HomeEvent {
  final int? maxSpace;
  final int? minSpace;
  final int? rooms;
  final int? bathrooms;
  final int? minPrice;
  final int? maxPrice;
  final String? city;
  final String? governorate;

  FilterApartments({
    this.maxSpace,
    this.minSpace,
    this.rooms,
    this.bathrooms,
    this.minPrice,
    this.maxPrice,
    this.city,
    this.governorate,
  });

  Map<String, dynamic> toJson() {
    return {
      if (maxSpace != null) 'max_space': maxSpace,
      if (minSpace != null) 'min_space': minSpace,
      if (rooms != null) 'rooms': rooms,
      if (bathrooms != null) 'bathrooms': bathrooms,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      if (city != null) 'city': city,
      if (governorate != null) 'governorate': governorate,
    };
  }
}