import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:mi_card/screens/contacts_list.dart';
import 'package:mi_card/widgets/editable_card.dart';
import 'package:mi_card/models/profile_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isEditing = false;
  bool isDarkMode = false; 
  String name = 'Guru Raghav';
  String role = 'Music Producer';
  String phone = '+91 82174 70373';
  String email = 'master.guru.raghav@gmail.com';
  String discord = 'guru_raghav_';
  File? _profileImage; 

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

    profiles = [];
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
      }
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await showDialog<File>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () async {
              final image = await picker.pickImage(source: ImageSource.camera);
              if (image != null) {
                Navigator.pop(context, File(image.path));
              }
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () async {
              final image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                Navigator.pop(context, File(image.path));
              }
            },
            child: const Text('Gallery'),
          ),
        ],
      ),
    );
    
    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.teal,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isEditing)
                GestureDetector(
                  onTap: _pickImage, 
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage == null
                        ? const AssetImage('images/profile_picture.jpg')
                        : FileImage(_profileImage!) as ImageProvider,
                  ),
                )
              else
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage == null
                      ? const AssetImage('images/profile_picture.jpg')
                      : FileImage(_profileImage!) as ImageProvider,
                ),
              const SizedBox(height: 10),
              isEditing
                  ? TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(hintText: 'Enter your name'),
                      style: TextStyle(
                          color: isDarkMode
                              ? Colors.white
                              : Colors.black),
                    )
                  : Text(
                      name,
                      style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Pacifico',
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? Colors.teal
                              : Colors.white),
                    ),
              const SizedBox(height: 10),
              isEditing
                  ? TextField(
                      controller: roleController,
                      decoration:
                          const InputDecoration(hintText: 'Enter your role'),
                      style: TextStyle(
                          color: isDarkMode
                              ? Colors.white
                              : Colors.black),
                    )
                  : Text(
                      role,
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Dosis',
                          color: isDarkMode
                              ? Colors.teal.shade100
                              : Colors.teal.shade100,
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.bold),
                    ),
              SizedBox(
                height: 20.0,
                width: 150.0,
                child: Divider(
                    color: isDarkMode ? Colors.grey : Colors.teal.shade100),
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
                  const Text('Dark Mode',
                      style: TextStyle(color: Colors.white)),
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
                  backgroundColor:
                      isDarkMode ? Colors.teal.shade600 : Colors.teal.shade100,
                  foregroundColor:
                      isDarkMode ? Colors.white : Colors.teal.shade900,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleEditMode,
        child: Icon(isEditing ? Icons.save : Icons.edit),
      ),
    );
  }
}
