import 'package:flutter/material.dart';
import 'package:mi_card2/screens/swipeable_screen.dart';
import 'package:mi_card2/widgets/editable_card.dart';
import 'package:mi_card2/models/profile_data.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isEditing = false;
  bool isDarkMode = false; // State variable for dark mode
  String name = 'Guru Raghav';
  String role = 'Music Producer';
  String phone = '+91 82174 70373';
  String email = 'master.guru.raghav@gmail.com';
  String discord = 'guru_raghav_';

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

    profiles = [
      ProfileData(
        name: 'Magesh Kuppan',
        role: 'Guru\'s Dad/ Software Architect',
        phone: '+91 99019 11221',
        email: 'tkmagesh77@gmail.com',
        color: Colors.blue,
      ),
      ProfileData(
        name: 'Meena Magesh',
        role: 'Guru\'s Mom/ Investor',
        phone: '+91 9900350777',
        email: 'mca.meena@gmail.com',
        color: Colors.pink,
      ),
    ];
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

  void addNewProfile() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController roleController = TextEditingController();
        TextEditingController phoneController = TextEditingController();
        TextEditingController emailController = TextEditingController();

        return AlertDialog(
          title: const Text('Add New Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'You can enter "-" if you want to leave any field blank.',
                style: TextStyle(color: Colors.grey), // Optional styling
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                  height: 10), // Spacing between hint and text fields
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
              ),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(
                  hintText: 'Role',
                ),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                ),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Validate inputs
                if (nameController.text.isEmpty && nameController.text != "-") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Name cannot be empty unless using "-"')),
                  );
                  return;
                }
                if (roleController.text.isEmpty && roleController.text != "-") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Role cannot be empty unless using "-"')),
                  );
                  return;
                }
                if (phoneController.text.isEmpty &&
                    phoneController.text != "-") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Phone number cannot be empty unless using "-"')),
                  );
                  return;
                }
                if (emailController.text.isEmpty &&
                    emailController.text != "-") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Email cannot be empty unless using "-"')),
                  );
                  return;
                }

                // If all validations pass, add the profile
                setState(() {
                  profiles.add(ProfileData(
                    name: nameController.text,
                    role: roleController.text,
                    phone: phoneController.text,
                    email: emailController.text,
                    color: getRandomColor(),
                  ));
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Color getRandomColor() {
    final random = Random();
    final List<Color> presetColors = [
      Colors.blueAccent,
      Colors.redAccent.withOpacity(0.2),
      Colors.greenAccent,
      Colors.purpleAccent,
      Colors.orangeAccent,
      Colors.yellowAccent,
      Colors.tealAccent,
      Colors.pinkAccent,
    ];
    return presetColors[random.nextInt(presetColors.length)];
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
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('images/profile_picture.jpg'),
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
                              : Colors
                                  .black), // Change text color based on mode
                    )
                  : Text(
                      name,
                      style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Pacifico',
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? Colors.teal
                              : Colors
                                  .white), // Change text color based on mode
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
                              : Colors
                                  .black), // Change text color based on mode
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
                      style: TextStyle(
                          color: Colors.white)), // Change color based on mode
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value; // Toggle dark mode
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
                      builder: (context) => SwipeableScreen(
                        profiles: profiles,
                        onProfilesUpdated: (updatedProfiles) {
                          setState(() {
                            profiles =
                                updatedProfiles; // Update profiles with new data
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
