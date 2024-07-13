import 'package:flutter/material.dart';

class PredictionScreen extends StatelessWidget {
  final dynamic predictionResult; // Define a field to hold prediction result

  PredictionScreen({Key? key, required this.predictionResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Prediction Result:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              '$predictionResult', // Display prediction result here
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
