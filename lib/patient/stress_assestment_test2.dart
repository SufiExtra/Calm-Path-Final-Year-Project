import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StressLevelForm extends StatefulWidget {
  @override
  _StressLevelFormState createState() => _StressLevelFormState();
}

class _StressLevelFormState extends State<StressLevelForm> {
  final _formKey = GlobalKey<FormState>();
  late String apiUrl;

  // Form fields with default values matching the model's expected range
  Map<String, dynamic> formData = {
    'anxiety_level': 0,
    'self_esteem': 0,
    'mental_health_history': 0,
    'depression': 0,
    'headache': 0,
    'blood_pressure': 1, // Starts at 1 as per model range
    'sleep_quality': 1, // Starts at 1 as per model range
    'breathing_problem': 0,
    'noise_level': 0,
    'living_conditions': 1, // Starts at 1 as per model range
    'safety': 1, // Starts at 1 as per model range
    'basic_needs': 1, // Starts at 1 as per model range
    'academic_performance': 0,
    'study_load': 0,
    'teacher_student_relationship': 0,
    'future_career_concerns': 0,
    'social_support': 0,
    'peer_pressure': 0,
    'extracurricular_activities': 0,
    'bullying': 0,
  };

  bool isLoading = false;
  Map<String, dynamic>? predictionResult;

  @override
  void initState() {
    super.initState();
    getIP();
  }

