
 import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/services.dart';

import 'changePassword.dart';
import 'editprofile.dart';
import 'info.dart';
import 'library.dart';
import 'login.dart';
import 'profile.dart';
import 'communityUI.dart';

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
              color: Colors.blue, // Make the text blue
              fontSize: 20, // Adjust font size if needed
            ),
          ),
          backgroundColor: Colors.white, // Background color of the app bar
          elevation: 4, // Elevation of the app bar
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: [
            IconButton(
              icon: Icon(Icons.chat), 
              tooltip: 'Chat',// Add a chat icon
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
            // Background image
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
            // Foreground content
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
            BottomNavigationBarItem(
              icon: PopupMenuButton<int>(
                icon: const Icon(Icons.settings), 
                onSelected: (int value) {
                  _handleMenuSelection(context, value);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  const PopupMenuItem<int>(
                    value: 1,
                    child: ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text('Account'),
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: ListTile(
                      leading: Icon(Icons.info),
                      title: Text('About'),
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 3,
                    child: ListTile(
                      leading: Icon(Icons.feedback),
                      title: Text('Feedback'),
                    ),
                  ),
                  
                  const PopupMenuItem<int>(
                    value: 4,
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    ),
                  ),
                 
                  
                ],
              ),
              label: 'Settings', // Update the label
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
              // The case for the settings menu is handled by the PopupMenuButton
            }
          },
        ),
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, int value) {
    switch (value) {
      case 1:
        _showAccountOptions(context);
        break;
      case 2:
        _showAboutDialog(context);
        break;
        case 3:
    _showFeedbackDialog(context); // Show feedback dialog
      break;
      case 4:
        _showLogoutDialog(context);
        break;
       
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About NephroWell'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "NephroWell is an app designed to help you monitor and understand your kidney health. "
                "With this app, you can assess your Chronic Kidney Disease (CKD) status, access a comprehensive library of information, "
                "and manage your personal health records.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 10),
              Text(
                "Our goal is to empower you with knowledge and tools to take control of your kidney health.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAccountOptions(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          button.localToGlobal(Offset.zero, ancestor: overlay),
          button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
        ),
        Offset.zero & overlay.size,
      ),
      items: <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 1,
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('View Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width)),
              );
            },
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width)),
              );
            },
          ),
        ),
        PopupMenuItem<int>(
          value: 3,
          child: ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordScreen(email: FirebaseAuth.instance.currentUser!.email!)),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showFeedbackDialog(BuildContext context) {
  TextEditingController feedbackController = TextEditingController(); // Controller to get feedback input
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Provide Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'We value your feedback! Please let us know how we can improve your experience with NephroWell.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
            TextField(
              controller: feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter your feedback here...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Submit'),
            onPressed: () async {
              String feedback = feedbackController.text.trim();
              if (feedback.isNotEmpty) {
                try {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await FirebaseFirestore.instance.collection('feedback').add({
                      'userId': user.uid,
                      'feedback': feedback,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    Navigator.of(context).pop(); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thank you for your feedback!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User not logged in. Please log in to provide feedback.')),
                    );
                  }
                } catch (e) {
                  print('Error submitting feedback: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to submit feedback. Please try again later.')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please provide your feedback before submitting.')),
                );
              }
            },
          ),
        ],
      );
    },
  );
}


  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _handleLogout(context); //logout action
              },
            ),
          ],
        );
      },
    );
  }

  

  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false, // Prevents user from going back to HomeScreen
    );
    // Perform any additional logout actions if needed
  }
}
