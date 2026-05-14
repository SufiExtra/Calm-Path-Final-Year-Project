import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminDeletePatients extends StatefulWidget {
  const AdminDeletePatients({super.key});

  @override
  State<AdminDeletePatients> createState() => _AdminDeletePatientsState();
}

class _AdminDeletePatientsState extends State<AdminDeletePatients> {
  bool loading = false;
  List<patients> ppp = [];
  @override
  void initState() {
    ppp.clear();
    // TODO: implement initState
    super.initState();
    get_patient();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          "Delete Patients",
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
      body: loading == false
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrangeAccent,
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: ppp.isNotEmpty
                    ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: ppp.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "images/profile.gif",
                                          height: 70,
                                          width: 70,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 180,
                                              child: Text(
                                                ppp[index].name,
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                              ),
                                            ),
                                            Container(
                                              width: 180,
                                              child: Text(
                                                ppp[index].number,
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                              ),
                                            ),
                                            Container(
                                              width: 180,
                                              child: Text(
                                                ppp[index].email,
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showAlertDialog(context, index,
                                            ppp[index].patientid);
                                      },
                                      child: Image.asset(
                                        'images/delete.gif',
                                        height: 70,
                                        width: 70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        })
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Text("No Patient Available!"),
                        ),
                      ),
              ),
            ),
    );
  }

  get_patient() async {
    final ref = FirebaseDatabase.instance.ref('patients');
    final data = await ref.get();
    Map<dynamic, dynamic> ins = data.value as Map<dynamic, dynamic>;
    ins.forEach((key, value) {
      var pp = patients(
        name: value['name'],
        number: value['number'],
        email: value['email'],
        patientid: value['patientid'],
        user: value['user'] ?? '',
      );
      if (pp.user != 'In-Clinic' && pp.user != 'Online' && pp.user != 'admin') {
        ppp.add(pp);
        print(pp.name);
      } else {
        print(pp.name + " is not a patient");
      }
      loading = true;
      setState(() {});
    });
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
          ppp.removeAt(index);
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
          Fluttertoast.showToast(
              msg: "Patient Deleted Successfully!",
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
      content: Text("Do you want to Delete this Patient?"),
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

class patients {
  final String name;
  final String email;
  final String patientid;
  final String number;
  final String user;
  patients({
    required this.name,
    required this.number,
    required this.email,
    required this.patientid,
    required this.user,
  });
}
