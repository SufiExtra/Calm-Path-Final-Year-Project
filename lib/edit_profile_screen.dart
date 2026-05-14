import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mind_guide_ui/constants.dart';
import 'package:mind_guide_ui/splash_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool loading = false;
  TextEditingController name = TextEditingController(text: Constants.name);
  TextEditingController email = TextEditingController(text: Constants.email);
  TextEditingController age =
      TextEditingController(text: Constants.age == "" ? "23" : Constants.age);
  String? gender = Constants.gender == '' ? "male" : Constants.gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          "My Profile",
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
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
              ),
              child: TextField(
                controller: name,
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
                  hintText: "ABC DEF",
                  labelText: "Name",
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
                enabled: false,
                controller: email,
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
                  labelText: "Email",
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
                controller: age,
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
                  hintText: "12",
                  labelText: "Age in years",
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(
                top: 10,
                left: 20,
              ),
              child: Text(
                "Gender",
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
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
                children: [
                  InkWell(
                    onTap: () {
                      gender = "male";
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            30,
                          ),
                          bottomLeft: Radius.circular(
                            30,
                          ),
                        ),
                        border: Border.all(
                          width: 1,
                          color: gender == "male"
                              ? Colors.deepOrangeAccent
                              : CupertinoColors.darkBackgroundGray,
                        ),
                        color: gender == "male"
                            ? Colors.white
                            : Colors.grey.withOpacity(
                                0.2,
                              ),
                      ),
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.449,
                      child: Text(
                        "Male",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: gender == "male"
                              ? Colors.deepOrangeAccent
                              : Colors.grey.withOpacity(
                                  0.9,
                                ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      gender = "female";
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                            30,
                          ),
                          bottomRight: Radius.circular(
                            30,
                          ),
                        ),
                        border: Border.all(
                          width: 1,
                          color: gender == "female"
                              ? Colors.deepOrangeAccent
                              : CupertinoColors.darkBackgroundGray,
                        ),
                        color: gender == "female"
                            ? Colors.white
                            : Colors.grey.withOpacity(
                                0.2,
                              ),
                      ),
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.449,
                      child: Text(
                        textAlign: TextAlign.center,
                        "Female",
                        style: TextStyle(
                          color: gender == "female"
                              ? Colors.deepOrangeAccent
                              : Colors.grey.withOpacity(
                                  0.9,
                                ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(
                top: 10,
                left: 20,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.deepOrangeAccent,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () async {
                      print("tap");
                      FirebaseAuth auth = FirebaseAuth.instance;
                      showAlertDialog(context, auth.currentUser!.uid);
                    },
                    child: Container(
                      height: 22,
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "Delete my account",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
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
                onPressed: () {
                  if (int.parse(age.text) > 99) {
                    Fluttertoast.showToast(msg: "Age should be less than 100!");
                  } else {
                    update_profile();
                  }
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => PatientMainScreen(),
                  //   ),
                  // );
                },
                child: loading == false
                    ? Text(
                        "Update Profile",
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
    );
  }

  showAlertDialog(BuildContext context, String patientId) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(
          color: Colors.orange,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Delete",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      onPressed: () async {
        try {
          // psyco.removeAt(index);
          DatabaseReference ref = FirebaseDatabase.instance.ref('patients');
          // Query the database to find the record with the given patientId
          DatabaseEvent event =
              await ref.orderByChild('patientid').equalTo(patientId).once();

          if (event.snapshot.value != null) {
            Map<dynamic, dynamic> patients =
                event.snapshot.value as Map<dynamic, dynamic>;

            // Loop through the results and delete each matching entry
            patients.forEach((key, value) async {
              await ref.child(key).remove();
              print("Patient with ID $patientId removed successfully.");
            });
          } else {
            print("No patient found with ID: $patientId");
          }
          FirebaseAuth auth = FirebaseAuth.instance;
          auth.signOut();
          Fluttertoast.showToast(
              msg: "Account Deleted Successfully!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.orange,
              textColor: Colors.white,
              fontSize: 16.0);

          setState(() {});
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SplashScreen(),
            ),
          );
        } catch (e) {
          Fluttertoast.showToast(
              msg: e.toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.orange,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(context);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text("Approval "),
      content: Text("Do you want to Delete your Account?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  update_profile() async {
    loading = true;
    setState(() {});

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      DatabaseReference ref = FirebaseDatabase.instance.ref("patients");
      DatabaseEvent event = await ref
          .orderByChild('patientid')
          .equalTo(auth.currentUser!.uid)
          .once();
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> patients =
            event.snapshot.value as Map<dynamic, dynamic>;
        patients.forEach((key, value) async {
          await ref.child(key).update({
            "age": age.text.toString(),
            "name": name.text.toString(),
            "gender": gender,
          });
          Constants.name = name.text.toString();
          Constants.age = age.text.toString();
          Constants.gender = gender.toString();
          Fluttertoast.showToast(
              msg: "Account updated successfully!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.orange,
              textColor: Colors.white,
              fontSize: 16.0);
          print(
              "Patient with ID ${auth.currentUser!.uid} updated successfully.");
        });
        loading = false;
        setState(() {});
      } else {
        loading = false;
        setState(() {});
        Fluttertoast.showToast(
            msg: "User not Found!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
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
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
