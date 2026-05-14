import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../constants.dart';

class PatientFeedbackScreen extends StatefulWidget {
  const PatientFeedbackScreen({Key? key}) : super(key: key);

  @override
  _PatientFeedbackScreenState createState() => _PatientFeedbackScreenState();
}

class _PatientFeedbackScreenState extends State<PatientFeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  double _rating = 0;
  bool _liked = true;
  bool _isSubmitting = false;
  String? _doctorName;
  String? _doctorId;

  @override
  void initState() {
    super.initState();
    _fetchLastDoctor();
  }

  Future<void> _fetchLastDoctor() async {
    try {
      final databaseRef = FirebaseDatabase.instance.ref('Requests');
      final query = databaseRef.orderByChild('sender').equalTo(Constants.pid);

      final snapshot = await query.once();
      if (snapshot.snapshot.exists) {
        final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
        final appointment = data.values.first;
        setState(() {
          _doctorName = appointment['doc'] ?? 'Your Doctor';
          _doctorId = appointment['did'];
        });
      }
    } catch (e) {
      debugPrint('Error fetching last doctor: $e');
    }
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || _doctorId == null) {
        throw Exception('User or doctor information not available');
      }

      final databaseRef = FirebaseDatabase.instance.ref('feedback');
      final newFeedbackRef = databaseRef.child(_doctorId!).push();

      await newFeedbackRef.set({
        'doctorId': _doctorId,
        'feedback': _feedbackController.text,
        'liked': _liked,
        'patientId': Constants.pid,
        'pname': Constants.name ?? 'Anonymous',
        'rating': _rating.round(),
        'timestamp': ServerValue.timestamp,
      });

      if (_liked == true || _rating > 4) {
        DatabaseReference ref1 = FirebaseDatabase.instance.ref("patients");
        Query query = ref1.orderByChild("name").equalTo(_doctorName);

        query.once().then((DatabaseEvent event) {
          if (event.snapshot.exists) {
            Map<dynamic, dynamic> data =
                event.snapshot.value as Map<dynamic, dynamic>;
            data.forEach((key, value) {
              DatabaseReference satisfiedRef =
                  ref1.child(key).child("satisfied");

              satisfiedRef.once().then((DatabaseEvent snap) {
                if (snap.snapshot.exists) {
                  int currentValue = int.parse(snap.snapshot.value.toString());
                  satisfiedRef.set(currentValue + 1);
                } else {
                  satisfiedRef.set(1);
                }
              });
            });
          }
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Thank you for your feedback!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.deepOrangeAccent,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Feedback',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor Profile Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepOrangeAccent.withOpacity(0.1),
                        ),
                        child: Icon(Icons.person,
                            size: 30, color: Colors.deepOrangeAccent),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _doctorName ?? 'Your Recent Doctor',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'We value your honest feedback',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Rating Section
                const Text(
                  'How would you rate your experience?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.deepOrangeAccent,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    _rating == 0
                        ? 'Tap to rate'
                        : '${_rating.toStringAsFixed(1)} Stars',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Feedback Section
                const Text(
                  'Share your thoughts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _feedbackController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'What went well? What could be improved?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1.5,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(fontSize: 15),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide your feedback';
                    }
                    if (value.length < 10) {
                      return 'Please provide more detailed feedback';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Overall Impression
                const Text(
                  'Overall impression',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _liked = true),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: _liked
                                ? Colors.deepOrangeAccent
                                : Colors.grey[300]!,
                            width: _liked ? 1.5 : 1,
                          ),
                          backgroundColor: _liked
                              ? Colors.deepOrangeAccent.withOpacity(0.1)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.thumb_up,
                                color: _liked
                                    ? Colors.deepOrangeAccent
                                    : Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              'Positive',
                              style: TextStyle(
                                color: _liked
                                    ? Colors.deepOrangeAccent
                                    : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _liked = false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color:
                                !_liked ? Colors.deepOrange : Colors.grey[300]!,
                            width: !_liked ? 1.5 : 1,
                          ),
                          backgroundColor: !_liked
                              ? Colors.deepOrange.withOpacity(0.1)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.thumb_down,
                                color:
                                    !_liked ? Colors.deepOrange : Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              'Negative',
                              style: TextStyle(
                                color:
                                    !_liked ? Colors.deepOrange : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'SUBMIT FEEDBACK',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
