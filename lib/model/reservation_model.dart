class ReservationModel {
  final int id;
  final String startDate;
  final String endDate;
  final int dailyPrice;
  final int totalPrice;
  final int numberOfDays;
  final int userId;
  final int apartmentId;
  final String status;
  final String? deletedAt;

  ReservationModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.dailyPrice,
    required this.totalPrice,
    required this.numberOfDays,
    required this.userId,
    required this.apartmentId,
    required this.status,
    required this.deletedAt,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json["id"],
      startDate: json["start_date"],
      endDate: json["end_date"],
      dailyPrice: json["daily_price"],
      totalPrice: json["total_price"],
      numberOfDays: json["number_of_days"],
      userId: json["user_id"],
      apartmentId: json["apartment_id"],
      status: json["status"],
      deletedAt: json["deleted_at"],
    );
  }

  String getStatusLabel() {
    if (deletedAt != null) return "Cancelled";
    if (status == "completed") return "Completed";
    return "Upcoming";
  }
}