import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mind_guide_ui/constants.dart';
import 'package:mind_guide_ui/patient/patient_book_appointment_screen.dart';
import 'package:mind_guide_ui/patient_healthzone_screen.dart';
import 'package:mind_guide_ui/patient_home_screen.dart';

class PatientMainScreen extends StatefulWidget {
  static int currentIndex = 0;

  const PatientMainScreen({super.key});

  @override
  State<PatientMainScreen> createState() => _PatientMainScreenState();
}

class _PatientMainScreenState extends State<PatientMainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Constants.name == null ? getData() : "";
  }

  //Transitions of pages of nav bar of patient home page
  final List<Widget> _pages = [
    PatientHomeScreen(),
    PatientBookAppointmentScreen(),
    PatientHealthzoneScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              PatientMainScreen.currentIndex = index;
            });
          },
          currentIndex: PatientMainScreen.currentIndex,
          selectedItemColor: Colors.deepOrangeAccent,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.black,
          selectedIconTheme: IconThemeData(color: Colors.deepOrangeAccent),
          unselectedIconTheme: IconThemeData(color: Colors.black),
          selectedLabelStyle: TextStyle(color: Colors.deepOrangeAccent),
          unselectedLabelStyle: TextStyle(color: Colors.black),
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                activeIcon: Icon(
                  Icons.home,
                  color: Colors.deepOrangeAccent,
                ),
                icon: Icon(
                  Icons.home,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                activeIcon: Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.deepOrangeAccent,
                ),
                icon: Icon(
                  Icons.calendar_today_outlined,
                ),
                label: "Appointments"),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              activeIcon: Icon(
                Icons.monitor_heart,
                color: Colors.deepOrangeAccent,
              ),
              icon: Icon(
                Icons.monitor_heart,
              ),
              label: "Results",
            ),
          ],
        ),
        body: _pages[PatientMainScreen.currentIndex],
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
        Constants.email = value['email'];
        Constants.name = value['name'];
        Constants.number = value['number'];
        Constants.age = value['age'] ?? '';
        Constants.gender = value['gender'] ?? '';

        setState(() {});
      }
    });
  }
}
