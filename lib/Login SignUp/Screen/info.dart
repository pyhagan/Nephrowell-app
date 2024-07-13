import 'package:flutter/material.dart';
import 'prediction.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CKDAssessmentScreen extends StatefulWidget {
  @override
  _CKDAssessmentScreenState createState() => _CKDAssessmentScreenState();
}

class _CKDAssessmentScreenState extends State<CKDAssessmentScreen> {
  TextEditingController _ageController = TextEditingController();
  TextEditingController _bloodPressureController = TextEditingController();
  TextEditingController _sgController = TextEditingController();
  TextEditingController _albuminController = TextEditingController();
  TextEditingController _suController = TextEditingController();
  TextEditingController _bgrController = TextEditingController();
  TextEditingController _bloodUreaController = TextEditingController();
  TextEditingController _serumCreatinineController = TextEditingController();
  TextEditingController _sodiumController = TextEditingController();
  TextEditingController _potassiumController = TextEditingController();
  TextEditingController _hemoglobinController = TextEditingController();
  TextEditingController _packedCellVolumeController = TextEditingController();
  TextEditingController _whiteBloodCellCountController = TextEditingController();
  TextEditingController _redBloodCellCountController = TextEditingController();

  String _selectedRedBloodCells = '';
  String _selectedPusCell = '';
  String _selectedPusCellClumps = '';
  String _selectedBacteria = '';
  String _selectedHypertension = '';
  String _selectedDiabetes = '';
  String _selectedCoronaryArteryDisease = '';
  String _selectedPedalEdema = '';
  String _selectedAnemia = '';

