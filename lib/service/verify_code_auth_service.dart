import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:8000/api",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        "/verify-otp",
        data: {
          "phone_number": phone,
          "otp": otp,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
      );

      print("✅ Verify Response: ${response.data}");

      return {
        "success": response.data["success"] ?? false,
        "message": response.data["message"] ?? "Unknown response",
        "token": response.data["token"],
      };
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Verification failed",
          "error": e.response?.data["error"] ?? "Unknown error",
        };
      }
      return {
        "success": false,
        "message": "Verification failed",
        "error": e.message ?? "Unknown error",
      };
    }
  }
}
