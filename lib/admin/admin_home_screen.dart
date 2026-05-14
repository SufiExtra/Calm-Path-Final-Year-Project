import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mind_guide_ui/admin/admin_feedback_screen.dart';
import 'package:mind_guide_ui/admin/admin_manage_patient_screen.dart';
import 'package:mind_guide_ui/admin/admin_manage_psychiatrist.dart';

import '../login_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: Text(
            "Home",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            size: 30,
            color: Colors.white,
          ),
        ),
        drawer: Drawer(
          width: 290,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.zero,
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 40,
                        ),
                        child: Image.asset(
                          "images/profile.gif",
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.deepOrangeAccent,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminFeedbackScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 5,
                      bottom: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Manage Feedback",
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        Icon(
                          Icons.navigate_next,
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey.withOpacity(
                    0.2,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    await auth.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 5,
                      bottom: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        Icon(
                          Icons.navigate_next,
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey.withOpacity(
                    0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminManagePatientScreen(),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.deepOrangeAccent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      18,
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Column(
                    children: [
                      Image.asset(
                        "images/manage_patients.gif",
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                      Text(
                        "Manage Patients",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * 0.025,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminManagePsychiatrist(),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.deepOrangeAccent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      18,
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Column(
                    children: [
                      Image.asset(
                        "images/manage_doc.gif",
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                      Text(
                        "Manage Psychiatrist",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * 0.025,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
