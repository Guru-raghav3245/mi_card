import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String searchQuery;
  final String selectedFilter;
  final List<String> filterOptions;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onFilterChanged;
  final bool isDarkMode; // Added isDarkMode parameter

  const CustomSearchBar({
    super.key,
    required this.searchQuery,
    required this.selectedFilter,
    required this.filterOptions,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.isDarkMode, // Initialize in constructor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Dropdown for filter options with dark mode styling
          DropdownButton<String>(
            value: selectedFilter,
            items: filterOptions
                .map((option) => DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ))
                .toList(),
            onChanged: onFilterChanged,
            dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
            iconEnabledColor: isDarkMode ? Colors.white : Colors.black,
          ),
          const SizedBox(width: 8),
          // TextField for search input with dark mode styling
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.blue : Colors.blueAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
