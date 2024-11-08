import 'package:flutter/material.dart';

class ProfileData {
  String name;
  String role;
  String phone;
  String email;
  Color color;
  bool isFavorite; 

  ProfileData({
    required this.name,
    required this.role,
    required this.phone,
    required this.email,
    required this.color,
    this.isFavorite = false, 
  });
}
