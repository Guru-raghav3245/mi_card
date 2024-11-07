import 'package:flutter/material.dart';
import 'package:mi_card/models/profile_data.dart';

class EditProfileDialog extends StatefulWidget {
  final ProfileData profile;
  final Function(List<ProfileData>) onProfilesUpdated;
  final List<ProfileData> profiles;

  const EditProfileDialog({
    super.key,
    required this.profile,
    required this.onProfilesUpdated,
    required this.profiles,
  });

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.profile.name;
    _roleController.text = widget.profile.role;
    _phoneController.text = widget.profile.phone;
    _emailController.text = widget.profile.email;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Name'),
          ),
          TextField(
            controller: _roleController,
            decoration: const InputDecoration(hintText: 'Role'),
          ),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(hintText: 'Phone Number'),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              widget.profile.name = _nameController.text;
              widget.profile.role = _roleController.text;
              widget.profile.phone = _phoneController.text;
              widget.profile.email = _emailController.text;
            });
            widget.onProfilesUpdated(widget.profiles);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}