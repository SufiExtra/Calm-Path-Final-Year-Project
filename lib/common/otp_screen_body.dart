import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../patient_main_screen.dart';

class OtpScreenBody extends StatefulWidget {
  const OtpScreenBody({super.key});

  @override
  State<OtpScreenBody> createState() => _OtpScreenBodyState();
}

class _OtpScreenBodyState extends State<OtpScreenBody> {
  @override
  void initState() {
    // TODO: implement initState
    sendEmail();
    super.initState();
  }

  reload() async {
    await FirebaseAuth.instance.currentUser!.reload().then(
          (value) => {},
        );
  }

  sendEmail() async {
    try {
      final auth = await FirebaseAuth.instance.currentUser!;
      auth.sendEmailVerification().then(
            (value) => {
              Fluttertoast.showToast(
                msg: "Email Verification link sent to your Email!",
              ),
            },
          );
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Container(
            margin: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Text(
              "Email has been sent to your Email, please check and verify. After verifying click the reload button in the bottom right.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              right: 20,
              bottom: 20,
            ),
            width: double.infinity,
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              backgroundColor: Colors.deepOrangeAccent,
              onPressed: () async {
                await reload();
                if (FirebaseAuth.instance.currentUser!.emailVerified) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientMainScreen(),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "Please verify first!",
                  );
                }
              },
              child: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
