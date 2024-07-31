import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child:Text('NephroWell Reports'),) 
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromARGB(255, 38, 129, 204)!, Colors.blue[900]!],
          ),
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: _fetchUserReports(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('No data available'));
            }

            Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
            int appUsageCount = data?['appUsageCount'] ?? 0;
            int feedbackCount = data?['feedbackCount'] ?? 0;

            // Determine the correct message based on appUsageCount
            String appUsageMessage = appUsageCount == 1
                ? 'You have opened this app $appUsageCount time'
                : 'You have opened this app $appUsageCount times';

         // Determine the correct message for feedback count
            String feedbackMessage = feedbackCount == 0
                ? 'No feedback entries'
                : feedbackCount == 1
                    ? '1 feedback entry'
                    : '$feedbackCount feedback entries';

                      return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    buildReportCard('App Usage', appUsageMessage),
                    SizedBox(height: 20),
                    buildReportCard('Feedback', feedbackMessage),
                    SizedBox(height: 20),
                   
                  ],
                ),
              ),
            );
          },
        ),
      ),
    
    );
  }

  Widget buildReportCard(String title, String content) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DocumentSnapshot> _fetchUserReports() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    }
    throw Exception('User not logged in');
  }
}
