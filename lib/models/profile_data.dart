import 'package:flutter/material.dart';

class ProfileData {
  final String name;
  final String role;
  final String phone;
  final String email;
  final Color color;
  bool isFavorite; // Added this line

  ProfileData({
    required this.name,
    required this.role,
    required this.phone,
    required this.email,
    required this.color,
    this.isFavorite = false, // Default value for favorites
  });
}
