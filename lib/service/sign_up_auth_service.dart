import 'package:dio/dio.dart';
import 'package:booker/model/usermodel.dart';

class SignUpAuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:8000/api",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  Future<Map<String, dynamic>> signUp(Usermodel user) async {
    try {
      final response = await _dio.post(
        "/register",
        data: {
          "phone_number": user.phone_number,
          "password": user.password,
          "password_confirmation": user.password_confirmation,
        },
      );

      print("✅ Response: ${response.data}");

      return {
        "success": response.data["success"] ?? false,
        "message": response.data["message"] ?? "",
        "error": response.data["error"] ?? "",
      };
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return {
          "success": false,
          "message": e.response?.data["message"] ?? "Registration failed",
          "error": e.response?.data["error"] ?? "Unknown error",
        };
      }
      return {
        "success": false,
        "message": "Registration failed",
        "error": e.message ?? "Unknown error",
      };
    }
  }
}
