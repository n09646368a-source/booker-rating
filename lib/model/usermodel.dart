import 'dart:convert';

class Usermodel {
  String? phone_number;
  String? password;
  String? password_confirmation;
  Usermodel({this.phone_number, this.password, this.password_confirmation});

  Usermodel copyWith({
    String? phone_number,
    String? password,
    String? password_confirmation,
  }) {
    return Usermodel(
      phone_number: phone_number ?? this.phone_number,
      password: password ?? this.password,
      password_confirmation:
          password_confirmation ?? this.password_confirmation,
    );
  }

  Map<String, dynamic> toMap() {
  return {
    'phone_number': phone_number?.toString() ?? '',
    'password': password?.toString() ?? '',
    'password_confirmation': password_confirmation?.toString() ?? '',
  };
}

  factory Usermodel.fromMap(Map<String, dynamic> map) {
    return Usermodel(
      phone_number: map['phone_number'] != null
          ? map['phone_number'] as String
          : null,
      password: map['password'] != null ? map['password'] as String : null,
      password_confirmation: map['password_confirmation'] != null
          ? map['password_confirmation'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Usermodel.fromJson(String source) =>
      Usermodel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Usermodel(phone_number: $phone_number, password: $password, password_confirmation: $password_confirmation)';

  @override
  bool operator ==(covariant Usermodel other) {
    if (identical(this, other)) return true;

    return other.phone_number == phone_number &&
        other.password == password &&
        other.password_confirmation == password_confirmation;
  }

  @override
  int get hashCode =>
      phone_number.hashCode ^
      password.hashCode ^
      password_confirmation.hashCode;
}
