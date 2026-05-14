import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mind_guide_ui/admin/admin_home_screen.dart';
import 'package:mind_guide_ui/constants.dart';
import 'package:mind_guide_ui/login_screen.dart';
import 'package:mind_guide_ui/patient_main_screen.dart';
import 'package:mind_guide_ui/signup_screen.dart';

import 'common/otp_screen.dart';
import 'doctor/doctor_home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    Constants.loading == true
        ? WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkAuthStatus();
          })
        : "";
  }

  Future<void> _checkAuthStatus() async {
    User? currentUser = _auth.currentUser;
    print(currentUser);
    await Future.delayed(
      const Duration(seconds: 3),
    ); // Simulates splash screen delay

    if (currentUser == null) {
      _navigateToLogin();
    } else {
      try {
        DatabaseReference userRef = _database.child('patients');
        DataSnapshot data = await userRef.get();

        if (data.value != null) {
          Map<dynamic, dynamic> patients = data.value as Map<dynamic, dynamic>;

          for (var entry in patients.entries) {
            var patient = entry.value;

            if (patient['patientid'] == currentUser.uid) {
              print(patient['patientid']);
              print(currentUser.uid);
              print(patient['user']);
              if ((patient['user'] == "In-Clinic") ||
                  (patient['user'] == "Online")) {
                _navigateToDoctorHome();
                return;
              } else if (patient['user'] == "admin") {
                print("here");
                _navigateToAdminHome();
                return;
              } else if (patient['user'] == "patient") {
                _navigateToPatientHome();
                return;
              }
            }
          }
        }

        // Fallback: No matching patient ID found.
        _navigateToLogin();
      } catch (e) {
        print("Error checking authentication status: $e");
        _navigateToLogin(); // Fallback for errors.
      }
    }
  }

  void _navigateToLogin() {
    Constants.loading = false;
    setState(() {});
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      ),
    );
  }

  void _navigateToDoctorHome() {
    Constants.loading = false;
    setState(() {});
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const DoctorHomePage(),
      ),
    );
  }

  void _navigateToAdminHome() {
    print("now here");
    Constants.loading = false;
    setState(() {});
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const AdminHomeScreen(),
      ),
    );
  }

  void _navigateToPatientHome() {
    Constants.loading = false;
    setState(() {});
    User? currentUser = _auth.currentUser;
    if (currentUser!.emailVerified == false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PatientMainScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // color: Colors.black,
        child: Constants.loading == true
            ? Container(
                height: 800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                      child: Image.asset(
                        "images/app_logo.jpeg",
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      child: Text(
                        "Find Your Psychiatrist Easily.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent, //Color(0xff5294d5)
                        ),
                      ),
                    ),
                    CircularProgressIndicator(
                      color: Colors.deepOrangeAccent,
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 80,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                      child: Image.asset(
                        "images/app_logo.jpeg",
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Find Your Psychiatrist Easily.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrangeAccent, //Color(0xff5294d5)
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          30,
                        ),
                        topRight: Radius.circular(
                          30,
                        ),
                      ),
                      color: Colors.deepOrangeAccent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.deepOrangeAccent,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  30,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.deepOrangeAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  30,
                                ),
                                side: BorderSide(
                                  width: 1,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Signup",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