  Future<void> predictStressLevel() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
        predictionResult = null;
      });

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(formData),
        );

        if (response.statusCode == 200) {
          setState(() {
            predictionResult = json.decode(response.body);
          });
        } else {
          throw Exception('Failed to get prediction: ${response.statusCode}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _buildSliderField(String label, String fieldName, int max, int min,
      {bool reverseColors = false}) {
    return Card(
      color: Colors.white,
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.deepOrangeAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Current value: ${formData[fieldName]}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Slider(
              value: formData[fieldName].toDouble(),
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: max - min,
              label: formData[fieldName].toString(),
              onChanged: (value) {
                setState(() {
                  formData[fieldName] = value.toInt();
                });
              },
              activeColor: _getSliderColor(fieldName, formData[fieldName], max,
                  reverseColors: reverseColors),
              inactiveColor: _getSliderColor(
                      fieldName, formData[fieldName], max,
                      reverseColors: reverseColors)
                  .withOpacity(0.3),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$min', style: TextStyle(fontSize: 12)),
                Text('$max', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBinaryField(String label, String fieldName) {
    return Card(
      color: Colors.white,
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.deepOrangeAccent,
              ),
            ),
            SizedBox(height: 10),
            ToggleButtons(
              isSelected: [
                formData[fieldName] == 0,
                formData[fieldName] == 1,
              ],
              onPressed: (int index) {
                setState(() {
                  formData[fieldName] = index;
                });
              },
              color: Colors.grey,
              selectedColor: Colors.white,
              fillColor: Colors.deepOrangeAccent,
              borderRadius: BorderRadius.circular(8),
              constraints: BoxConstraints(
                minHeight: 40,
                minWidth: MediaQuery.of(context).size.width * 0.424,
              ),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('No', style: TextStyle(fontSize: 14)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Yes', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getSliderColor(String fieldName, int value, int max,
      {bool reverseColors = false}) {
    double normalizedValue = value / max;

    // Special cases for specific fields where 0 is bad and max is good
    if (fieldName.contains('teacher_student_relationship') ||
        fieldName.contains('academic_performance') ||
        fieldName.contains('extracurricular_activities') ||
        reverseColors) {
      return normalizedValue > 0.66
          ? Colors.green
          : normalizedValue > 0.33
              ? Colors.orange
              : Colors.red;
    }
    // For positive factors (higher is better)
    else if (fieldName.contains('esteem') ||
        fieldName.contains('sleep_quality') ||
        fieldName.contains('living_conditions') ||
        fieldName.contains('safety') ||
        fieldName.contains('basic_needs') ||
        fieldName.contains('social_support')) {
      return normalizedValue > 0.66
          ? Colors.green
          : normalizedValue > 0.33
              ? Colors.orange
              : Colors.red;
    } else {
      // For negative factors (higher is worse)
      return normalizedValue > 0.66
          ? Colors.red
          : normalizedValue > 0.33
              ? Colors.orange
              : Colors.green;
    }
  }

  Future<void> getIP() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("machine");
    String? ipp;

    try {
      final snapshot = await ref.get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        if (data.containsKey('ip')) {
          ipp = data['ip'];
        }
      }
    } catch (e) {
      print("Error fetching IP: $e");
    }

    setState(() {
      apiUrl = ipp != null
          ? 'https://maaz-909634561428.us-central1.run.app/predict/stress'
          : 'http://10.0.2.2:5000/predict/stress'; // Default to Android emulator address
    });
  }

  Widget _buildResultCard() {
    if (predictionResult == null) return SizedBox();

    int level = predictionResult!['stress_level'];
    String description = predictionResult!['stress_description'];
    Color color = _getStressColor(level);

    return Card(
      color: Colors.white,
      elevation: 10,
      margin: EdgeInsets.symmetric(vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'STRESS ASSESSMENT RESULT',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    description.toUpperCase(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Level: $level',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: (level + 1) / 3,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 15,
              borderRadius: BorderRadius.circular(10),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Low', style: TextStyle(color: Colors.green)),
                Text('Medium', style: TextStyle(color: Colors.orange)),
                Text('High', style: TextStyle(color: Colors.red)),
              ],
            ),
            SizedBox(height: 15),
            if (level > 0)
              Text(
                _getRecommendation(level),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getRecommendation(int level) {
    if (level == 1) {
      return 'Consider practicing relaxation techniques and maintaining a healthy work-life balance.';
    } else if (level == 2) {
      return 'Your stress levels are high. Please consider seeking professional help or talking to someone you trust.';
    }
    return 'You seem to be managing stress well. Keep up the good habits!';
  }

  Color _getStressColor(int level) {
    switch (level) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stress Level Assessment',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Personal Factors
              _buildSectionHeader('Personal Factors'),
              _buildSliderField('Anxiety Level (0-21)', 'anxiety_level', 21, 0),
              _buildSliderField('Self Esteem (0-30)', 'self_esteem', 30, 0,
                  reverseColors: true),
              _buildBinaryField(
                  'Mental Health History', 'mental_health_history'),
              _buildSliderField('Depression Level (0-27)', 'depression', 27, 0),

              // Physical Health
              _buildSectionHeader('Physical Health'),
              _buildSliderField('Headache Frequency (0-5)', 'headache', 5, 0),
              _buildBloodPressureField(),
              _buildSliderField('Sleep Quality (1-5)', 'sleep_quality', 5, 1,
                  reverseColors: true),
              _buildSliderField(
                  'Breathing Problems (0-5)', 'breathing_problem', 5, 0),

              // Environmental Factors
              _buildSectionHeader('Environmental Factors'),
              _buildSliderField('Noise Level (0-5)', 'noise_level', 5, 0),
              _buildSliderField(
                  'Living Conditions (1-5)', 'living_conditions', 5, 1,
                  reverseColors: true),
              _buildSliderField('Safety (1-5)', 'safety', 5, 1,
                  reverseColors: true),
              _buildSliderField('Basic Needs Met (1-5)', 'basic_needs', 5, 1,
                  reverseColors: true),

              // Academic Factors
              _buildSectionHeader('Academic Factors'),
              _buildSliderField(
                  'Academic Performance (0-5)', 'academic_performance', 5, 0,
                  reverseColors: true),
              _buildSliderField('Study Load (0-5)', 'study_load', 5, 0),
              _buildSliderField('Teacher-Student Relationship (0-5)',
                  'teacher_student_relationship', 5, 0,
                  reverseColors: true),
              _buildSliderField('Future Career Concerns (0-5)',
                  'future_career_concerns', 5, 0),

              // Social Factors
              _buildSectionHeader('Social Factors'),
              _buildSliderField('Social Support (0-5)', 'social_support', 5, 0,
                  reverseColors: true),
              _buildSliderField('Peer Pressure (0-5)', 'peer_pressure', 5, 0),
              _buildSliderField('Extracurricular Activities (0-5)',
                  'extracurricular_activities', 5, 0,
                  reverseColors: true),
              _buildSliderField('Bullying (0-5)', 'bullying', 5, 0),

              SizedBox(height: 20),
              if (isLoading)
                Column(
                  children: [
                    CircularProgressIndicator(color: Colors.deepOrangeAccent),
                    SizedBox(height: 10),
                    Text('Analyzing your responses...'),
                  ],
                )
              else
                ElevatedButton(
                  onPressed: predictStressLevel,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'ASSESS MY STRESS LEVEL',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 50),
                    elevation: 3,
                    shadowColor: Colors.deepOrangeAccent.withOpacity(0.5),
                  ),
                ),

              _buildResultCard(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBloodPressureField() {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Blood Pressure',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.deepOrangeAccent,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPressureButton(1, 'Low', Colors.green),
                _buildPressureButton(2, 'Normal', Colors.orange),
                _buildPressureButton(3, 'High', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPressureButton(int value, String label, Color color) {
    bool isSelected = formData['blood_pressure'] == value;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          formData['blood_pressure'] = value;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? color : color,
        foregroundColor: isSelected ? Colors.white : color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color, width: 1),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20, bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.deepOrangeAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.deepOrangeAccent.withOpacity(0.3)),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepOrangeAccent,
        ),
      ),
    );
  }
}
