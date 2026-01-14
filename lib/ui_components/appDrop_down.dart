import 'package:flutter/material.dart';

class AppDropDown<T> extends StatelessWidget {
  const AppDropDown({
    super.key,
    required this.items,
    this.selectedItem,
    required this.label,
    this.onChanged,
  });

  final T? selectedItem;
  final List<T?> items;
  final String label;
  final void Function(T?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      value: selectedItem,
      items: items
          .map(
            (n) => DropdownMenuItem<T>(
              value: n,
              child: Text(n == null ? 'Any' : n.toString()),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}