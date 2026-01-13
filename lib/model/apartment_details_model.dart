import 'package:booker/model/apartment_model.dart';
import 'package:booker/model/profile_responce_model.dart';
import 'package:booker/model/userinfo.dart';

class ApartmentDetailsModel {
  final ApartmentModel apartment;
  final ProfileResponceModel profile; // الاسم + الصور
  final Userinfo owner;               // رقم الهاتف + id

  ApartmentDetailsModel({
    required this.apartment,
    required this.profile,
    required this.owner,
  });

  factory ApartmentDetailsModel.fromJson(Map<String, dynamic> json) {
  final ownerJson = json['owner'];

  return ApartmentDetailsModel
  (
    apartment: ApartmentModel.fromJson(json['apartment']),
    profile: ProfileResponceModel.fromJson(ownerJson),
    owner: Userinfo(
      id: ownerJson['user_id'],
      phoneNumber: ownerJson['phone_number'] ?? '',
      createdAt: ownerJson['created_at'] ?? '',
      updatedAt: ownerJson['updated_at'] ?? '',
    ),
  );
}
}