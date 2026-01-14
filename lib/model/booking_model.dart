class BookingModel {
  final int id;
  final String title;
  final String image;
  final String startDate;
  final String endDate;
  final String status;

  BookingModel({
    required this.id,
    required this.title,
    required this.image,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final apartment = json["apartment"] ?? {};

    return BookingModel(
      id: json["id"] ?? 0,
      title: apartment["city"] ?? "Apartment",
      image: apartment["apartment_image"] != null
          ? "http://127.0.0.1:8000/${apartment["apartment_image"]}"
          : " ",
      startDate: json["start_date"] ?? "",
      endDate: json["end_date"] ?? "",
      status: json["status"] ?? "",
    );
  }
}
