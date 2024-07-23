import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ckd_mobile/Login%20SignUp/Screen/login.dart';

class ProfilePage extends StatefulWidget {
  final double height;
  final double width;

  const ProfilePage(this.height, this.width, {Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "";
  String userEmail = "";

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
            userName = userDoc.data()?['username'] ?? '';
            userEmail = userDoc.data()?['email'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
      ),
      body: _profilePageUI(context),
    );
  }

  Widget _profilePageUI(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userImageWidget("images/avatar.jpeg"),
            SizedBox(height: 20),
            _userNameWidget(userName),
            SizedBox(height: 10),
            _userEmailWidget(userEmail),
            SizedBox(height: 20),
            _logoutButton(context),
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

  Widget _userNameWidget(String userName) {
    return Text(
      userName.isNotEmpty ? userName : 'Fetching username...',
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.black, fontSize: 24),
    );
  }

  Widget _userEmailWidget(String email) {
    return Text(
      email.isNotEmpty ? email : 'Fetching email...',
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.grey, fontSize: 16),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Logout"),
              content: const Text("Are you sure you want to logout?"),
              actions: <Widget>[
                TextButton(
                  child: const Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Yes"),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        backgroundColor: Colors.grey,
        foregroundColor: Colors.black,
      ),
      child: const Text("Logout"),
    );
  }
}