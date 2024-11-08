import 'package:flutter/material.dart';
import 'package:mi_card/models/profile_data.dart';
import 'package:mi_card/widgets/profile_card.dart';
import 'package:mi_card/widgets/search_bar.dart';
import 'package:mi_card/dialogs/add_profile_dialog.dart';
import 'package:mi_card/dialogs/edit_profile_dialog.dart';
import 'package:mi_card/utils/uitls.dart';

class ContactsListScreen extends StatefulWidget {
  final List<ProfileData> profiles;
  final Function(List<ProfileData>) onProfilesUpdated;
  final bool isDarkMode;

  const ContactsListScreen({
    super.key,
    required this.profiles,
    required this.onProfilesUpdated,
    required this.isDarkMode,
  });

  @override
  _ContactsListScreenState createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  ProfileData? recentlyDeletedProfile;
  int? recentlyDeletedProfileIndex;
  List<ProfileData> sortedProfiles = [];

  String searchQuery = '';
  String selectedFilter = 'Name';
  final List<String> filterOptions = ['Name', 'Role', 'Phone', 'Email'];

  @override
  void initState() {
    super.initState();
    _updateSortedProfiles();
  }

  void _updateSortedProfiles() {
    sortedProfiles = List<ProfileData>.from(widget.profiles);
    sortedProfiles.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      return 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    _updateSortedProfiles(); 
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: Column(
        children: [
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
                    Navigator.pop(context);
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
                    isDarkMode: widget.isDarkMode,
                  ),
                ),
              ],
            ),
          ),
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
                child: sortedProfiles.isEmpty
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
                        itemCount: sortedProfiles.length,
                        itemBuilder: (context, index) {
                          if (searchQuery.isNotEmpty) {
                            final profile = sortedProfiles[index];
                            final isMatch = isMatchProfile(
                                profile, searchQuery, selectedFilter);
                            if (!isMatch) return Container();
                          }

                          return Dismissible(
                            key: ValueKey(sortedProfiles[index].name),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) {
                              recentlyDeletedProfile = sortedProfiles[index];
                              recentlyDeletedProfileIndex = widget.profiles
                                  .indexOf(sortedProfiles[index]);

                              setState(() {
                                widget.profiles
                                    .removeAt(recentlyDeletedProfileIndex!);
                                _updateSortedProfiles();
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
                                          _updateSortedProfiles();
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
                                final originalIndex = widget.profiles
                                    .indexOf(sortedProfiles[index]);
                                editProfile(context, originalIndex);
                              },
                              onToggleFavorite: () {
                                final originalIndex = widget.profiles
                                    .indexOf(sortedProfiles[index]);
                                setState(() {
                                  widget.profiles[originalIndex].isFavorite =
                                      !widget
                                          .profiles[originalIndex].isFavorite;
                                  _updateSortedProfiles();
                                });
                                widget.onProfilesUpdated(widget.profiles);
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

  void addNewProfile() {
    showDialog(
      context: context,
      builder: (context) => AddProfileDialog(
        onProfileAdded: (profile) {
          setState(() {
            widget.profiles.add(profile);
            _updateSortedProfiles();
          });
          widget.onProfilesUpdated(widget.profiles);
        },
        getRandomColor: getRandomColor,
      ),
    );
  }

  void editProfile(BuildContext context, int index) {
    final profile = widget.profiles[index];
    showDialog(
      context: context,
      builder: (context) => EditProfileDialog(
        profile: profile,
        profiles: widget.profiles, 
        onProfilesUpdated: widget.onProfilesUpdated,
      ),
    );
  }
}
