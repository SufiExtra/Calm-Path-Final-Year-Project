import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mind_guide_ui/constants.dart';
import 'package:mind_guide_ui/patient_main_screen.dart';
import 'package:mind_guide_ui/patient_search_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

class PatientSelectPaymentMethodScreen extends StatefulWidget {
  final psychiatrist doc;
  final String name;
  final String month;
  final String date;
  final String time;
  final String fees;
  final int index;

  const PatientSelectPaymentMethodScreen({
    super.key,
    required this.name,
    required this.fees,
    required this.time,
    required this.date,
    required this.month,
    required this.index,
    required this.doc,
  });

  @override
  State<PatientSelectPaymentMethodScreen> createState() =>
      _PatientSelectPaymentMethodScreenState();
}

class _PatientSelectPaymentMethodScreenState
    extends State<PatientSelectPaymentMethodScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final DatabaseReference ref = FirebaseDatabase.instance.ref("Requests");
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? _receiptUrl;
  File? _receiptImage;
  bool _isUploading = false;
  bool _paymentVerified = false;
  int _paymentMethod = 1; // 1 = JazzCash, 2 = EasyPaisa

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text(
          "Select Payment Method",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.deepOrangeAccent.withOpacity(0.1),
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Payment Method Selection
              Column(
                children: [
                  // Coupon Code Section
                  _buildCouponSection(size),
                  SizedBox(height: 20),
                  // Payment Methods
                  _buildPaymentMethodsSection(size),
                ],
              ),
              // Payment Confirmation Section
              _buildPaymentConfirmationSection(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCouponSection(Size size) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Have a coupon/promo code?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: size.width * 0.64,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter Discount code here",
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.25,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text("Apply"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSection(Size size) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      color: Colors.white,
      child: Column(
        children: [
          // JazzCash Option
          _buildPaymentOption(
            image: "images/jazzcash.png",
            title: "JazzCash Mobile Wallet",
            value: 1,
          ),
          SizedBox(height: 10),
          // EasyPaisa Option
          _buildPaymentOption(
            image: "images/easypaisa.png",
            title: "EasyPaisa Mobile Wallet",
            value: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String image,
    required String title,
    required int value,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Image.asset(
                  image,
                  height: 40,
                  width: 80,
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Radio<int>(
            value: value,
            groupValue: _paymentMethod,
            onChanged: (value) {
              setState(() => _paymentMethod = value!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentConfirmationSection(Size size) {
    return Container(
      height: _paymentVerified == true ? size.height * 0.525 : null,
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Appointment Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.height * 0.02,
                    ),
                  ),
                  Text(
                    "${widget.month} ${widget.date}, ${widget.time} PM",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.height * 0.017,
                    ),
                  ),
                ],
              ),
              Text(
                "Rs ${widget.fees}",
                style: TextStyle(
                  fontSize: size.height * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Payment Instructions (only shown before verification)
          if (!_paymentVerified) ...[
            const Text(
              "Please send payment to:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Account: ${widget.doc.name}"),
            Text("Number: ${widget.doc.number ?? 'Not provided'}"),
            Text(
              "Account Type: ${_paymentMethod == 1 ? 'JazzCash' : 'EasyPaisa'}",
            ),
            SizedBox(height: 20),
            const Text(
              "Upload payment receipt below:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Receipt Upload Section
            _receiptImage == null
                ? ElevatedButton(
                    onPressed: _pickReceiptImage,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent),
                    child: const Text(
                      "Select Receipt",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Column(
                    children: [
                      Image.file(_receiptImage!, height: 100),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _pickReceiptImage,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white),
                            child: const Text("Change"),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrangeAccent,
                                foregroundColor: Colors.white),
                            onPressed: _uploadReceipt,
                            child: _isUploading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text("Upload"),
                          ),
                        ],
                      ),
                    ],
                  ),
            SizedBox(height: 20),
          ],

          // Pay Now Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _paymentVerified ? _confirmBooking : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _paymentVerified ? Colors.deepOrangeAccent : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(_paymentVerified ? "Confirm Booking" : "Pay Now"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickReceiptImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _receiptImage = File(pickedFile.path));
    }
  }

  Future<void> _uploadReceipt() async {
    if (_receiptImage == null) return;

    setState(() => _isUploading = true);
    const String cloudName =
        "dolvoltit"; // Replace with your Cloudinary cloud name
    const String apiKey =
        "148232698674769"; // Replace with your Cloudinary API key
    const String apiSecret =
        "V8OE85T_W70IbcBtl1bBO7Borwc"; // Replace with your Cloudinary API secret

    try {
      if (_receiptImage != null) {
        final cloudinary = Cloudinary.signedConfig(
          apiKey: apiKey,
          apiSecret: apiSecret,
          cloudName: cloudName,
        );
        var response = await cloudinary.upload(
          file: _receiptImage!.path,
          // fileBytes: pickedFile!.readAsBytes(),
          resourceType: CloudinaryResourceType.auto,
          folder: "images",
          fileName: DateTime.now().microsecond.toString(),
        );
        _receiptUrl = response.secureUrl;
      }

      // Simulate payment verification
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _paymentVerified = true;
        _isUploading = false;
      });

      Fluttertoast.showToast(msg: "Payment verified successfully!");
    } catch (e) {
      setState(() => _isUploading = false);
      Fluttertoast.showToast(
        msg: "Error uploading receipt: ${e.toString()}",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _confirmBooking() async {
    try {
      // Upload receipt if exists
      // String? receiptUrl;
      // const String cloudName =
      //     "dolvoltit"; // Replace with your Cloudinary cloud name
      // const String apiKey =
      //     "148232698674769"; // Replace with your Cloudinary API key
      // const String apiSecret =
      //     "V8OE85T_W70IbcBtl1bBO7Borwc"; // Replace with your Cloudinary API secret
      //
      // if (_receiptImage != null) {
      //   final cloudinary = Cloudinary.signedConfig(
      //     apiKey: apiKey,
      //     apiSecret: apiSecret,
      //     cloudName: cloudName,
      //   );
      //   var response = await cloudinary.upload(
      //     file: _receiptImage!.path,
      //     // fileBytes: pickedFile!.readAsBytes(),
      //     resourceType: CloudinaryResourceType.auto,
      //     folder: "images",
      //     fileName: DateTime.now().microsecond.toString(),
      //   );
      //   receiptUrl = response.secureUrl;
      // }

      // Create booking record
      final bookingData = {
        "id": DateTime.now().microsecondsSinceEpoch,
        "sender": auth.currentUser!.uid,
        "receiver": widget.doc.uid,
        "status": 'pending',
        "date": "${widget.month} ${widget.date}, ${widget.time} PM",
        "time": "${DateTime.now().hour}:${DateTime.now().minute}",
        "name": Constants.name,
        "email": Constants.email,
        "number": Constants.number,
        "doc": widget.doc.name,
        "degree": widget.doc.degree,
        "specs": widget.doc.specialization,
        "did": widget.doc.uid,
        "demail": widget.doc.email,
        "disease": widget.doc.disease,
        "place": widget.doc.place,
        "experience": widget.doc.experience,
        "img": widget.doc.img,
        "payment_status": _paymentVerified ? "verified" : "pending",
        "payment_method": _paymentMethod == 1 ? "jazzcash" : "easypaisa",
        "receipt_url": _receiptUrl ?? "",
        "payment_amount": widget.fees,
        "timestamp": ServerValue.timestamp,
        "user": Constants.forSearch,
      };

      // Save to database
      await ref.push().set(bookingData);

      // Add to chat list
      await FirebaseDatabase.instance
          .ref("ChatList")
          .child(widget.doc.uid!)
          .child(auth.currentUser!.uid)
          .set({"id": auth.currentUser!.uid});

      // Send notifications
      await _sendNotifications();

      // Show success message
      Fluttertoast.showToast(msg: "Booking confirmed successfully!");

      // Navigate to home
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => PatientMainScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error confirming booking: ${e.toString()}",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _sendNotifications() async {
    // Local notification
    await _showNotification(
      'Appointment Booked',
      'Your request has been sent to ${widget.doc.name}.',
    );

    // Firebase notification
    await _saveNotificationToDatabase(
      senderId: auth.currentUser!.uid,
      receiverId: widget.doc.uid!,
      requestId: DateTime.now().microsecondsSinceEpoch.toString(),
      content: "New appointment booked with ${Constants.name}",
    );
  }

  Future<void> _saveNotificationToDatabase({
    required String senderId,
    required String receiverId,
    required String requestId,
    required String content,
  }) async {
    final notificationsRef = FirebaseDatabase.instance.ref("Notifications");

    final notificationData = {
      'senderId': senderId,
      'receiverId': receiverId,
      'requestId': requestId,
      'content': content,
      'timestamp': ServerValue.timestamp,
      'read': false,
    };

    final notification = {
      'senderId': receiverId,
      'receiverId': senderId,
      'requestId': requestId,
      'content': 'Your request has been sent to ${widget.doc.name}.',
      'timestamp': ServerValue.timestamp,
      'read': false,
    };

    await notificationsRef.child(receiverId).push().set(notificationData);
    await notificationsRef.child(senderId).push().set(notification);
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(android: initializationSettingsAndroid),
    );
    await _createNotificationChannel();
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'appointment_channel',
      'Appointment Notifications',
      description: 'Notifications for appointment bookings',
      importance: Importance.max,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'appointment_channel',
      'Appointment Notifications',
      channelDescription: 'Notifications for appointment bookings',
      importance: Importance.max,
      priority: Priority.high,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(android: androidNotificationDetails),
    );
  }
}
