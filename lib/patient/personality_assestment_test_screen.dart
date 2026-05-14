import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PersonalityAssestmentTestScreen extends StatefulWidget {
  const PersonalityAssestmentTestScreen({super.key});

  @override
  State<PersonalityAssestmentTestScreen> createState() =>
      _PersonalityAssestmentTestScreenState();
}

class _PersonalityAssestmentTestScreenState
    extends State<PersonalityAssestmentTestScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedGender;
  final _ageController = TextEditingController();

  double _openness = 4;
  double _neuroticism = 4;
  double _conscientiousness = 4;
  double _agreeableness = 4;
  double _extraversion = 4;

  final List<String> _genderOptions = ['Male', 'Female'];

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
            child: CircularProgressIndicator(
          color: Colors.deepOrangeAccent,
        )),
      );

      DatabaseReference ref = FirebaseDatabase.instance.ref("machine");
      String? ipp;

      try {
        final snapshot = await ref.get();
        if (snapshot.exists) {
          Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
          ipp = data['ip']?.toString();
        } else {
          Navigator.of(context).pop();
          showErrorDialog("Server configuration not found");
          return;
        }

        if (ipp == null || ipp.isEmpty) {
          Navigator.of(context).pop();
          showErrorDialog("Invalid server address");
          return;
        }

        final apiUrl = Uri.parse(
            'https://maaz-909634561428.us-central1.run.app/predict/personality');

        final response = await http.post(
          apiUrl,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "Gender": _selectedGender,
            "Age": int.parse(_ageController.text),
            "Openness": _openness.round(),
            "Neuroticism": _neuroticism.round(),
            "Conscientiousness": _conscientiousness.round(),
            "Agreeableness": _agreeableness.round(),
            "Extraversion": _extraversion.round(),
          }),
        );

        Navigator.of(context).pop();

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          final personality =
              result['Predicted Personality'] ?? result['prediction'];
          if (personality == null) {
            showErrorDialog("Invalid response format from server");
            return;
          }

          FirebaseAuth auth = FirebaseAuth.instance;
          DatabaseReference ref = FirebaseDatabase.instance
              .ref('personality')
              .child(auth.currentUser!.uid);

          Map<String, dynamic> results = {
            "Gender": _selectedGender,
            "Age": int.parse(_ageController.text),
            "Openness": _openness.round(),
            "Neuroticism": _neuroticism.round(),
            "Conscientiousness": _conscientiousness.round(),
            "Agreeableness": _agreeableness.round(),
            "Extraversion": _extraversion.round(),
            "Result": personality,
            "timestamp": ServerValue.timestamp,
          };

          await ref.push().set(results);

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Predicted Personality'),
              content: Text('You are most likely: $personality'),
              actions: [
                TextButton(
                  onPressed: (){ Navigator.pop(context);Navigator.pop(context);},
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          throw Exception('Failed to get prediction: ${response.statusCode}');
        }
      } catch (e) {
        Navigator.of(context).pop();
        showErrorDialog("Something went wrong: $e");
      }
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () { Navigator.pop(context);Navigator.pop(context);},
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    final numValue = int.tryParse(value);
    if (numValue == null) {
      return 'Please enter a valid number';
    }
    if (numValue < 13) {
      return 'Age must be greater than 12';
    }
    if (numValue > 99) {
      return 'Age must be less than 99';
    }
    return null;
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required Function(double) onChanged,
    bool invertColor = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Slider(
          value: value,
          onChanged: onChanged,
          min: 1,
          max: 7,
          divisions: 6,
          label: value.round().toString(),
          activeColor: getSliderColor(value, invert: invertColor),
          inactiveColor:
          getSliderColor(value, invert: invertColor).withOpacity(0.3),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Selected: ${value.round()}',
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Color getSliderColor(double value, {bool invert = false}) {
    if (invert) {
      if (value >= 6) return Colors.red;
      if (value >= 3) return Colors.amber;
      return Colors.green;
    } else {
      if (value >= 6) return Colors.green;
      if (value >= 3) return Colors.amber;
      return Colors.red;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        title: const Text(
          'Personality Assessment Test',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        iconTheme: const IconThemeData(size: 30, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'What is your gender?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: _selectedGender,
                items: _genderOptions.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select your gender' : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'What is your age?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: _validateAge,
              ),
              const SizedBox(height: 16),
              _buildSlider(
                label:
                    'How curious and open are you to new experiences and ideas?',
                value: _openness,
                onChanged: (val) => setState(() => _openness = val),
              ),
              _buildSlider(
                label: 'How often do you feel anxious, worried, or easily upset?',
                value: _neuroticism,
                onChanged: (val) => setState(() => _neuroticism = val),
                invertColor: true, // <-- only here!
              ),
              _buildSlider(
                label: 'How organized and responsible are you?',
                value: _conscientiousness,
                onChanged: (val) => setState(() => _conscientiousness = val),
              ),
              _buildSlider(
                label: 'How kind and cooperative are you with others?',
                value: _agreeableness,
                onChanged: (val) => setState(() => _agreeableness = val),
              ),
              _buildSlider(
                label:
                    'How much do you enjoy social gatherings and meeting new people?',
                value: _extraversion,
                onChanged: (val) => setState(() => _extraversion = val),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _submitForm,
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
