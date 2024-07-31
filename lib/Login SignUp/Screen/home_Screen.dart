import 'dart:ui';
import 'package:ckd_mobile/Login%20SignUp/Screen/reports.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter/services.dart';

import 'changePassword.dart';
import 'editprofile.dart';
import 'info.dart';
import 'library.dart';
import 'login.dart';
import 'personalData.dart';
import 'communityUI.dart';
import 'settings.dart';  // Import the settings screen

void trackAppUsage() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot userSnapshot = await transaction.get(userDoc);
      if (userSnapshot.exists) {
        int currentCount = (userSnapshot.data() as Map<String, dynamic>)['appUsageCount'] ?? 0;
        transaction.update(userDoc, {'appUsageCount': currentCount + 1});
      } else {
        transaction.set(userDoc, {'appUsageCount': 1});
      }
    });
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    trackAppUsage();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            _userName = userDoc.data()?['username'] ?? '';
            print('Fetched username: $_userName');
          });
        } else {
          print('User document does not exist');
        }
      } else {
        print('No user is signed in');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'NephroWell',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: [
            IconButton(
              icon: Icon(Icons.chat),
              tooltip: 'Chat',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommunityScreen()),
                );
              },
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'images/background2.jpeg',
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 9.0, sigmaY: 9.0),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 50),
                          child: Text(
                            "Welcome $_userName, to NephroWell. I can help you learn more about your kidney.",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 380,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 9, 112, 197)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CKDAssessmentScreen()),
                              );
                            },
                            child: const Text(
                              "Start assessment",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'Library',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          onTap: (int index) {
            switch (index) {
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LibraryScreen()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
                break;
            }
          },
        ),
      ),
    );
  }
}
