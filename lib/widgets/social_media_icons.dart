import 'package:flutter/material.dart';

class SocialMediaIconPicker extends StatelessWidget {
  final Function(IconData) onIconSelected;

  const SocialMediaIconPicker({
    super.key,
    required this.onIconSelected,
  });

  final List<Map<String, dynamic>> socialIcons = const [
    {'icon': Icons.discord, 'name': 'Discord'},
    {'icon': Icons.facebook, 'name': 'Facebook'},
    {'icon': Icons.telegram, 'name': 'Telegram'},
    {'icon': Icons.reddit, 'name': 'Reddit'},
    {'icon': Icons.snapchat, 'name': 'Snapchat'},
    {'icon': Icons.tiktok, 'name': 'TikTok'},
    {'icon': Icons.link, 'name': 'Website'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Select Social Media Icon',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 200, // Fixed height for the grid
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: socialIcons.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    onIconSelected(socialIcons[index]['icon']);
                    Navigator.pop(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          socialIcons[index]['icon'],
                          size: 24,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        socialIcons[index]['name'],
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}