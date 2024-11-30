import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialMediaIconData {
  static final List<Map<String, dynamic>> icons = [
    {
      'icon': FontAwesomeIcons.discord,
      'name': 'discord',
      'displayName': 'Discord'
    },
    {
      'icon': FontAwesomeIcons.facebook,
      'name': 'facebook',
      'displayName': 'Facebook'
    },
    {
      'icon': FontAwesomeIcons.telegram,
      'name': 'telegram',
      'displayName': 'Telegram'
    },
    {
      'icon': FontAwesomeIcons.whatsapp,
      'name': 'whatsapp',
      'displayName': 'WhatsApp'
    },
    {
      'icon': FontAwesomeIcons.reddit,
      'name': 'reddit',
      'displayName': 'Reddit'
    },
    {
      'icon': FontAwesomeIcons.linkedin,
      'name': 'linkedin',
      'displayName': 'LinkedIn'
    },
    {
      'icon': FontAwesomeIcons.snapchat,
      'name': 'snapchat',
      'displayName': 'Snapchat'
    },
    {
      'icon': FontAwesomeIcons.instagram,
      'name': 'instagram',
      'displayName': 'Instagram'
    },
    {
      'icon': FontAwesomeIcons.tiktok,
      'name': 'tiktok',
      'displayName': 'TikTok'
    },
    {
      'icon': FontAwesomeIcons.twitter,
      'name': 'twitter',
      'displayName': 'Twitter'
    },
    {
      'icon': FontAwesomeIcons.github,
      'name': 'github',
      'displayName': 'GitHub'
    },
    {
      'icon': FontAwesomeIcons.medium,
      'name': 'medium',
      'displayName': 'Medium'
    },
    {'icon': FontAwesomeIcons.dev, 'name': 'dev', 'displayName': 'Dev.to'},
    {
      'icon': FontAwesomeIcons.stackOverflow,
      'name': 'stackoverflow',
      'displayName': 'Stack Overflow'
    },
    {
      'icon': FontAwesomeIcons.youtube,
      'name': 'youtube',
      'displayName': 'YouTube'
    },
    {
      'icon': FontAwesomeIcons.twitch,
      'name': 'twitch',
      'displayName': 'Twitch'
    },
    {
      'icon': FontAwesomeIcons.behance,
      'name': 'behance',
      'displayName': 'Behance'
    },
    {
      'icon': FontAwesomeIcons.dribbble,
      'name': 'dribbble',
      'displayName': 'Dribbble'
    },
    {
      'icon': FontAwesomeIcons.spotify,
      'name': 'spotify',
      'displayName': 'Spotify'
    },
    {
      'icon': FontAwesomeIcons.globe,
      'name': 'website',
      'displayName': 'Website'
    },
  ];

  static IconData getIconFromName(String name) {
    final matchingIcon = icons.firstWhere(
      (item) => item['name'] == name,
      orElse: () => icons.first, // Default to Discord if not found
    );

    return matchingIcon['icon'] as IconData;
  }

  static String getIconName(IconData icon) {
    final matchingIcon = icons.firstWhere(
      (item) => item['icon'] == icon,
      orElse: () => icons.first, // Default to Discord if not found
    );

    return matchingIcon['name'] as String;
  }

  static String getDisplayName(IconData icon) {
    final matchingIcon = icons.firstWhere(
      (item) => item['icon'] == icon,
      orElse: () => icons.first, // Default to Discord if not found
    );

    return matchingIcon['displayName'] as String;
  }
}
