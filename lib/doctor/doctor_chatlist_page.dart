import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mind_guide_ui/chat_screen.dart';

import 'model/patient.dart';

class DoctorChatlistPage extends StatefulWidget {
  const DoctorChatlistPage({super.key});

  @override
  State<DoctorChatlistPage> createState() => _DoctorChatlistPageState();
}

class _DoctorChatlistPageState extends State<DoctorChatlistPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _chatListDatabase =
      FirebaseDatabase.instance.ref().child('ChatList');
  final DatabaseReference _patientsDatabase =
      FirebaseDatabase.instance.ref().child('patients');
  List<Patient> _chatList = [];
  bool _isLoading = true;
  late String doctorId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doctorId = _auth.currentUser?.uid ?? '';
    // print(_auth.currentUser?.uid);
    _fetchChatList();
  }

  Future<void> _fetchChatList() async {
    if (doctorId.isNotEmpty) {
      try {
        // print(event);
        DataSnapshot snapshot = await _chatListDatabase.ref.get();
        // print(snapshot);
        List<Patient> tempChatList = [];

        if (snapshot.value != null) {
          Map<dynamic, dynamic> values =
              snapshot.value as Map<dynamic, dynamic>;
          print(values);

          final snapshot2 = await _patientsDatabase.ref.get();
          Map<dynamic, dynamic> ins = snapshot2.value as Map<dynamic, dynamic>;
          values.forEach((key, value) {
            if (key == _auth.currentUser!.uid) {
              ins.forEach((keys, values) {
                if (value.toString().contains(values['patientid'])) {
                  Patient p = Patient(
                    email: values['email'],
                    phoneNumber: values['number'],
                    uid: values['patientid'],
                    name: values['name'],
                  );
                  tempChatList.add(p);
                }
              });
            }
          });
        }
        _chatList = tempChatList;
        _isLoading = false;
        // print(_chatList);
        setState(() {});
      } catch (error) {
        // error message
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat with',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        leading: Container(),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrangeAccent,
              ),
            )
          : _chatList.isEmpty
              ? Center(
                  child: Text('No chats available'),
                )
              : ListView.builder(
                  itemCount: _chatList.length,
                  itemBuilder: (context, index) {
                    final patient = _chatList[index];
                    return InkWell(
                      onLongPress: () {
                        showAlertDialog(context, index, patient.uid);
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              doctorId: _auth.currentUser!.uid,
                              patientId: patient.uid,
                              patientName: patient.name,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: 5,
                              left: 20,
                              right: 20,
                              bottom: 5,
                            ),
                            decoration: BoxDecoration(
                              // border: Border.all(
                              //   width: 1,
                              //   color: Colors.deepOrangeAccent,
                              // ),
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              color: Colors.white,
                            ),
                            width: double.infinity,
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  height: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      100,
                                    ),
                                    child: Image.asset(
                                      "images/profile.gif",
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Text(
                                        patient.name,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(),
                                      child: Text(
                                        patient.phoneNumber,
                                      ),
                                    ),
                                    Container(
                                      width: 190,
                                      height: 30,
                                      margin: EdgeInsets.only(),
                                      child: Text(
                                        patient.email,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 50,
                                  child: Image.asset('images/message.gif'),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey.withOpacity(
                              0.5,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  showAlertDialog(BuildContext context, int index, String patientId) {
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
          FirebaseAuth auth = FirebaseAuth.instance;
          _chatList.removeAt(index);
          DatabaseReference ref = FirebaseDatabase.instance.ref('ChatList');
          // Query the database to find the record with the given patientId
          DatabaseReference event =
              await ref.child(auth.currentUser!.uid).child(patientId);

          await event.remove();
          // if (event.snapshot.value != null) {
          //   Map<dynamic, dynamic> patients =
          //       event.snapshot.value as Map<dynamic, dynamic>;
          //
          //   // Loop through the results and delete each matching entry
          //   patients.forEach((key, value) async {
          //     await ref.remove();
          //     print("Patient with ID $patientId removed successfully.");
          //   });
          // } else {
          //   print("No patient found with ID: $patientId");
          // }
          Fluttertoast.showToast(
              msg: "Chat Deleted Successfully!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.orange,
              textColor: Colors.white,
              fontSize: 16.0);

          setState(() {});
          Navigator.pop(context);
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
      content: Text("Do you want to Delete this Chat?"),
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
}
