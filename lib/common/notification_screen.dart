import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final DatabaseReference notificationsRef =
      FirebaseDatabase.instance.ref("Notifications");
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: notificationsRef.child(currentUserId).onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.exists) {
            Map<dynamic, dynamic> notifications =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

            List<MapEntry> notificationList = notifications.entries.toList()
              ..sort((a, b) =>
                  b.value['timestamp'].compareTo(a.value['timestamp']));

            return ListView.builder(
              itemCount: notificationList.length,
              itemBuilder: (context, index) {
                final notification = notificationList[index].value;
                return ListTile(
                  title: Text(notification['content']),
                  subtitle: Text(
                    DateFormat('MMM dd, yyyy - hh:mm a').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          notification['timestamp']),
                    ),
                  ),
                  trailing: notification['read'] == false
                      ? const Icon(Icons.circle, color: Colors.red, size: 12)
                      : null,
                  onTap: () {
                    // Mark as read
                    notificationsRef
                        .child(currentUserId)
                        .child(notificationList[index].key)
                        .update({'read': true});

                    // Navigate to appointment details if needed
                  },
                );
              },
            );
          } else {
            return const Center(child: Text("No notifications yet"));
          }
        },
      ),
    );
  }
}
