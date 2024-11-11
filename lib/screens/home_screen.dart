import 'package:flutter/material.dart';
import 'package:mi_card/screens/contacts_screen.dart';
import 'package:mi_card/widgets/editable_card.dart';
import 'package:mi_card/models/profile_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mi_card/dialogs/logout_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isEditing = false;
  bool isDarkMode = false;
  String name = 'Enter Name';
  String role = 'Enter Role';
  String phone = 'Enter Phone Number';
  String email = 'Enter Email';
  String discord = 'Enter discord';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController discordController = TextEditingController();

  List<ProfileData> profiles = [];

  @override
  void initState() {
    super.initState();
    nameController.text = name;
    roleController.text = role;
    phoneController.text = phone;
    emailController.text = email;
    discordController.text = discord;

    _loadUserData();
  }

  // Function to load user data from Firestore
  Future<void> _loadUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        setState(() {
          name = doc['username'] ?? name;
          role = doc['role'] ?? role;
          phone = doc['phone'] ?? phone;
          email = doc['email'] ?? email;
          discord = doc['discord'] ?? discord;

          nameController.text = name;
          roleController.text = role;
          phoneController.text = phone;
          emailController.text = email;
          discordController.text = discord;
        });
      }
    }
  }

  // Function to update user details in Firebase
  Future<void> _updateUserDetails() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'username': name,
        'role': role,
        'phone': phone,
        'email': email,
        'discord': discord,
      });
    }
  }

  void toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
      if (!isEditing) {
        name = nameController.text;
        role = roleController.text;
        phone = phoneController.text;
        email = emailController.text;
        discord = discordController.text;
        _updateUserDetails(); // Save to Firebase when editing is disabled
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.teal,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isEditing
                      ? Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(hintText: 'Enter your name'),
                            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                          ),
                      )
                      : Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'Pacifico',
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.teal : Colors.white,
                            ),
                          ),
                      ),
                  const SizedBox(height: 10),
                  isEditing
                      ? Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: TextField(
                            controller: roleController,
                            decoration: const InputDecoration(hintText: 'Enter your role'),
                            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                          ),
                      )
                      : Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                            role,
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Dosis',
                              color: isDarkMode ? Colors.teal.shade100 : Colors.teal.shade100,
                              letterSpacing: 2.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ),
                  SizedBox(
                    height: 20.0,
                    width: 150.0,
                    child: Divider(color: isDarkMode ? Colors.grey : Colors.teal.shade100),
                  ),
                  EditableCard(
                    icon: Icons.phone,
                    info: phone,
                    iconColor: Colors.teal,
                    controller: phoneController,
                    isEditing: isEditing,
                    onChanged: (value) {
                      setState(() {
                        phone = value;
                      });
                    },
                  ),
                  EditableCard(
                    icon: Icons.email,
                    info: email,
                    iconColor: Colors.teal,
                    controller: emailController,
                    isEditing: isEditing,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  EditableCard(
                    icon: Icons.discord,
                    info: discord,
                    iconColor: Colors.purple,
                    controller: discordController,
                    isEditing: isEditing,
                    onChanged: (value) {
                      setState(() {
                        discord = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Dark Mode', style: TextStyle(color: Colors.white)),
                      Switch(
                        value: isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            isDarkMode = value;
                          });
                        },
                        activeColor: Colors.tealAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactsListScreen(
                            profiles: profiles,
                            onProfilesUpdated: (updatedProfiles) {
                              setState(() {
                                profiles = updatedProfiles;
                              });
                            },
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.teal.shade600 : Colors.teal.shade100,
                      foregroundColor: isDarkMode ? Colors.white : Colors.teal.shade900,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'View People info',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed:  () {
                    showLogoutDialog(context); // Call the showLogoutDialog function
                  },
                icon: const Icon(Icons.logout),
                color: isDarkMode ? Colors.teal : Colors.white,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleEditMode,
        child: Icon(isEditing ? Icons.save : Icons.edit),
      ),
    );
  }
}
