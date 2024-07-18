import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';

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

  int _encodeValue(String value) {
    switch (value) {
      case 'Yes':
      case 'Present':
      case 'Abnormal':
        return 1;
      case 'No':
      case 'Not Present':
      case 'Normal':
      default:
        return 0;
    }
  }

  

  Future<void> _assessStatus() async {
    if (!_validateInputs()) {
      return;
    }

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
      'rbc': _encodeValue(_selectedRedBloodCells),
      'pc': _encodeValue(_selectedPusCell),
      'pcc': _encodeValue(_selectedPusCellClumps),
      'ba': _encodeValue(_selectedBacteria),
      'htn': _encodeValue(_selectedHypertension),
      'dm': _encodeValue(_selectedDiabetes),
      'cad': _encodeValue(_selectedCoronaryArteryDisease),
      'pe': _encodeValue(_selectedPedalEdema),
      'ane': _encodeValue(_selectedAnemia),
    };
   

    var body = json.encode(data);
    print('Data being sent to the API: $body');

    var url = Uri.parse('https://flask-traditional-api.onrender.com/predict'); // Replace with your Flask API endpoint
  //var url = Uri.parse('https://new-api-loas.onrender.com/predict'); 
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        var predictionResult = json.decode(response.body);
        String prediction = predictionResult['Prediction'];
        String dietSuggestion = predictionResult['Diet Suggestion'];

        String formattedResult = 'Prediction: $prediction\n';
        formattedResult += 'Diet Suggestion: $dietSuggestion';

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

  bool _validateInputs() {
    if (_ageController.text.isEmpty ||
        _bloodPressureController.text.isEmpty ||
        _sgController.text.isEmpty ||
        _albuminController.text.isEmpty ||
        _suController.text.isEmpty ||
        _bgrController.text.isEmpty ||
        _bloodUreaController.text.isEmpty ||
        _serumCreatinineController.text.isEmpty ||
        _sodiumController.text.isEmpty ||
        _potassiumController.text.isEmpty ||
        _hemoglobinController.text.isEmpty ||
        _packedCellVolumeController.text.isEmpty ||
        _whiteBloodCellCountController.text.isEmpty ||
        _redBloodCellCountController.text.isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return false;
    }

    if (double.tryParse(_ageController.text) == null ||
        double.tryParse(_bloodPressureController.text) == null ||
        double.tryParse(_sgController.text) == null ||
        double.tryParse(_albuminController.text) == null ||
        double.tryParse(_suController.text) == null ||
        double.tryParse(_bgrController.text) == null ||
        double.tryParse(_bloodUreaController.text) == null ||
        double.tryParse(_serumCreatinineController.text) == null ||
        double.tryParse(_sodiumController.text) == null ||
        double.tryParse(_potassiumController.text) == null ||
        double.tryParse(_hemoglobinController.text) == null ||
        double.tryParse(_packedCellVolumeController.text) == null ||
        double.tryParse(_whiteBloodCellCountController.text) == null ||
        double.tryParse(_redBloodCellCountController.text) == null) {
      _showErrorDialog('Please enter a valid number or "." where necessary');
      return false;
    }

    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
//delete if error pops up

 Future<void> _saveAsPdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) =>
           pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Age: ${_ageController.text}'),
              pw.Text('Diastolic Blood Pressure: ${_bloodPressureController.text}'),
              pw.Text('Specific Gravity: ${_sgController.text}'),
              pw.Text('Albumin: ${_albuminController.text}'),
              pw.Text('Sugar: ${_suController.text}'),
              pw.Text('Blood Glucose Random: ${_bgrController.text}'),
              pw.Text('Blood Urea: ${_bloodUreaController.text}'),
              pw.Text('Serum Creatinine: ${_serumCreatinineController.text}'),
              pw.Text('Sodium: ${_sodiumController.text}'),
              pw.Text('Potassium: ${_potassiumController.text}'),
              pw.Text('Hemoglobin: ${_hemoglobinController.text}'),
              pw.Text('Packed Cell Volume: ${_packedCellVolumeController.text}'),
              pw.Text('White Blood Cell Count: ${_whiteBloodCellCountController.text}'),
              pw.Text('Red Blood Cell Count: ${_redBloodCellCountController.text}'),
              pw.Text('Red Blood Cells: $_selectedRedBloodCells'),
              pw.Text('Pus Cell: $_selectedPusCell'),
              pw.Text('Pus Cell Clumps: $_selectedPusCellClumps'),
              pw.Text('Bacteria: $_selectedBacteria'),
              pw.Text('Hypertension: $_selectedHypertension'),
              pw.Text('Diabetes: $_selectedDiabetes'),
              pw.Text('Coronary Artery Disease: $_selectedCoronaryArteryDisease'),
              pw.Text('Pedal Edema: $_selectedPedalEdema'),
              pw.Text('Anemia: $_selectedAnemia'),
            ],
          ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/medical information.pdf');
    await file.writeAsBytes(await pdf.save());

    Printing.sharePdf(bytes: await pdf.save(), filename: 'medical information.pdf');
  }

   


  @override
  void dispose() {
    _ageController.dispose();
    _bloodPressureController.dispose();
    _sgController.dispose();
    _albuminController.dispose();
    _suController.dispose();
    _bgrController.dispose();
    _bloodUreaController.dispose();
    _serumCreatinineController.dispose();
    _sodiumController.dispose();
    _potassiumController.dispose();
    _hemoglobinController.dispose();
    _packedCellVolumeController.dispose();
    _whiteBloodCellCountController.dispose();
    _redBloodCellCountController.dispose();
    super.dispose();
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
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveAsPdf,
          ),
        ],
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

  PredictionScreen({required this.predictionResult});

  @override
  Widget build(BuildContext context) {
    String prediction = predictionResult['Prediction'];
    String dietSuggestion = predictionResult['Diet Suggestion'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction Result'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _createPdfAndSave(context, prediction, dietSuggestion);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 8, 71, 144), Color.fromARGB(172, 5, 63, 111)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Prediction',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  prediction,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Diet Suggestion',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  dietSuggestion,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createPdfAndSave(BuildContext context, String prediction, String dietSuggestion) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Prediction', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text(prediction, style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 16),
              pw.Text('Diet Suggestion', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text(dietSuggestion, style: pw.TextStyle(fontSize: 18)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}