  Future<void> _assessStatus() async {
    var data = {
      'age': _ageController.text,
      'diastolic bp': _bloodPressureController.text,
      'sg': _sgController.text,
      'al': _albuminController.text,
      'su': _suController.text,
      'bgr': _bgrController.text,
      'bu': _bloodUreaController.text,
      'sc': _serumCreatinineController.text,
      'sod': _sodiumController.text,
      'pot': _potassiumController.text,
      'hemo': _hemoglobinController.text,
      'pcv': _packedCellVolumeController.text,
      'wc': _whiteBloodCellCountController.text,
      'rc': _redBloodCellCountController.text,
      'rbc': _selectedRedBloodCells,
      'pc': _selectedPusCell,
      'pcc': _selectedPusCellClumps,
      'ba': _selectedBacteria,
      'htn': _selectedHypertension,
      'dm': _selectedDiabetes,
      'cad': _selectedCoronaryArteryDisease,
      'pe': _selectedPedalEdema,
      'ane': _selectedAnemia,
    };
    var body = json.encode(data);

    var url = Uri.parse('https://flask-traditional-api.onrender.com/predict'); // Replace with your Flask API endpoint
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        var predictionResult = json.decode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PredictionScreen(predictionResult: predictionResult)),
        );
      } else {
        print('Error ${response.statusCode}: ${response.reasonPhrase}');
        // Optionally, show an error dialog or message to the user
      }
    } catch (e) {
      print('Error: $e');
      // Handle other exceptions if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Medical Information',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.numberWithOptions(signed: false),
                decoration: InputDecoration(
                  labelText: 'Age',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: 16.0),

              TextFormField(
                controller: _bloodPressureController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Diastolic Blood Pressure',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
               SizedBox(height: 16.0),

               TextFormField(
                controller: _sgController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Specific Gravity',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
               SizedBox(height: 16.0),

               TextFormField(
                controller: _albuminController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Albumin',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: 16.0),

              TextFormField(
                controller: _suController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Sugar',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: 16.0),

              TextFormField(
                controller: _bgrController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Blood Glucose Random',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: 16.0),

              
              TextFormField(
                controller: _bloodUreaController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Blood Urea',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: 16.0),



              TextFormField(
                controller: _serumCreatinineController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Serum Creatinine',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: 16.0),

              TextFormField(
                controller: _sodiumController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Sodium',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: 16.0),

              TextFormField(
                controller: _potassiumController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Potassium',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: 16.0),

              TextFormField(
                controller: _hemoglobinController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Hemoglobin',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: 16.0),


              TextFormField(
                controller: _packedCellVolumeController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Packed Cell Volume',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: 16.0),

              TextFormField(
                controller: _whiteBloodCellCountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'White Blood Cell Count',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: 16.0),

              TextFormField(
                controller: _redBloodCellCountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Red Blood Cell Count',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: 16.0),

              ListTile(
                title: Text('Red Blood Cells', style: TextStyle(fontWeight: FontWeight.bold,color:  Colors.black)),
                subtitle: Row(
                  children: [
                    Radio(
                      value: 'Normal',
                      groupValue: _selectedRedBloodCells,
                      onChanged: (value) {
                        setState(() {
                          _selectedRedBloodCells = value.toString();
                        });
                      },
                    ),
                    Text('Normal', style: TextStyle(color: Colors.black)),
                    Radio(
                      value: 'Abnormal',
                      groupValue: _selectedRedBloodCells,
                      onChanged: (value) {
                        setState(() {
                          _selectedRedBloodCells = value.toString();
                        });
                      },
                    ),
                    Text('Abnormal', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
               SizedBox(height: 16.0),

              ListTile(
                title: Text('Pus Cell', style: TextStyle(fontWeight: FontWeight.bold,color:  Colors.black)),
                subtitle: Row(
                  children: [
                    Radio(
                      value: 'Normal',
                      groupValue: _selectedPusCell,
                      onChanged: (value) {
                        setState(() {
                          _selectedPusCell = value.toString();
                        });
                      },
                    ),
                    Text('Normal', style: TextStyle(color: Colors.black)),
                    Radio(
                      value: 'Abnormal',
                      groupValue: _selectedPusCell,
                      onChanged: (value) {
                        setState(() {
                          _selectedPusCell = value.toString();
                        });
                      },
                    ),
                    Text('Abnormal', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
               SizedBox(height: 16.0),

              ListTile(
                title: Text('Pus Cell Clumps', style: TextStyle(fontWeight: FontWeight.bold,color:  Colors.black)),
                subtitle: Row(
                  children: [
                    Radio(
                      value: 'Present',
                      groupValue: _selectedPusCellClumps,
                      onChanged: (value) {
                        setState(() {
                          _selectedPusCellClumps = value.toString();
                        });
                      },
                    ),
                    Text('Present', style: TextStyle(color: Colors.black)),
                    Radio(
                      value: 'Not Present',
                      groupValue: _selectedPusCellClumps,
                      onChanged: (value) {
                        setState(() {
                          _selectedPusCellClumps = value.toString();
                        });
                      },
                    ),
                    Text('Not Present', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
               SizedBox(height: 16.0),

              ListTile(
                title: Text('Bacteria', style: TextStyle(fontWeight: FontWeight.bold,color:  Colors.black)),
                subtitle: Row(
                  children: [
                    Radio(
                      value: 'Present',
                      groupValue: _selectedBacteria,
                      onChanged: (value) {
                        setState(() {
                          _selectedBacteria = value.toString();
                        });
                      },
                    ),
                    Text('Present', style: TextStyle(color: Colors.black)),
                    Radio(
                      value: 'Not Present',
                      groupValue: _selectedBacteria,
                      onChanged: (value) {
                        setState(() {
                          _selectedBacteria = value.toString();
                        });
                      },
                    ),
                    Text('Not Present', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
               SizedBox(height: 16.0),

          Text(
                'NB:For Hypertension only! Select Yes if your diastolic bp is 90 or more. Otherwise, select No ',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600
                ),
               ),

              ListTile(
                title: Text('Hypertension', style: TextStyle(fontWeight: FontWeight.bold,color:  Colors.black)),
                subtitle: Row(
                  children: [
                    Radio(
                      value: 'Yes',
                      groupValue: _selectedHypertension,
                      onChanged: (value) {
                        setState(() {
                          _selectedHypertension = value.toString();
                        });
                      },
                    ),
                    Text('Yes', style: TextStyle(color: Colors.black)),
                    Radio(
                      value: 'No',
                      groupValue: _selectedHypertension,
                      onChanged: (value) {
                        setState(() {
                          _selectedHypertension = value.toString();
                        });
                      },
                    ),
                    Text('No', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
               SizedBox(height: 16.0),

              ListTile(
                title: Text('Diabetes', style: TextStyle(fontWeight: FontWeight.bold,color:  Colors.black)),
                subtitle: Row(
                  children: [
                    Radio(
                      value: 'Yes',
                      groupValue: _selectedDiabetes,
                      onChanged: (value) {
                        setState(() {
                          _selectedDiabetes = value.toString();
                        });
                      },
                    ),
                    Text('Yes', style: TextStyle(color: Colors.black)),
                    Radio(
                      value: 'No',
                      groupValue: _selectedDiabetes,
                      onChanged: (value) {
                        setState(() {
                          _selectedDiabetes = value.toString();
                        });
                      },
                    ),
                    Text('No', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
               SizedBox(height: 16.0),

               

              

              ListTile(
                title: Text('Coronary Artery Disease', style: TextStyle(fontWeight: FontWeight.bold,color:  Colors.black)),
                subtitle: Row(
                  children: [
                    Radio(
                      value: 'Yes',
                      groupValue: _selectedCoronaryArteryDisease,
                      onChanged: (value) {
                        setState(() {
                          _selectedCoronaryArteryDisease = value.toString();
                        });
                      },
                    ),
                    Text('Yes', style: TextStyle(color: Colors.black)),
                    Radio(
                      value: 'No',
                      groupValue: _selectedCoronaryArteryDisease,
                      onChanged: (value) {
                        setState(() {
                          _selectedCoronaryArteryDisease = value.toString();
                        });
                      },
                    ),
                    Text('No', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
               SizedBox(height: 16.0),
              ListTile(
                title: Text('Pedal Edema', style: TextStyle(fontWeight: FontWeight.bold,color:  Colors.black)),
                subtitle: Row(
                  children: [
                    Radio(
                      value: 'Yes',
                      groupValue: _selectedPedalEdema,
                      onChanged: (value) {
                        setState(() {
                          _selectedPedalEdema = value.toString();
                        });
                      },
                    ),
                    Text('Yes', style: TextStyle(color: Colors.black)),
                    Radio(
                      value: 'No',
                      groupValue: _selectedPedalEdema,
                      onChanged: (value) {
                        setState(() {
                          _selectedPedalEdema = value.toString();
                        });
                      },
                    ),
                    Text('No', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
               SizedBox(height: 16.0),

              ListTile(
                title: Text('Anemia', style: TextStyle(fontWeight: FontWeight.bold,color:  Colors.black)),
                subtitle: Row(
                  children: [
                    Radio(
                      value: 'Yes',
                      groupValue: _selectedAnemia,
                      onChanged: (value) {
                        setState(() {
                          _selectedAnemia = value.toString();
                        });
                      },
                    ),
                    Text('Yes', style: TextStyle(color: Colors.black)),
                    Radio(
                      value: 'No',
                      groupValue: _selectedAnemia,
                      onChanged: (value) {
                        setState(() {
                          _selectedAnemia = value.toString();
                        });
                      },
                    ),
                    Text('No', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
               SizedBox(height: 16.0),

              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 167, 60, 53)),
                ),
                onPressed: _assessStatus,
                child: Text('Assess Status'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class PredictionScreen extends StatelessWidget {
  final dynamic predictionResult;

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
          children: [
            Text(
              'Prediction Result:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Display prediction results here
            Text(
              '$predictionResult',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}