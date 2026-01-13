import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:booker/model/apartment_model.dart';
//192.168.1.104:8000
class ApartmentRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:8000/api",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  Future<ApartmentModel> submitApartment({
    required String city,
    required String governorate,
    required String rentPrice,
    required String apartmentSpace,
    required String rooms,
    required String floor,
    required String bathrooms,
    required File apartmentImage,
  }) async {
    try {
      // 🔥 1) قراءة التوكن من SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      print("🔑 Token used: $token");

      if (token == null) {
        throw Exception("لا يوجد توكن مخزّن. المستخدم غير مسجّل دخول.");
      }

      // 🔥 2) تجهيز البيانات
      final formData = FormData.fromMap({
        'city': city,
        'Governorate': governorate,
        'rent_price': rentPrice,
        'apartment_space': apartmentSpace,
        'rooms': rooms,
        'floor': floor,
        'bathrooms': bathrooms,
        'apartment_image': await MultipartFile.fromFile(
          apartmentImage.path,
          filename: apartmentImage.path.split('/').last,
        ),
      });

      // 🔥 3) إرسال الطلب مع الهيدر الصحيح
      final response = await _dio.post(
        "/Apartmentregister",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      print("✅ Status: ${response.statusCode}");
      print("✅ Response: ${response.data}");
      final apartmentJson = response.data['data']['apartment'];
final imageUrl = response.data['data']['image_url'];

return ApartmentModel.fromJson(apartmentJson);
    } on DioException catch (e) {
      print("❌ DioException: ${e.message}");
      print("❌ Status: ${e.response?.statusCode}");
      print("❌ Response: ${e.response?.data}");
      throw Exception("فشل في إضافة الشقة");
    } catch (e) {
      print("❌ Unexpected error: $e");
      throw Exception("حدث خطأ غير متوقع");
    }
  }
}