import 'package:dio/dio.dart';
import 'package:booker/model/apartment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constan.dart';

class FavoritesService {
  final Dio dio = Dio(BaseOptions(baseUrl: "$baseUrl/api"));

  Future<List<ApartmentModel>> fetchFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await dio.get(
        "/favorites",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      // إذا الرد يحتوي على data فارغة
      if (response.data["data"] is List && response.data["data"].isEmpty) {
        print("⚠️ No favorites available");
        return [];
      }

      print("⚠️ ${response.data["data"]}");

      final List data = response.data["data"];
      return data.map((json) => ApartmentModel.fromJson(json)).toList();
    } on DioException catch (e) {
      // إذا السيرفر رجّع 404 مع رسالة "لا توجد شقق"
      if (e.response?.statusCode == 404 &&
          e.response?.data["message"] == "لا توجد شقق متاحة حالياً") {
        print("⚠️ No favorites available (404)");
        return [];
      }

      print("❌ DioException: ${e.message}");
      throw Exception("Failed to load favorites");
    }
  }
}
