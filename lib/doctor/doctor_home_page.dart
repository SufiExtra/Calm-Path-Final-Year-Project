import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import 'doctor_chatlist_page.dart';
import 'doctor_profile.dart';
import 'doctor_requests_page.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    setState(() {});
  }

  int _selectedIndex = 0;

  final List<Widget> _children = [
    DoctorRequestsPage(),
    DoctorChatlistPage(),
    DoctorProfile(),
  ];

  void _onItmTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWilPop() async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to exit the app?'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      SystemNavigator.pop();
                    },
                    child: Text('Yes')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        body: _children.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_filled,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                ),
                label: 'Chat'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.event_available,
                ),
                label: 'Availability'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.deepOrangeAccent,
          onTap: _onItmTapped,
        ),
      ),
    );
  }

  Future<void> getData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    DatabaseReference ref = FirebaseDatabase.instance.ref("patients");
    DataSnapshot patientData = await ref.get();
    Map<dynamic, dynamic> ins = patientData.value as Map<dynamic, dynamic>;
    ins.forEach((key, value) {
      if (auth.currentUser!.uid == value['patientid']) {
        Constants.email = value['email'] ?? '';
        Constants.name = value['name'] ?? '';
        Constants.number = value['number'] ?? '';
        Constants.age = value['age'] ?? '';
        Constants.gender = value['gender'] ?? '';
        Constants.specialization = value['specialization'] ?? '';
        Constants.time = value['time'] ?? '';
        Constants.place = value['place'] ?? '';
        Constants.experience = value['experience'] ?? '';
        Constants.degree = value['degree'] ?? '';
        Constants.img = value['img'] ?? '';
        Constants.disease = value['disease'] ?? '';
        setState(() {});
      }
    });
  }
}
