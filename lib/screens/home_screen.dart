import 'package:flutter/material.dart';  
import 'package:mi_card/screens/contacts_screen.dart';  
import 'package:mi_card/widgets/editable_card.dart';  
import 'package:mi_card/models/profile_data.dart';  
import 'package:cloud_firestore/cloud_firestore.dart';  
import 'package:firebase_auth/firebase_auth.dart';  
import 'package:mi_card/dialogs/logout_dialog.dart';  
import 'package:mi_card/dialogs/color_picker.dart';  
import 'package:mi_card/dialogs/social_media_icons.dart';  
import 'package:mi_card/models/social_media_icon_data.dart';  
  
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
  String discord = 'Enter Discord';  
  
  final TextEditingController nameController = TextEditingController();  
  final TextEditingController roleController = TextEditingController();  
  final TextEditingController phoneController = TextEditingController();  
  final TextEditingController emailController = TextEditingController();  
  final TextEditingController discordController = TextEditingController();  
  
  Color selectedColor = Colors.teal;  
  IconData selectedSocialIcon = Icons.discord;  
  
  List<ProfileData> profiles = [];  
  List<Map<String, dynamic>> additionalCards = [];  
  
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
  
  Future<void> _loadUserData() async {  
   final userId = FirebaseAuth.instance.currentUser?.uid;  
   if (userId != null) {  
    final doc = await FirebaseFirestore.instance  
       .collection('users')  
       .doc(userId)  
       .get();  
  
    final additionalCardsSnapshot = await FirebaseFirestore.instance  
       .collection('users')  
       .doc(userId)  
       .collection('additional_cards')  
       .get();  
  
    if (doc.exists) {  
      setState(() {  
       name = doc['username'] ?? name;  
       role = doc['role'] ?? role;  
       phone = doc['phone'] ?? phone;  
       email = doc['email'] ?? email;  
       discord = doc['discord'] ?? discord;  
  
       selectedSocialIcon = SocialMediaIconData.getIconFromName(  
          doc['socialIcon'] ?? 'discord');  
  
       selectedColor = Color(doc['color'] ?? Colors.teal.value);  
  
       // Load additional cards  
       additionalCards = additionalCardsSnapshot.docs.map((cardDoc) {  
        return {  
          'title': cardDoc['title'] ?? 'New Card',  
          'value': cardDoc['value'] ?? '',  
          'icon': SocialMediaIconData.getIconFromName(  
            cardDoc['icon'] ?? 'add_circle')  
        };  
       }).toList();  
      });  
    }  
   }  
  }  
  
  Future<void> _updateUserDetails() async {  
   final userId = FirebaseAuth.instance.currentUser?.uid;  
   if (userId != null) {  
    await FirebaseFirestore.instance.collection('users').doc(userId).set({  
      'username': name,  
      'role': role,  
      'phone': phone,  
      'email': email,  
      'discord': discord,  
      'color': selectedColor.value,  
      'socialIcon': SocialMediaIconData.getIconName(selectedSocialIcon),  
    });  
  
    // Update additional cards  
    final cardsCollection = FirebaseFirestore.instance  
       .collection('users')  
       .doc(userId)  
       .collection('additional_cards');  
  
    // Delete existing cards  
    final existingCards = await cardsCollection.get();  
    for (var doc in existingCards.docs) {  
      await doc.reference.delete();  
    }  
  
    // Add current additional cards  
    for (var card in additionalCards) {  
      await cardsCollection.add({  
       'title': card['title'],  
       'value': card['value'],  
       'icon': SocialMediaIconData.getIconName(card['icon'])  
      });  
    }  
   }  
  }  
  
  void _addNewCard() {  
   setState(() {  
    additionalCards  
       .add({'title': 'New Card', 'value': '', 'icon': Icons.add_circle});  
    _updateUserDetails();  
   });  
  }  
  
  toggleEditMode() {  
   setState(() {  
    isEditing = !isEditing;  
    if (!isEditing) {  
      name = nameController.text;  
      role = roleController.text;  
      phone = phoneController.text;  
      email = emailController.text;  
      discord = discordController.text;  
      _updateUserDetails();  
    }  
   });  
  }  
  
  void _selectColor(Color color) {  
   setState(() {  
    selectedColor = color;  
   });  
   Navigator.of(context).pop();  
  }  
  
  @override  
  Widget build(BuildContext context) {  
   return Scaffold(  
    backgroundColor: isDarkMode ? Colors.black : selectedColor,  
    body: SafeArea(  
      child: Stack(  
       children: [  
        SingleChildScrollView(  
          padding: const EdgeInsets.only(top: 60, left: 24, right: 24),  
          child: Column(  
           mainAxisAlignment: MainAxisAlignment.center,  
           children: [  
            isEditing  
               ? TextField(  
                  controller: nameController,  
                  decoration: InputDecoration(  
                   hintText: 'Enter your name',  
                   hintStyle: TextStyle(color: Colors.grey.shade400),  
                  ),  
                  style: TextStyle(  
                   color: isDarkMode ? Colors.white : Colors.black,  
                   fontSize: 28,  
                  ),  
                  textAlign: TextAlign.center,  
                )  
               : Text(  
                  name,  
                  style: TextStyle(  
                   fontSize: 36,  
                   fontFamily: 'Pacifico',  
                   fontWeight: FontWeight.bold,  
                   color: isDarkMode ? selectedColor : Colors.white,  
                  ),  
                  textAlign: TextAlign.center,  
                ),  
            const SizedBox(height: 8),  
            isEditing  
               ? TextField(  
                  controller: roleController,  
                  decoration: InputDecoration(  
                   hintText: 'Enter your role',  
                   hintStyle: TextStyle(color: Colors.grey.shade400),  
                  ),  
                  style: TextStyle(  
                   color: isDarkMode ? Colors.white : Colors.black,  
                   fontSize: 24,  
                  ),  
                  textAlign: TextAlign.center,  
                )  
               : Text(  
                  role,  
                  style: TextStyle(  
                   fontSize: 24,  
                   fontFamily: 'Dosis',  
                   color: isDarkMode  
                      ? selectedColor.withOpacity(0.8)  
                      : Colors.white,  
                   letterSpacing: 1.5,  
                  ),  
                  textAlign: TextAlign.center,  
                ),  
            const SizedBox(height: 20),  
            Divider(  
              color: isDarkMode  
                ? Colors.grey  
                : selectedColor.withOpacity(0.6),  
              thickness: 1,  
            ),  
            const SizedBox(height: 16),  
            EditableCard(  
              icon: Icons.phone,  
              info: phone,  
              iconColor: selectedColor,  
              controller: phoneController,  
              isEditing: isEditing,  
              isDarkMode: isDarkMode,  
              onChanged: (value) {  
               setState(() {  
                phone = value;  
               });  
              },  
            ),  
            EditableCard(  
              icon: Icons.email,  
              info: email,  
              iconColor: selectedColor,  
              controller: emailController,  
              isEditing: isEditing,  
              isDarkMode: isDarkMode,  
              onChanged: (value) {  
               setState(() {  
                email = value;  
               });  
              },  
            ),  
            EditableCard(  
              isDarkMode: isDarkMode,  
              icon: selectedSocialIcon,  
              info: discord,  
              iconColor: selectedColor,  
              controller: discordController,  
              isEditing: isEditing,  
              onChanged: (value) {  
               setState(() {  
                discord = value;  
               });  
              },  
              onIconTap: isEditing  
                ? () {  
                   showModalBottomSheet(  
                    context: context,  
                    builder: (BuildContext context) {  
                      return SocialMediaIconPicker(  
                       onIconSelected: (IconData newIcon) {  
                        setState(() {  
                          selectedSocialIcon = newIcon;  
                        });  
                        _updateUserDetails();  
                       },  
                      );  
                    },  
                   );  
                  }  
                : null,  
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
                activeColor: selectedColor,  
                activeTrackColor: selectedColor.withOpacity(0.5),  
                inactiveThumbColor: selectedColor,  
                inactiveTrackColor: Colors.black,  
               ),  
              ],  
            ),  
            const SizedBox(height: 20),  
            Padding(  
              padding: const EdgeInsets.all(8.0),  
              child: Row(  
               mainAxisAlignment: MainAxisAlignment.center,  
               children: [  
                if (isEditing)  
                  IconButton(  
                   onPressed: () {  
                    showDialog(  
                      context: context,  
                      builder: (BuildContext context) {  
                       return AlertDialog(  
                        title: const Text('Select a color'),  
                        content: ColorPalette(  
                           onColorSelected: _selectColor),  
                       );  
                      },  
                    );  
                   },  
                   icon: const Icon(Icons.color_lens),  
                   color: isDarkMode ? Colors.white : Colors.black,  
                   iconSize: 30,  
                  ),  
                const SizedBox(width: 30),  
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
                      isDarkMode ? selectedColor : Colors.white,  
                   foregroundColor:  
                      isDarkMode ? Colors.white : selectedColor,  
                   padding: const EdgeInsets.symmetric(  
                      horizontal: 30, vertical: 15),  
                   shape: RoundedRectangleBorder(  
                    borderRadius: BorderRadius.circular(30),  
                   ),  
                   elevation: 5,  
                  ),  
                  child: const Text(  
                   'View People Info',  
                   style: TextStyle(  
                      fontSize: 18, fontWeight: FontWeight.bold),  
                  ),  
                ),  
               ],  
              ),  
            ),  
           ],  
          ),  
        ),  
        Positioned(  
          top: 10,  
          right: 10,  
          child: IconButton(  
           onPressed: () {  
            showLogoutDialog(context);  
           },  
           icon: const Icon(Icons.logout),  
           color: isDarkMode ? selectedColor : Colors.white,  
          ),  
        ),  
       ],  
      ),  
    ),  
    floatingActionButton: FloatingActionButton(  
      onPressed: toggleEditMode,  
      backgroundColor: isDarkMode ? selectedColor : Colors.black,  
      child: Icon(  
       isEditing ? Icons.check : Icons.edit,  
       color: isDarkMode ? Colors.white : selectedColor,  
      ),  
    ),  
   );  
  }  
}
