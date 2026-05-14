import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mind_guide_ui/common/notification_screen.dart';
import 'package:mind_guide_ui/edit_profile_screen.dart';
import 'package:mind_guide_ui/login_screen.dart';
import 'package:mind_guide_ui/patient/assestment_test_screen.dart';
import 'package:mind_guide_ui/patient/patient_give_feedback_screen.dart';
import 'package:mind_guide_ui/patient_main_screen.dart';

import 'constants.dart';

class PatientHomeScreen extends StatefulWidget {
  PatientHomeScreen({
    super.key,
  });

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  Timer? timer;
  int o = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    o <= 5
        ? timer = Timer.periodic(
            Duration(seconds: 1),
            (Timer t) => function(),
          )
        : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: Image.asset(
                        "images/profile.gif",
                        height: 100,
                        width: 100,
                      ),
                    ),
                    Container(
                      child: Text(
                        Constants.name.toString(),
                      ),
                    ),
                    Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.deepOrangeAccent,
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            width: 1,
                            color: Colors.deepOrangeAccent,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              5,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(),
                            ),
                          );
                        },
                        child: Text("Edit profile"),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.deepOrangeAccent,
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => MyProfilesScreen(),
              //       ),
              //     );
              //   },
              //   child: Container(
              //     margin: EdgeInsets.only(
              //       left: 15,
              //       right: 15,
              //       top: 5,
              //       bottom: 5,
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           "My Profiles",
              //           style: TextStyle(
              //             fontSize: 17,
              //           ),
              //         ),
              //         Icon(
              //           Icons.navigate_next,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Divider(
              //   color: Colors.grey.withOpacity(
              //     0.2,
              //   ),
              // ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsScreen(),
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
                        "Notifications",
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
                onTap: () {},
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
                        "Wallet",
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
                onTap: () {},
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
                        "Refer a Friend",
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientFeedbackScreen(),
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
                        "Give Feedback",
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
                  FirebaseAuth auth = await FirebaseAuth.instance;
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
        color: Colors.deepOrangeAccent.withOpacity(
          0.1,
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            ClipPath(
              clipper: CurvedClipper(),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(
                  //   200,
                  // ),
                  color: Colors.deepOrangeAccent,
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        100,
                      ),
                      child: Image.asset(
                        "images/test.gif",
                        height: 130,
                        width: 130,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                "Are you in/extrovert?\nClick start and find out!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrangeAccent,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(50),
              ),
              margin: EdgeInsets.only(top: 10, left: 30, right: 30),
              child: Row(
                children: [
                  // Left side - Extrovert
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    width: 136,
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 5, top: 5, bottom: 5),
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "E",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(width: 3),
                        Text(
                          "Extrovert",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Middle - ?
                  Expanded(
                    child: Center(
                      child: Text(
                        "?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),

                  // Right side - Introvert
                  Container(
                    width: 136,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Introvert",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 3),
                        Container(
                          alignment: Alignment.center,
                          height: 60,
                          margin: EdgeInsets.only(
                              left: 5, top: 5, bottom: 5, right: 5),
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "I",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 50,
              ),
              height: 50,
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.deepOrangeAccent,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssestmentTestScreen(),
                    ),
                  );
                },
                child: Text(
                  "START",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 20,
              ),
              height: 50,
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.deepOrangeAccent,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                onPressed: () {
                  PatientMainScreen.currentIndex = 2;

                  setState(() {});
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientMainScreen(),
                    ),
                  );
                },
                child: Text(
                  "RESULTS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void function() {
    o++;
    setState(() {});
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50); // Start bottom-left
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50); // Curve
    path.lineTo(size.width, 0); // Top-right
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
