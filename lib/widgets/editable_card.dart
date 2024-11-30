import 'package:flutter/material.dart';  
  
class EditableCard extends StatelessWidget {  
  final IconData icon;  
  final String info;  
  final Color iconColor;  
  final TextEditingController controller;  
  final bool isEditing;  
  final bool isDarkMode;  
  final Function(String) onChanged;  
  final VoidCallback? onIconTap;  
  
  const EditableCard({  
   super.key,  
   required this.icon,  
   required this.info,  
   required this.iconColor,  
   required this.controller,  
   required this.isEditing,  
   required this.onChanged,  
   required this.isDarkMode,  
   this.onIconTap,  
  });  
  
  @override  
  Widget build(BuildContext context) {  
   return Card(  
    color: isDarkMode ? Colors.white : Colors.black,  
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),  
    child: ListTile(  
      leading: InkWell(  
       onTap: onIconTap,  
       child: Icon(icon, color: iconColor),  
      ),  
      title: isEditing  
        ? TextField(  
           controller: controller,  
           onChanged: onChanged,  
           textDirection: TextDirection.ltr,  
           decoration: InputDecoration(  
            hintText: info,  
            hintStyle: TextStyle(  
              color: isDarkMode ? Colors.black : Colors.white,  
            ),  
           ),  
           style: TextStyle(  
            color: isDarkMode ? Colors.black : Colors.white,  
           ),  
          )  
        : Text(  
           info,  
           style: TextStyle(  
            color: isDarkMode ? Colors.black : Colors.white,  
            fontSize: 20,  
            fontFamily: 'Dosis',  
           ),  
          ),  
    ),  
   );  
  }  
}
