import 'package:booker/model/reservation_model.dart';
import 'package:dio/dio.dart';

class ReservationServer {
  final Dio dio;

  ReservationServer(this.dio);

  Future<Map<String, List<ReservationModel>>> getMyReservations(String token) async {
    final res = await dio.get(
      "/api/my-reservations",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final data = res.data["data"];

    final activeRaw = data["active_reservations"];
    final cancelledRaw = data["cancelled_reservations"];
    final allRaw = data["all_reservations"];

    final active = (activeRaw is List)
        ? activeRaw.map((e) => ReservationModel.fromJson(e)).toList()
        : [];

    final cancelled = (cancelledRaw is List)
        ? cancelledRaw.map((e) => ReservationModel.fromJson(e)).toList()
        : [];

    final all = (allRaw is List)
        ? allRaw.map((e) => ReservationModel.fromJson(e)).toList()
        : [];

     return {
  "active": active as List<ReservationModel>,
  "cancelled": cancelled as List<ReservationModel>,
  "all": all as List<ReservationModel>,
};
  }

  // ⭐ إلغاء الحجز
  Future<void> cancelReservation(int id, String token) async {
    await dio.put(
      "/api/cancel-reservation/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // ⭐ تعديل الحجز
  Future<void> updateReservation({
    required int id,
    required String token,
    required String startDate,
    required String endDate,
  }) async {
    await dio.put(
      "/api/update_book/$id",
      data: {
        "start_date": startDate,
        "end_date": endDate,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}