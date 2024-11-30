import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mi_card/models/profile_data.dart';

Color getRandomColor() {
  final List<Color> presetColors = [
    Colors.blueAccent,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.yellowAccent,
    Colors.tealAccent,
    Colors.pinkAccent,
    Colors.lightBlue,
    Colors.deepOrange,
    Colors.indigo,
    Colors.amber,
  ];

  final Random random = Random();
  return presetColors[random.nextInt(presetColors.length)];
}

bool isMatchProfile(
    ProfileData profile, String searchQuery, String selectedFilter) {
  switch (selectedFilter) {
    case 'Name':
      return profile.name.toLowerCase().contains(searchQuery.toLowerCase());
    case 'Role':
      return profile.role.toLowerCase().contains(searchQuery.toLowerCase());
    case 'Phone':
      return profile.phone.toLowerCase().contains(searchQuery.toLowerCase());
    case 'Email':
      return profile.email.toLowerCase().contains(searchQuery.toLowerCase());
    default:
      return false;
  }
}
