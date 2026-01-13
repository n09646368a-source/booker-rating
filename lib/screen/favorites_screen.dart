import 'dart:ui';

import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7F56D9),
        centerTitle: true,
        title: const Text(
          "FavoritesScreen",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text(
          "No Favorites yet",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}