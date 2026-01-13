import 'dart:convert';

class Userinfo {


  final String phoneNumber;
  //حطيتهم مشان االدلش بورد للاحتياط مشان عمر انشاء الحساب و اخر تحديث
  final String createdAt;
  final String updatedAt;
  final int id;
  Userinfo({
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });



  Userinfo copyWith({
    String? phoneNumber,
    String? createdAt,
    String? updatedAt,
    int? id,
  }) {
    return Userinfo(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'id': id,
    };
  }

  factory Userinfo.fromMap(Map<String, dynamic> map) {
    return Userinfo(
      phoneNumber: map['phoneNumber'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      id: map['id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

factory Userinfo.fromJson(Map<String, dynamic> json) {
  return Userinfo(
    phoneNumber: json['phone_number'] ?? '',
    id: json.containsKey('user_id') ? int.tryParse(json['user_id'].toString()) ?? 0 : 0,
createdAt: json['created_at'] ?? '',
updatedAt: json['updated_at'] ?? '',
  );
}
  @override
  String toString() {
    return 'Userinfo(phoneNumber: $phoneNumber, createdAt: $createdAt, updatedAt: $updatedAt, id: $id)';
  }

  @override
  bool operator ==(covariant Userinfo other) {
    if (identical(this, other)) return true;
  
    return 
      other.phoneNumber == phoneNumber &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.id == id;
  }

  @override
  int get hashCode {
    return phoneNumber.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      id.hashCode;
  }
}
