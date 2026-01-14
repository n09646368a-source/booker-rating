import 'package:booker/model/usermodel.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInAuthService {
  final Dio _dio = Dio(
    BaseOptions(
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  Future<Map<String, dynamic>> signIn(Usermodel user) async {
    try {
      // 🔥 طباعة الريسبونس الخام لمعرفة المشكلة الحقيقية
      print("📤 Sending: ${user.toMap()}");

      final response = await _dio.post(
        "http://127.0.0.1:8000/api/login",
        data: user.toMap(),
      );

      print("🔥 RAW RESPONSE TYPE: ${response.data.runtimeType}");
      print("🔥 RAW RESPONSE: ${response.data}");

      // 🔥 إذا الريسبونس مو Map → يعني HTML → خطأ من السيرفر
      if (response.data is! Map) {
        return {
          "message": "Server returned invalid response format",
          "isApproved": false,
        };
      }

      final data = response.data;

      // 🔥 نجاح
      if (response.statusCode == 200 && data["success"] == true) {
        final token = data["data"]["token"];
        final userJson = data["data"]["user"];

        final isApproved =
            userJson["is_approved"].toString() == "1" ||
            userJson["is_approved"].toString().toLowerCase() == "true";

        // حفظ التوكن
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        return {
          "message": data["message"] ?? "Login successful",
          "isApproved": isApproved,
        };
      }

      // 🔥 خطأ من السيرفر
      return {
        "message": data["message"] ?? "Login failed",
        "isApproved": false,
      };
    } on DioException catch (e) {
      print("❌ Dio Error: ${e.response?.data}");

      return {
        "message": e.response?.data["message"] ?? "Network error",
        "isApproved": false,
      };
    } catch (e) {
      print("❌ Unexpected Error: $e");

      return {"message": "Unexpected error: $e", "isApproved": false};
    }
  }
}
