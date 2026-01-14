class ProfileResponceModel {
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final int userId;
  final String createdAt;
  final String updatedAt;
  final int id;
  final String? personalImage;
  final String? idImage;

  ProfileResponceModel({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    this.personalImage,
    this.idImage,
  });

  factory ProfileResponceModel.fromMap(Map<String, dynamic> map) {
    String fixUrl(dynamic value) {
      if (value == null || value.toString().isEmpty) return "";

      String url = value.toString();

      // استبدال كل الحالات المحتملة
      url = url.replaceFirst("127.0.0.1", "127.0.0.1:8000");
      url = url.replaceFirst("localhost", "127.0.0.1:8000");

      // إذا الرابط كامل
      if (url.startsWith("http")) {
        return url;
      }

      // إذا كان مجرد اسم ملف
      return "http://127.0.0.1:8000/storage/$url";
    }

    return ProfileResponceModel(
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      dateOfBirth: map['date_of_birth'] ?? '',
      userId: map['user_id'] ?? 0,
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      id: map['id'] ?? 0,
      personalImage: fixUrl(map['personal_image']),
      idImage: fixUrl(map['id_image']),
    );
  }

  factory ProfileResponceModel.fromJson(Map<String, dynamic> json) =>
      ProfileResponceModel.fromMap(json);

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "date_of_birth": dateOfBirth,
      "user_id": userId,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "id": id,
      "personal_image": personalImage,
      "id_image": idImage,
    };
  }

  String get fullName => "$firstName $lastName";
}
