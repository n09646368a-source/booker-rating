class ApartmentModel {
  final int id;
  final String city;
  final String governorate;
  final String rentPrice;
  final String apartmentSpace;
  final String rooms;
  final String floor;
  final String bathrooms;
  final String apartmentImage;
  final String imageUrl;
  final num? averageRating;
  final num? totalReviews;

  ApartmentModel({
    required this.id,
    required this.city,
    required this.governorate,
    required this.rentPrice,
    required this.apartmentSpace,
    required this.rooms,
    required this.floor,
    required this.bathrooms,
    required this.apartmentImage,
    required this.imageUrl,
    this.averageRating,
    this.totalReviews,
  });

  factory ApartmentModel.fromJson(Map<String, dynamic> json) {
    final rawImage = json['apartment_image'];

    String finalUrl = "";

    if (rawImage != null && rawImage != "") {
      String url = rawImage.toString();

      // 🔥 استبدال كل الحالات المحتملة للمحاكي
      url = url.replaceFirst("10.0.2.2", "127.0.0.1");
      url = url.replaceFirst("localhost", "127.0.0.1");

      // إذا الرابط كامل
      if (url.startsWith("http")) {
        finalUrl = url;
      } else {
        // إذا كان مجرد اسم ملف
        finalUrl = "http://127.0.0.1:8000/storage/$url";
      }
    }

    return ApartmentModel(
      id: json['id'],
      city: json['city'] ?? '',
      governorate: json['Governorate'] ?? '',
      rentPrice: json['rent_price']?.toString() ?? '',
      apartmentSpace: json['apartment_space']?.toString() ?? '',
      rooms: json['rooms']?.toString() ?? '',
      floor: json['floor']?.toString() ?? '',
      bathrooms: json['bathrooms']?.toString() ?? '',
      apartmentImage: rawImage ?? '',
      imageUrl: finalUrl,
      averageRating: json['average_rating'],
      totalReviews: json['total_reviews'],
    );
  }
}
