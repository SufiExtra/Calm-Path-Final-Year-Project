import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AdminFeedbackScreen extends StatefulWidget {
  const AdminFeedbackScreen({super.key});

  @override
  State<AdminFeedbackScreen> createState() => _AdminFeedbackScreenState();
}

class _AdminFeedbackScreenState extends State<AdminFeedbackScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  bool _isLoading = true;
  String _searchQuery = '';
  List<Map<String, dynamic>> _allFeedbacks = [];

  @override
  void initState() {
    super.initState();
    _fetchAllFeedbacks();
  }

  Future<void> _fetchAllFeedbacks() async {
    try {
      DatabaseEvent event = await _databaseRef.child('feedback').once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        Map<dynamic, dynamic> usersMap =
            snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> allFeedbacks = [];

        usersMap.forEach((userId, userFeedbacks) {
          if (userFeedbacks is Map) {
            userFeedbacks.forEach((feedbackId, feedbackData) {
              if (feedbackData is Map) {
                allFeedbacks.add({
                  'userId': userId,
                  'feedbackId': feedbackId,
                  ...Map<String, dynamic>.from(feedbackData),
                });
              }
            });
          }
        });

        setState(() {
          _allFeedbacks = allFeedbacks;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Error fetching feedbacks: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _deleteFeedback(String userId, String feedbackId) async {
    try {
      await _databaseRef.child('feedback/$userId/$feedbackId').remove();
      setState(() {
        _allFeedbacks.removeWhere((feedback) =>
            feedback['userId'] == userId &&
            feedback['feedbackId'] == feedbackId);
      });
      _showSuccess('Feedback deleted successfully');
    } catch (e) {
      _showError('Error deleting feedback: $e');
    }
  }

  void _showFeedbackDetails(Map<String, dynamic> feedback) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Feedback Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Patient Name', feedback['pname'] ?? 'N/A'),
              _buildDetailRow('Feedback', feedback['feedback'] ?? 'N/A'),
              _buildDetailRow(
                  'Rating', feedback['rating']?.toString() ?? 'N/A'),
              _buildDetailRow('Liked', feedback['liked']?.toString() ?? 'N/A'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showDeleteConfirmation(
                  feedback['userId'], feedback['feedbackId']);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String userId, String feedbackId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this feedback?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteFeedback(userId, feedbackId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackItem(Map<String, dynamic> feedback) {
    return Card(
      color: Colors.white,
      elevation: 10,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showFeedbackDetails(feedback),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      feedback['pname'] ?? 'Unknown Patient',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Chip(
                    backgroundColor: Colors.orange[50],
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          feedback['rating']?.toString() ?? '0',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                feedback['feedback'] ?? 'No feedback text',
                style: const TextStyle(color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: feedback['liked'] == true
                          ? Colors.green[50]
                          : Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          feedback['liked'] == true
                              ? Icons.thumb_up
                              : Icons.thumb_down,
                          color: feedback['liked'] == true
                              ? Colors.green
                              : Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          feedback['liked'] == true ? 'Liked' : 'Disliked',
                          style: TextStyle(
                            color: feedback['liked'] == true
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredFeedbacks() {
    if (_searchQuery.isEmpty) {
      return _allFeedbacks;
    }
    return _allFeedbacks.where((feedback) {
      final patientName = feedback['pname']?.toString().toLowerCase() ?? '';
      final feedbackText = feedback['feedback']?.toString().toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return patientName.contains(query) || feedbackText.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text(
          "Feedbacks",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          size: 30,
          color: Colors.white,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _allFeedbacks.isEmpty
              ? const Center(
                  child: Text(
                    'No feedbacks available',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by patient name or feedback',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _fetchAllFeedbacks,
                        child: ListView.builder(
                          itemCount: _getFilteredFeedbacks().length,
                          itemBuilder: (context, index) => _buildFeedbackItem(
                              _getFilteredFeedbacks()[index]),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
