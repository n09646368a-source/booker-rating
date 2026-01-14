import 'dart:convert';
import 'package:booker/model/profile_responce_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileServer {
  Future<ProfileResponceModel> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    if (token == null) throw Exception("Missing token");

    final url = Uri.parse("http://127.0.0.1:8000/api/profile");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProfileResponceModel.fromJson(data);
    } else {
      throw Exception("Failed to load profile");
    }
  }
}
