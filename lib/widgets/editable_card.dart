import 'package:flutter/material.dart';

class EditableCard extends StatelessWidget {
  final IconData icon;
  final String info;
  final Color iconColor;
  final TextEditingController controller;
  final bool isEditing;
  final Function(String) onChanged;

  const EditableCard({
    super.key,
    required this.icon,
    required this.info,
    required this.iconColor,
    required this.controller,
    required this.isEditing,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: isEditing
            ? TextField(
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(hintText: info),
              )
            : Text(
                info,
                style: TextStyle(
                  color: Colors.teal.shade900,
                  fontSize: 20,
                  fontFamily: 'Dosis',
                ),
              ),
      ),
    );
  }
}
