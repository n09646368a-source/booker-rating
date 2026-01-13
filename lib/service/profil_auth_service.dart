import 'dart:io';
import 'dart:convert';
import 'package:booker/model/profile_responce_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:8000/api",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  // 🟣 إرسال البروفايل للسيرفر
  Future<ProfileResponceModel> submitProfile({
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required File personalImage,
    required File idImage,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      if (token == null) {
        print("❌ Missing auth token");
        throw Exception("Authentication token not found");
      }

      final formData = FormData.fromMap({
        'first_name': firstName,
        'last_name': lastName,
        'date_of_birth': dateOfBirth,
        'personal_image': await MultipartFile.fromFile(
          personalImage.path,
          filename: personalImage.path.split('/').last,
        ),
        'id_image': await MultipartFile.fromFile(
          idImage.path,
          filename: idImage.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        "/profile",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      print("✅ Response status: ${response.statusCode}");
      print("✅ Response data: ${response.data}");

      // ✅ هلا الموديل صار يقرأ الصور كمان
      final profile = ProfileResponceModel.fromJson(response.data);

      // 🟣 خزّني البروفايل محلياً
      await saveProfile(profile);

      // 🧪 اختبر الجلب فوراً بعد التخزين
      final test = await loadProfile();
      print("✅ Loaded after save: ${test?.firstName}");

      // رجّع البروفايل للواجهة
      return profile;

    } on DioException catch (e) {
      print("❌ DioException: ${e.message}");
      print("❌ Response status: ${e.response?.statusCode}");
      print("❌ Response data: ${e.response?.data}");

      throw Exception(e.response?.data["error"] ?? "Profile submission failed");
    } catch (e) {
      print("❌ Unexpected error: $e");
      throw Exception("Unexpected error occurred: $e");
    }
  }

  // 🟣 تخزين البروفايل محلياً
  Future<void> saveProfile(ProfileResponceModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(profile.toJson());
    await prefs.setString("user_profile", jsonString);
    print("📌 Profile saved locally");
  }

  // 🟣 جلب البروفايل من التخزين المحلي
  Future<ProfileResponceModel?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString("user_profile");

    if (jsonString == null) {
      print("⚠️ No profile found locally");
      return null;
    }

    final data = jsonDecode(jsonString);
    return ProfileResponceModel.fromJson(data);
  }
}