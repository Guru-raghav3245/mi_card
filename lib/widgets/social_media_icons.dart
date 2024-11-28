import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialMediaIconPicker extends StatelessWidget {
  final Function(IconData) onIconSelected;

  const SocialMediaIconPicker({
    super.key,
    required this.onIconSelected,
  });

  final List<Map<String, dynamic>> socialIcons = const [
    {'icon': FontAwesomeIcons.discord, 'name': 'Discord'},
    {'icon': FontAwesomeIcons.facebook, 'name': 'Facebook'},
    {'icon': FontAwesomeIcons.telegram, 'name': 'Telegram'},
    {'icon': FontAwesomeIcons.whatsapp, 'name': 'WhatsApp'},
    {'icon': FontAwesomeIcons.reddit, 'name': 'Reddit'},
    {'icon': FontAwesomeIcons.linkedin, 'name': 'LinkedIn'},
    {'icon': FontAwesomeIcons.snapchat, 'name': 'Snapchat'},
    {'icon': FontAwesomeIcons.instagram, 'name': 'Instagram'},
    {'icon': FontAwesomeIcons.tiktok, 'name': 'TikTok'},
    {'icon': FontAwesomeIcons.twitter, 'name': 'Twitter'},
    {'icon': FontAwesomeIcons.github, 'name': 'GitHub'},
    {'icon': FontAwesomeIcons.medium, 'name': 'Medium'},
    {'icon': FontAwesomeIcons.dev, 'name': 'Dev.to'},
    {'icon': FontAwesomeIcons.stackOverflow, 'name': 'Stack Overflow'},
    {'icon': FontAwesomeIcons.youtube, 'name': 'YouTube'},
    {'icon': FontAwesomeIcons.twitch, 'name': 'Twitch'},
    {'icon': FontAwesomeIcons.behance, 'name': 'Behance'},
    {'icon': FontAwesomeIcons.dribbble, 'name': 'Dribbble'},
    {'icon': FontAwesomeIcons.spotify, 'name': 'Spotify'},
    {'icon': FontAwesomeIcons.globe, 'name': 'Website'},
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1.0,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, -2), // Shadow below the sheet
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar for dragging
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Select Social Media Icon',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1, // Adjust the aspect ratio here
                  ),
                  itemCount: socialIcons.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        onIconSelected(socialIcons[index]['icon']);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      splashColor: Colors.grey.withOpacity(0.3),
                      highlightColor: Colors.grey.withOpacity(0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10), // Adjust the padding here
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.2), // Add a light background color for selected icon
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: FaIcon(
                              socialIcons[index]['icon'],
                              size: 32, // Increase the icon size
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            socialIcons[index]['name'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).textTheme.labelMedium!.color,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
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
      },
    );
  }
}