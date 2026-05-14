import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mind_guide_ui/admin/admin_add_psychiatrist.dart';
import 'package:mind_guide_ui/common/notification_screen.dart';

import '../constants.dart';
import '../login_screen.dart';
import 'model/booking.dart';

class DoctorRequestsPage extends StatefulWidget {
  const DoctorRequestsPage({super.key});

  @override
  State<DoctorRequestsPage> createState() => _DoctorRequestsPageState();
}

class _DoctorRequestsPageState extends State<DoctorRequestsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _requestDatabase =
      FirebaseDatabase.instance.ref('Requests');
  List<Booking> _bookings = [];
  bool _isLoading = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _refreshData(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _refreshData() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _fetchBookings() async {
    String? currentUserId = _auth.currentUser?.uid;
    if (currentUserId != null) {
      await _requestDatabase
          .orderByChild('receiver')
          .equalTo(currentUserId)
          .once()
          .then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> bookingMap =
              event.snapshot.value as Map<dynamic, dynamic>;
          _bookings.clear();
          bookingMap.forEach((key, value) {
            _bookings.add(Booking.fromMap(Map<String, dynamic>.from(value)));
          });
        }
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Appointment Requests',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      width: 290,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Image.asset(
                    "images/profile.gif",
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.deepOrangeAccent,
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.deepOrangeAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminAddPsychiatrist(),
                        ),
                      );
                    },
                    child: const Text("Edit profile"),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.deepOrangeAccent),
            _buildDrawerItem(
              title: "Notifications",
              icon: Icons.notifications,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              title: "Logout",
              icon: Icons.logout,
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrangeAccent),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.deepOrangeAccent));
    }
    if (_bookings.isEmpty) {
      return const Center(child: Text('No appointment requests available'));
    }
    return ListView.builder(
      itemCount: _bookings.length,
      itemBuilder: (context, index) {
        final booking = _bookings[index];
        return _buildBookingCard(booking, index);
      },
    );
  }

  Widget _buildBookingCard(Booking booking, int index) {
    return Card(
      color: Colors.white,
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () => _showAppointmentDetails(booking, index),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Image.asset("images/profile.gif", height: 60, width: 60),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      booking.number,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      booking.date,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Status: ${booking.status}",
                      style: TextStyle(
                        color: _getStatusColor(booking.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (booking.paymentStatus != null)
                      Text(
                        "Payment: ${booking.paymentStatus!.toUpperCase()}",
                        style: TextStyle(
                          color: _getPaymentStatusColor(booking.paymentStatus),
                        ),
                      ),
                  ],
                ),
              ),
              Image.asset("images/update.gif", height: 60, width: 60),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  Color _getPaymentStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'verified':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showAppointmentDetails(Booking booking, int index) {
    String selectedStatus = booking.status;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Appointment Details'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDetailTile(Icons.person, 'Patient', booking.name),
                    _buildDetailTile(Icons.phone, 'Contact', booking.number),
                    _buildDetailTile(
                        Icons.email, 'Email', booking.demail ?? 'N/A'),
                    _buildDetailTile(
                        Icons.calendar_today, 'Date', booking.date),
                    _buildDetailTile(Icons.access_time, 'Time', booking.time),
                    const Divider(),
                    _buildDetailTile(Icons.payment, 'Payment Method',
                        booking.paymentMethod ?? 'Not specified'),
                    _buildDetailTile(Icons.attach_money, 'Amount',
                        'Rs ${booking.paymentAmount ?? '0'}'),
                    _buildDetailTile(Icons.verified, 'Payment Status',
                        booking.paymentStatus?.toUpperCase() ?? 'PENDING'),
                    if (booking.receiptUrl != null &&
                        booking.receiptUrl!.isNotEmpty) ...[
                      const Divider(),
                      const ListTile(
                        leading: Icon(Icons.receipt),
                        title: Text('Payment Receipt'),
                      ),
                      GestureDetector(
                        onTap: () =>
                            _showFullScreenReceipt(booking.receiptUrl!),
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image(
                            image: NetworkImage(booking.receiptUrl!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Tap receipt to view full size',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                    const Divider(),
                    const Text('Update Status:'),
                    Column(
                      children:
                          ['Accepted', 'Rejected', 'Completed'].map((status) {
                        return RadioListTile<String>(
                          title: Text(status),
                          value: status,
                          groupValue: selectedStatus,
                          onChanged: (value) =>
                              setState(() => selectedStatus = value!),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                  ),
                  onPressed: () async {
                    await _updateAppointmentStatus(
                        booking.id.toString(), selectedStatus, index);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Update Status',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  ListTile _buildDetailTile(IconData icon, String title, String subtitle) {
    return ListTile(
      tileColor: Colors.white,
      leading: Icon(icon, size: 20),
      title: Text(title),
      subtitle: Text(subtitle),
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 20,
    );
  }

  void _showFullScreenReceipt(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Colors.white,
              size: 30,
            ),
            title: const Text(
              'Payment Receipt',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.deepOrangeAccent,
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 3.0,
              child: Image(
                image: NetworkImage(imageUrl),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateAppointmentStatus(
      String requestId, String status, int index) async {
    try {
      int parsedRequestId = int.tryParse(requestId) ?? 0;
      DatabaseEvent event = await _requestDatabase
          .orderByChild("id")
          .equalTo(parsedRequestId)
          .once();

      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) async {
          if (status == "Completed" || status == "Rejected") {
            await _sendNotification(index, status);
            await _requestDatabase.child(key).remove();
            _bookings.removeAt(index);
          } else {
            await _requestDatabase.child(key).update({'status': status});
            _bookings[index].status = status;
          }
          setState(() {});
        });
      }
      await _fetchBookings();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: ${e.toString()}')),
      );
    }
  }

  Future<void> _sendNotification(int index, String status) async {
    DatabaseReference notificationsRef =
        FirebaseDatabase.instance.ref("Notifications");
    String action = status == "Completed" ? "completed" : "canceled";

    // Notification to patient
    await notificationsRef.child(_bookings[index].sender).push().set({
      'senderId': _auth.currentUser!.uid,
      'receiverId': _bookings[index].sender,
      'content': 'Dr. ${Constants.name} has $action your appointment',
      'timestamp': ServerValue.timestamp,
      'read': false,
    });

    // Notification to doctor
    await notificationsRef.child(_auth.currentUser!.uid).push().set({
      'senderId': _bookings[index].sender,
      'receiverId': _auth.currentUser!.uid,
      'content': 'You $action appointment with ${_bookings[index].name}',
      'timestamp': ServerValue.timestamp,
      'read': false,
    });
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
