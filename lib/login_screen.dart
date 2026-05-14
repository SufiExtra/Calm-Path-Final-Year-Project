import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mind_guide_ui/admin/admin_home_screen.dart';
import 'package:mind_guide_ui/common/otp_screen.dart';
import 'package:mind_guide_ui/forget_password_screen.dart';
import 'package:mind_guide_ui/patient_main_screen.dart';
import 'package:mind_guide_ui/signup_screen.dart';
import 'package:mind_guide_ui/splash_screen.dart';

import 'constants.dart';
import 'doctor/doctor_home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  String? email;
  String? password;
  bool p = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          size: 30,
          color: Colors.white,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SplashScreen(),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 40,
                ),
                child: Image.asset(
                  "images/login.gif",
                  width: 120,
                  height: 120,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: TextField(
                  onChanged: (value) {
                    email = value;
                    setState(() {});
                  },
                  cursorColor: Colors.deepOrangeAccent,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    hintText: "abc123@gmail.com",
                    labelText: "Email Address",
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: TextField(
                  onChanged: (value) {
                    password = value;
                    setState(() {});
                  },
                  obscureText: p,
                  cursorColor: Colors.deepOrangeAccent,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        p == true ? p = false : p = true;
                        setState(() {});
                      },
                      icon: Icon(
                          p == true ? Icons.visibility_off : Icons.visibility),
                      color: Colors.deepOrangeAccent,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    hintText: "****************",
                    labelText: "Password",
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Don't have an Account?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgetPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
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
                    side: BorderSide(
                      width: 1,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  onPressed: () async {
                    loading = true;
                    setState(() {});
                    if (email == null) {
                      loading = false;
                      setState(() {});
                      Fluttertoast.showToast(
                          msg: "Enter email first!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 3,
                          backgroundColor: CupertinoColors.systemOrange,
                          textColor: CupertinoColors.white,
                          fontSize: 16.0);
                    } else if (!email!.contains("@gmail.com")) {
                      loading = false;
                      setState(() {});
                      Fluttertoast.showToast(
                          msg: "Email should have @gmail.com in it!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 3,
                          backgroundColor: CupertinoColors.systemOrange,
                          textColor: CupertinoColors.white,
                          fontSize: 16.0);
                    } else if (password == true) {
                      loading = false;
                      setState(() {});
                      Fluttertoast.showToast(
                          msg: "Enter password first!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 3,
                          backgroundColor: CupertinoColors.systemOrange,
                          textColor: CupertinoColors.white,
                          fontSize: 16.0);
                    } else {
                      try {
                        FirebaseAuth auth = FirebaseAuth.instance;

                        final user = await auth.signInWithEmailAndPassword(
                            email: email!, password: password!);
                        if (user.user!.uid.isNotEmpty) {
                          DatabaseReference ref =
                              FirebaseDatabase.instance.ref("patients");
                          DataSnapshot patientData = await ref.get();
                          Map<dynamic, dynamic> ins =
                              patientData.value as Map<dynamic, dynamic>;
                          ins.forEach((key, value) {
                            if (email == value['email']) {
                              Constants.name = value['name'];
                              Constants.number = value['number'];
                              Constants.email = value['email'];
                              Constants.pid = value['patientid'];
                              Constants.user = value['user'] ?? '';
                            }
                          });
                          loading = false;
                          setState(() {});
                          if (Constants.user == "In-Clinic" ||
                              Constants.user == "Online") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorHomePage(),
                              ),
                            );
                          } else if (Constants.user == "admin") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminHomeScreen(),
                              ),
                            );
                          } else {
                            if (user.user!.emailVerified == false) {
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
                        } else {
                          loading = false;
                          setState(() {});
                          Fluttertoast.showToast(
                              msg: "Invalid email or password",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: CupertinoColors.systemOrange,
                              textColor: CupertinoColors.white,
                              fontSize: 16.0);
                        }
                      } catch (e) {
                        loading = false;
                        setState(() {});
                        Fluttertoast.showToast(
                            msg: e.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: CupertinoColors.systemOrange,
                            textColor: CupertinoColors.white,
                            fontSize: 16.0);
                      }
                    }
                  },
                  child: loading == false
                      ? Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        )
                      : CircularProgressIndicator(
                          color: Colors.deepOrangeAccent,
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
