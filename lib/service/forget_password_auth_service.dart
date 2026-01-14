import 'package:dio/dio.dart';

class ForgetPasswordService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:8000/api",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  // 1) إرسال الكود
  Future<Map<String, dynamic>> sendOtp({required String phone}) async {
    try {
      final response = await _dio.post(
        "/forgot-password/send-otp",
        data: {"phone_number": phone},
      );

      return {
        "success": response.data["success"],
        "message": response.data["message"],
      };
    } catch (e) {
      return {"success": false, "message": "Failed to send OTP"};
    }
  }

  // 2) التحقق من الكود
  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        "/forgot-password/verify-otp",
        data: {"phone_number": phone, "otp": otp},
      );

      return {
        "success": response.data["success"],
        "message": response.data["message"],
      };
    } catch (e) {
      return {"success": false, "message": "OTP verification failed"};
    }
  }

  // 3) إعادة تعيين الباسورد
  Future<Map<String, dynamic>> resetPassword({
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        "/forgot-password/reset",
        data: {
          "phone_number": phone,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
      );

      return {
        "success": response.data["success"],
        "message": response.data["message"],
      };
    } catch (e) {
      return {"success": false, "message": "Password reset failed"};
    }
  }
}
