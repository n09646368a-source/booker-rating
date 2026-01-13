import 'package:dio/dio.dart';
import 'package:booker/model/apartment_details_model.dart';

class ApartmentDetails {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:8000/api",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  Future<ApartmentDetailsModel> fetchApartmentDetails(int id) async {
    try {
      final response = await _dio.get("/apartments/$id/details");
      return ApartmentDetailsModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data["error"] ?? "Failed to fetch apartment details");
    } catch (e) {
      throw Exception("Unexpected error occurred: $e");
    }
  }
}