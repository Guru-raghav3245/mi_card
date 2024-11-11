// logout_dialog.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mi_card/screens/auth_screen.dart';

Future<void> showLogoutDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Prevents dismissing the dialog by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          // Log out button
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              await _logout(context); // Log out the user
            },
            child: const Text('Log Out'),
          ),
        ],
      );
    },
  );
}

// Function to log out and navigate to the auth screen
Future<void> _logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const AuthScreen()), // Navigate to Auth screen
  );
}
