import 'package:flutter/material.dart';
import 'package:mi_card2/models/profile_data.dart';
import 'package:mi_card2/widgets/profile_card.dart';
import 'package:mi_card2/widgets/search_bar.dart';
import 'dart:math';

class SwipeableScreen extends StatefulWidget {
  final List<ProfileData> profiles;
  final Function(List<ProfileData>) onProfilesUpdated;
  final bool isDarkMode;

  const SwipeableScreen({
    super.key,
    required this.profiles,
    required this.onProfilesUpdated,
    required this.isDarkMode,
  });

  @override
  _SwipeableScreenState createState() => _SwipeableScreenState();
}

class _SwipeableScreenState extends State<SwipeableScreen> {
  ProfileData? recentlyDeletedProfile;
  int? recentlyDeletedProfileIndex;

  String searchQuery = '';
  String selectedFilter = 'Name'; // Default filter
  final List<String> filterOptions = ['Name', 'Role', 'Phone', 'Email'];

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: Column(
        children: [
          // Custom header with back button and search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
                Expanded(
                  child: CustomSearchBar(
                    searchQuery: searchQuery,
                    selectedFilter: selectedFilter,
                    filterOptions: filterOptions,
                    onSearchChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    onFilterChanged: (value) {
                      setState(() {
                        selectedFilter = value!;
                      });
                    },
                    isDarkMode: widget.isDarkMode, // Pass the dark mode setting
                  ),
                ),
              ],
            ),
          ),
          // Profile card container
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? Colors.grey[850] : Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: widget.profiles.isEmpty
                    ? Center(
                        child: Text(
                          'No profiles added. Start by clicking on the add button.',
                          style: TextStyle(
                            fontSize: 16,
                            color: widget.isDarkMode
                                ? Colors.white70
                                : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: widget.profiles.length,
                        itemBuilder: (context, index) {
                          // Filtering logic
                          if (searchQuery.isNotEmpty) {
                            final profile = widget.profiles[index];
                            final isMatch = _isMatch(profile);
                            if (!isMatch) return Container(); // Skip this item
                          }

                          // Sort profiles by favorites
                          final sortedProfiles =
                              List<ProfileData>.from(widget.profiles);
                          sortedProfiles.sort((a, b) {
                            if (a.isFavorite && !b.isFavorite) return -1;
                            if (!a.isFavorite && b.isFavorite) return 1;
                            return 0;
                          });

                          return Dismissible(
                            key: ValueKey(sortedProfiles[index].name),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) {
                              recentlyDeletedProfile = sortedProfiles[index];
                              recentlyDeletedProfileIndex = index;

                              setState(() {
                                widget.profiles.removeAt(index);
                              });
                              widget.onProfilesUpdated(widget.profiles);

                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Profile deleted',
                                    style: TextStyle(
                                      color: widget.isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                  backgroundColor: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    textColor: widget.isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                    onPressed: () {
                                      if (recentlyDeletedProfile != null &&
                                          recentlyDeletedProfileIndex != null) {
                                        setState(() {
                                          widget.profiles.insert(
                                              recentlyDeletedProfileIndex!,
                                              recentlyDeletedProfile!);
                                        });
                                        widget
                                            .onProfilesUpdated(widget.profiles);
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: ProfileCard(
                              profile: sortedProfiles[index],
                              onEdit: () {
                                editProfile(context, index);
                              },
                              onToggleFavorite: () {
                                setState(() {
                                  sortedProfiles[index].isFavorite =
                                      !sortedProfiles[index].isFavorite;
                                });
                                widget.onProfilesUpdated(sortedProfiles);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewProfile();
        },
        backgroundColor: widget.isDarkMode ? Colors.grey[700] : Colors.blue,
        child: Icon(Icons.add,
            color: widget.isDarkMode ? Colors.white : Colors.black),
      ),
    );
  }

  bool _isMatch(ProfileData profile) {
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

  Color _getRandomColor() {
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

  void addNewProfile() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController roleController = TextEditingController();
        TextEditingController phoneController = TextEditingController();
        TextEditingController emailController = TextEditingController();

        // Create a GlobalKey for the Form
        final _formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: const Text('Add New Profile'),
          content: SingleChildScrollView(
            // Make content scrollable if necessary
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'You can enter "-" if you want to leave any field blank.',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name cannot be empty unless using "-"';
                      }
                      return null; // Valid input
                    },
                  ),
                  TextFormField(
                    controller: roleController,
                    decoration: const InputDecoration(
                      hintText: 'Role',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Role cannot be empty unless using "-"';
                      }
                      return null; // Valid input
                    },
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: 'Phone Number',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number cannot be empty unless using "-"';
                      }
                      return null; // Valid input
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be empty unless using "-"';
                      }
                      return null; // Valid input
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Validate the form
                if (_formKey.currentState!.validate()) {
                  // If validation passes, add the profile
                  setState(() {
                    widget.profiles.add(ProfileData(
                      name: nameController.text,
                      role: roleController.text,
                      phone: phoneController.text,
                      email: emailController.text,
                      color: _getRandomColor(),
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void editProfile(BuildContext context, int index) {
    final profile = widget.profiles[index];
    final TextEditingController nameController =
        TextEditingController(text: profile.name);
    final TextEditingController roleController =
        TextEditingController(text: profile.role);
    final TextEditingController phoneController =
        TextEditingController(text: profile.phone);
    final TextEditingController emailController =
        TextEditingController(text: profile.email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(hintText: 'Role'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(hintText: 'Phone Number'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  widget.profiles[index] = ProfileData(
                    name: nameController.text,
                    role: roleController.text,
                    phone: phoneController.text,
                    email: emailController.text,
                    color: profile.color, // Keep the same color when editing
                    isFavorite:
                        profile.isFavorite, // Keep the same favorite status
                  );
                });
                widget.onProfilesUpdated(widget.profiles);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
