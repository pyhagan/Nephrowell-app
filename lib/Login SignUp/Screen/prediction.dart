import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prediction',
      home: PredictionScreen(age: '', bloodPressure: '',),
    );
  }
}




class PredictionScreen extends StatelessWidget {
  final String age;
  final String bloodPressure;
  // Add more variables as needed

  PredictionScreen({
    required this.age,
    required this.bloodPressure,
    // Add more variables as needed
  });

  @override
  Widget build(BuildContext context) {
    // Implement prediction logic here using received data
    // Example:
    // String predictionResult = makePrediction(age, bloodPressure);
    
    // Simulated prediction result
    String predictionResult = 'Chronic Kidney Disease Detected';
    String probability = '95%';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Prediction Result',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            Text(''),

            SizedBox(height: 100.0),
            
            Text(
              
              'Your Status: $predictionResult',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                color: Colors.black
                
              ),
              textAlign: TextAlign.center
            ),
            SizedBox(height: 16.0),
            Text(
              'Probability of kidney diseae: $probability',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                color: Colors.black
              ),
              textAlign: TextAlign.center
            ),
            SizedBox(height: 16.0),
            Container(
            width: double.infinity, 
            margin:EdgeInsets.only(top: 90, bottom: 50, left: 70, right: 70),
            child:Text("Please see a medical practitioner for further diagnosis and treatment.",
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          ),),
          ],
        ),
      ),
    );
  }
}
