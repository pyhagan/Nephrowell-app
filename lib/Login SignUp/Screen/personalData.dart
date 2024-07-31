import 'package:flutter/material.dart';

class PersonalDataScreen extends StatelessWidget {
  final String username;
  final String email;
  final String dateJoined;

  const PersonalDataScreen({
    Key? key,
    required this.username,
    required this.email,
    required this.dateJoined,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the width of the screen
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Personal Data')), // Center the title
        backgroundColor: const Color.fromARGB(255, 12, 119, 207),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        width: double.infinity, // Ensure the container covers the whole width
        height: double.infinity, // Ensure the container covers the whole height
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDataField(
              context,
              label: 'Username',
              value: username,
              screenWidth: screenWidth,
            ),
            SizedBox(height: 16.0),
            _buildDataField(
              context,
              label: 'Email',
              value: email,
              screenWidth: screenWidth,
            ),
            SizedBox(height: 16.0),
            _buildDataField(
              context,
              label: 'Date Joined',
              value: dateJoined,
              screenWidth: screenWidth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataField(BuildContext context,
      {required String label, required String value, required double screenWidth}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color.fromARGB(255, 7, 128, 227), // Blue color for the label
          ),
        ),
        SizedBox(height: 8.0),
        Container(
          width: screenWidth * 0.8, // Set width to 80% of the screen width
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // Increased vertical padding
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Colors.grey, // Border color
              width: 0.2, // Border width (thicker border)
            ),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
  }
}
