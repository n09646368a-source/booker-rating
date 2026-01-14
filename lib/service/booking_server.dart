import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingServer {
  final Dio dio;
  final String baseUrl;

  BookingServer({
    required this.dio,
    this.baseUrl = "http://127.0.0.1:8000/api",
  });

  Future<Map<String, dynamic>> bookApartment({
    required int apartmentId,
    required String startDate,
    required String endDate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token") ?? "";

    // 🔍 طباعة البيانات قبل الإرسال
    print("🔵 SENDING BOOKING REQUEST");
    print("➡️ URL: $baseUrl/book/$apartmentId");
    print("➡️ Start Date: '$startDate'");
    print("➡️ End Date: '$endDate'");
    print("➡️ Token: $token");

    try {
      final response = await dio.post(
        "$baseUrl/book/$apartmentId",
        data: {"start_date": startDate, "end_date": endDate},
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      // 🔍 طباعة الرد من السيرفر
      print("🟢 RESPONSE STATUS: ${response.statusCode}");
      print("🟢 RESPONSE DATA: ${response.data}");

      return response.data;
    } catch (e) {
      // 🔥 طباعة الخطأ بالتفصيل
      print("🔴 BOOKING ERROR:");
      print(e);

      if (e is DioException) {
        print("🔴 SERVER RESPONSE: ${e.response?.data}");
        print("🔴 STATUS CODE: ${e.response?.statusCode}");
      }

      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMyReservations() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token") ?? "";

    final response = await dio.get(
      "$baseUrl/my-reservations",
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data["data"];
  }
}
