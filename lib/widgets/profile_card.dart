import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_card/models/profile_data.dart';

class ProfileCard extends StatelessWidget {
  final ProfileData profile;
  final VoidCallback onEdit;
  final VoidCallback onToggleFavorite;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.onEdit,
    required this.onToggleFavorite,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      color: profile.color,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  profile.role,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone: ${profile.phone.trim()}',
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      Text(
                        'Email: ${profile.email}',
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        // Create the text to be copied
                        String profileText = '''
Name - ${profile.name}
Role - ${profile.role}
Phone Number - ${profile.phone.trim()}
Email - ${profile.email}
''';
                        // Copy the text to the clipboard
                        Clipboard.setData(ClipboardData(text: profileText));

                        // Show the SnackBar at the top with slide-in effect
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                'Info has been copied onto Clipboard'),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.only(
                                top: 50.0, left: 10.0, right: 10.0),
                            backgroundColor: Colors.black,
                            duration: const Duration(seconds: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        );
                      },
                      tooltip: 'Share Profile',
                    ),
                    IconButton(
                      icon: Icon(
                        profile.isFavorite ? Icons.star : Icons.star_border,
                        color: profile.isFavorite ? Colors.yellow : null,
                      ),
                      onPressed: onToggleFavorite,
                      tooltip: 'Toggle Favorite',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: onEdit,
                      tooltip: 'Edit Profile',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}