import 'package:ckd_mobile/Login%20SignUp/Screen/changePassword.dart';
import 'package:ckd_mobile/Login%20SignUp/Screen/editprofile.dart';
import 'package:ckd_mobile/Login%20SignUp/Screen/home_Screen.dart';
import 'package:ckd_mobile/Login%20SignUp/Screen/library.dart';
import 'package:ckd_mobile/Login%20SignUp/Screen/personalData.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'reports.dart';
import 'login.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _username = "";
  String _email = "";
  String _dateJoined = "";
  int _selectedIndex = 2;

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
            _username = userDoc.data()?['username'] ?? '';
            _email = user.email ?? '';
            DateTime joinedDateTime = user.metadata.creationTime ?? DateTime.now();
            _dateJoined = DateFormat('yMMMd').format(joinedDateTime);
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Navigate to the HomeScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        // Navigate to the LibraryScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LibraryScreen()),
        );
        break;
      case 2:
        // Navigate to the SettingsScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color of the Scaffold to white
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Center(child: Text('Settings')),
        backgroundColor: const Color.fromARGB(255, 12, 119, 207),
      ),
      body: Container(
        color: Colors.white, // Set background color of the body to white
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSettingsOption(
              context,
              title: 'Personal Data',
              icon: Icons.person,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalDataScreen(
                      username: _username,
                      email: _email,
                      dateJoined: _dateJoined,
                    ),
                  ),
                );
              },
            ),
            _buildSettingsOption(
              context,
              title: 'Report',
              icon: Icons.bar_chart,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportsScreen()),
                );
              },
            ),
            _buildSettingsOption(
              context,
              title: 'Feedback',
              icon: Icons.feedback,
              onTap: () {
                _showFeedbackDialog(context);
              },
            ),
            _buildSettingsOption(
              context,
              title: 'Account',
              icon: Icons.account_circle,
              onTap: () {
                _showAccountOptions(context);
              },
            ),
            _buildSettingsOption(
              context,
              title: 'About',
              icon: Icons.info,
              onTap: () {
                _showAboutDialog(context); // Call the new method here
              },
            ),
            _buildSettingsOption(
              context,
              title: 'Log out',
              icon: Icons.logout,
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildSettingsOption(BuildContext context,
      {required String title, required IconData icon, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        onTap: onTap,
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    TextEditingController feedbackController = TextEditingController();

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

                      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
                      FirebaseFirestore.instance.runTransaction((transaction) async {
                        DocumentSnapshot userSnapshot = await transaction.get(userDoc);
                        int currentCount = (userSnapshot.data() as Map<String, dynamic>)['feedbackCount'] ?? 0;
                        transaction.update(userDoc, {'feedbackCount': currentCount + 1});
                      });

                      Navigator.of(context).pop();
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

  void _showAccountOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Account Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person),
                title: Text('View Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PersonalDataScreen(
                      username: _username,
                      email: _email,
                      dateJoined: _dateJoined,
                    )),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage(
                      MediaQuery.of(context).size.height, 
                    MediaQuery.of(context).size.width
                    )),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Change Password'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordScreen(
                      email: FirebaseAuth.instance.currentUser!.email!
                    )),
                  );
                },
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
                "Our goal is to empower you with knowledge to take control of your kidney health.",
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _handleLogout(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _handleLogout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
}
