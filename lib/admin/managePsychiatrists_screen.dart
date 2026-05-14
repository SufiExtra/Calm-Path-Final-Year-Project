import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'editPsychiatrist_screen.dart';

class ManagePsychiatristsScreen extends StatefulWidget {
  @override
  _ManagePsychiatristsScreenState createState() =>
      _ManagePsychiatristsScreenState();
}

class _ManagePsychiatristsScreenState extends State<ManagePsychiatristsScreen> {
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('patients');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0064FA),
        title: Text(
          'Manage Psychiatrists',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: _databaseRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text('No psychiatrists found'));
          }

          Map<dynamic, dynamic> psychiatrists =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<Map<String, dynamic>> psychiatristList = [];

          psychiatrists.forEach((key, value) {
            psychiatristList.add({
              'id': value['patientid'],
              'name': value['name'],
              'email': value['email'],
              'number': value['number'],
            });
          });

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: psychiatristList.length,
            itemBuilder: (context, index) {
              var psychiatrist = psychiatristList[index];

              return GestureDetector(
                onTap: () {
                  // Handle navigation to details screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditPsychiatristScreen(
                          psychiatristId: psychiatrist['id']),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          AssetImage("images/profile.gif") as ImageProvider,
                    ),
                    title: Text(
                      psychiatrist['name'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'email: ${psychiatrist['email']}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    trailing:
                        Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
