import 'dart:convert';

class PriceModel {
  final num value;
  final String unit;

  PriceModel({required this.value, required this.unit});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'value': value, 'unit': unit};
  }

  factory PriceModel.fromMap(Map<String, dynamic> map) {
    return PriceModel(value: map['value'] as num, unit: map['unit'] as String);
  }

  String toJson() => json.encode(toMap());

  factory PriceModel.fromJson(String source) =>
      PriceModel.fromMap(json.decode(source) as Map<String, dynamic>);
}