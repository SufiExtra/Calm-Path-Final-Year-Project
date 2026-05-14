import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminDeletePschiatrist extends StatefulWidget {
  const AdminDeletePschiatrist({super.key});

  @override
  State<AdminDeletePschiatrist> createState() => _AdminDeletePschiatristState();
}

class _AdminDeletePschiatristState extends State<AdminDeletePschiatrist> {
  bool loading = false;
  List<psychiatrist> psyco = [];
  @override
  void initState() {
    psyco.clear();
    // TODO: implement initState
    super.initState();
    get_psychiatrist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          "Delete Psychiatrist",
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
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        width: double.infinity,
                        color: Colors.deepOrangeAccent.withOpacity(
                          0.1,
                        ),
                        child: psyco.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: psyco.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                      top: 10,
                                      left: 20,
                                      right: 20,
                                    ),
                                    padding: EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                50,
                                              ),
                                              child: psyco[index].img == ""
                                                  ? Image.asset(
                                                      "images/profile.gif",
                                                      height: 100,
                                                      width: 100,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Image.network(
                                                        psyco[index].img,
                                                        height: 80,
                                                        width: 80,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                left: 10,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 220,
                                                    height: 35,
                                                    child: Text(
                                                      psyco[index].name,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.025,
                                                      ),
                                                      overflow:
                                                          TextOverflow.fade,
                                                      textScaler:
                                                          TextScaler.linear(
                                                        1.0,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${psyco[index].specialization == '' ? "No Specialization" : psyco[index].specialization}",
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.015,
                                                    ),
                                                    overflow: TextOverflow.fade,
                                                    textScaler:
                                                        TextScaler.linear(
                                                      1.0,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                  Text(
                                                    "${psyco[index].degree == '' ? "No Degree" : psyco[index].degree}",
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.015,
                                                    ),
                                                    overflow: TextOverflow.fade,
                                                    textScaler:
                                                        TextScaler.linear(
                                                      1.0,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "${psyco[index].time == '' ? "0 mints" : psyco[index].time}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Wait Time",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            VerticalDivider(
                                              color: Colors.grey,
                                              width: 1,
                                              thickness: 1,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "${psyco[index].experience == '' ? 0 : psyco[index].experience}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Experience",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            VerticalDivider(
                                              color: Colors.grey,
                                              width: 1,
                                              thickness: 5,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "100%(${0})",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Satisfied Patients",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                            top: 10,
                                            right: 10,
                                            left: 10,
                                          ),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor:
                                                  Colors.deepOrangeAccent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  5,
                                                ),
                                              ),
                                            ),
                                            onPressed: () async {
                                              showAlertDialog(context, index,
                                                  psyco[index].uid!);
                                            },
                                            child: Text("Delete Psychiatrist"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text("No Psychiatrist Available!"),
                              )),
                  ],
                ),
              ),
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
          psyco.removeAt(index);
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
              msg: "Psychiatrist Deleted Successfully!",
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
      content: Text("Do you want to Delete this Psyciatrist?"),
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

  get_psychiatrist() async {
    final ref = FirebaseDatabase.instance.ref('patients');
    DataSnapshot data = await ref.get();
    Map<dynamic, dynamic> ins = data.value as Map<dynamic, dynamic>;
    ins.forEach((key, value) {
      var doc = psychiatrist(
        user: value['user'] ?? '',
        email: value['email'] ?? '',
        degree: value['degree'] ?? '',
        experience: value['experience'] ?? '',
        number: value['number'].toString() ?? '',
        time: value['time'] ?? '',
        img: value['img'] ?? '',
        name: value['name'] ?? '',
        specialization: value['specialization'] ?? '',
        uid: value['patientid'] ?? '',
        patients: '',
        fees: '1000',
        fcmToken: value['patientid'] ?? '',
        satisfied: value['satisfied'] ?? 0,
        place: (value['place'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        disease: (value['disease'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );
      if (value['user'] == "In-Clinic" || value['user'] == "Online") {
        psyco.add(doc);
      }
    });
    loading = true;
    setState(() {});
    print(psyco.length);
  }
}

class psychiatrist {
  String img;
  String name;
  String number;
  String specialization;
  String degree;
  String time;
  String experience;
  String patients;
  String fees;
  String? appointed_time;
  String? uid;
  String user;
  String email;
  List<String> place;
  String fcmToken;
  int? satisfied;
  List<String?> disease;

  psychiatrist({
    required this.img,
    required this.name,
    required this.specialization,
    required this.degree,
    required this.time,
    required this.experience,
    required this.patients,
    required this.fees,
    this.appointed_time,
    this.uid,
    required this.number,
    required this.user,
    required this.email,
    required this.place,
    required this.fcmToken,
    this.satisfied,
    required this.disease,
  });
}
