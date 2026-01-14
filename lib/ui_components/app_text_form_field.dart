import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: onChanged,
    );
  }
}