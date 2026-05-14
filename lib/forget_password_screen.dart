import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  String? email;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          "Reset your Password",
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
                  "images/forget.gif",
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
                  top: 20,
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
                    FirebaseAuth auth = FirebaseAuth.instance;
                    loading = true;
                    setState(() {});
                    if (email == null) {
                      loading = false;
                      setState(() {});
                      Fluttertoast.showToast(
                          msg: "Enter Email first!",
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
                    } else {
                      try {
                        await auth.sendPasswordResetEmail(
                          email: email.toString(),
                        );
                        Fluttertoast.showToast(
                            msg:
                                "Reset Password Email has been sent!\nCheck your Inbox!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: CupertinoColors.systemOrange,
                            textColor: CupertinoColors.white,
                            fontSize: 16.0);
                      } catch (e) {
                        print("Error sending password reset email: $e");
                      } finally {
                        loading = false;
                        setState(() {});
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: loading == false
                      ? Text(
                          "Reset",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        )
                      : CircularProgressIndicator(
                          color: CupertinoColors.systemOrange,
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
