import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ckd_mobile/Login%20SignUp/Screen/login.dart';

class EditProfilePage extends StatefulWidget {
  final double height;
  final double width;

  const EditProfilePage(this.height, this.width, {Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            usernameController = TextEditingController(text: userDoc.data()?['username'] ?? '');
            emailController = TextEditingController(text: userDoc.data()?['email'] ?? '');
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 5) {
      return 'Username must be at least 5 characters';
    }
    if (!RegExp(r'^[a-zA-Z]').hasMatch(value)) {
      return 'Username must start with an alphabet';
    }
    if (RegExp(r'[^\w]').hasMatch(value)) {
      return 'Username should not contain special characters';
    }
    if (!RegExp(r'^[a-zA-Z]{4}').hasMatch(value)) {
      return 'First four characters should be alphabets';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    if (RegExp(r'^[0-9]').hasMatch(value)) {
      return 'Email cannot start with a number';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@(gmail\.com|yahoo\.com|outlook\.com)$').hasMatch(value)) {
      return 'Please enter a valid email address (gmail.com, yahoo.com, outlook.com)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: const Text('Edit Profile'),
        backgroundColor: Colors.blue,
      ),
      body: _editProfilePageUI(context),
    );
  }

  Widget _editProfilePageUI(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userImageWidget("images/avatar.jpeg"),
            const SizedBox(height: 20),
            TextFormField(
              
              controller: usernameController,
              decoration: InputDecoration(
                hintText: 'Enter your username',
                icon: Icon(Icons.person),
              ),
              validator: usernameValidator,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                icon: Icon(Icons.email),
              ),
              validator: emailValidator,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _saveChanges();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userImageWidget(String image) {
    double imageRadius = widget.height * 0.15;
    return CircleAvatar(
      radius: imageRadius,
      backgroundImage: AssetImage(image),
    );
  }

  void _saveChanges() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'username': usernameController.text.trim(),
          'email': emailController.text.trim(),
          'updated at': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }
}
