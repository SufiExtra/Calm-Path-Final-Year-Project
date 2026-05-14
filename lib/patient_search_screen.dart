import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mind_guide_ui/doctor/model/booking.dart';
import 'package:mind_guide_ui/patient/doctor_profile_screen.dart';
import 'package:mind_guide_ui/patient_booking_screen.dart';

import 'constants.dart';

class PatientSearchScreen extends StatefulWidget {
  PatientSearchScreen({super.key});

  @override
  State<PatientSearchScreen> createState() => _PatientSearchScreenState();
}

class _PatientSearchScreenState extends State<PatientSearchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    docs.clear();
    get_psychiatrist();
  }

  int index1 = 0;
  DateTime? startTime;
  DateTime? endTime;
  bool loading = false;

  String? search;

// Original list of all doctors (make sure to keep a copy to reset filters)
  static List<psychiatrist> originalDocs = [];
  static List<psychiatrist> docs = [];

// Function to reset filters
  void resetFilters() {
    docs = List.from(originalDocs);
  }

// Initialize function (call this when you first load doctors)
  void initializeDoctors(List<psychiatrist> loadedDocs) {
    docs = loadedDocs;
  }

  void _performSearch(String query) {
    docs.clear();

    if (query.isEmpty) {
      // If search is empty, show all doctors
      docs.addAll(originalDocs);
    } else {
      // Otherwise filter doctors
      for (var i = 0; i < originalDocs.length; i++) {
        if (originalDocs[i].name.toLowerCase().contains(
              query.toLowerCase(),
            )) {
          docs.add(originalDocs[i]);
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Move items list inside the state class
// Replace your current items list with this corrected version
    final List<searching_text> items = [
      searching_text(
        name: "Lowest Fee",
        function: () {
          setState(() {
            docs.sort((a, b) {
              int? aFee =
                  int.tryParse(a.fees.replaceAll(RegExp(r'[^0-9]'), ''));
              int? bFee =
                  int.tryParse(b.fees.replaceAll(RegExp(r'[^0-9]'), ''));
              return aFee!.compareTo(bFee!); // Ascending order for lowest first
            });
          });
        },
      ),
      searching_text(
        name: "Most Experienced",
        function: () {
          setState(() {
            docs.sort((a, b) {
              int? aExp =
                  int.tryParse(a.experience.replaceAll(RegExp(r'[^0-9]'), ''));
              int? bExp =
                  int.tryParse(b.experience.replaceAll(RegExp(r'[^0-9]'), ''));
              return bExp!.compareTo(aExp!); // Descending order
            });
          });
        },
      ),
      searching_text(
        name: "Highest Rated",
        function: () {
          setState(() {
            docs.sort((a, b) {
              int aRating = a.satisfied ?? 0;
              int bRating = b.satisfied ?? 0;
              return bRating
                  .compareTo(aRating); // Descending order for highest rated
            });
          });
        },
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          "Psychiatrist",
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
                  top: 10,
                  right: 20,
                  left: 20,
                ),
                child: TextField(
                  onChanged: (value) {
                    search = value;
                    _performSearch(search!);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(
                          0.5,
                        ),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(
                          0.5,
                        ),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(
                          0.5,
                        ),
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.withOpacity(
                        0.5,
                      ),
                    ),
                    hintText:
                        "Doctors, hospitals, specialists, services, disease",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 20,
                  top: 10,
                ),
                height: 40,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        items[index]
                            .function(); // Add parentheses to call the function
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          right: 10,
                        ),
                        alignment: Alignment.center,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            width: 1,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Text(
                            items[index].name,
                            style: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.017,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              loading == false
                  ? Container(
                      height: 500,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(
                        top: 20,
                      ),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.65572679,
                      color: Colors.deepOrangeAccent.withOpacity(
                        0.1,
                      ),
                      child: docs.isNotEmpty
                          ? ListView.builder(
                              itemCount: docs.length,
                              itemBuilder: (context, index) {
                                // docs.sort((a, b) {
                                //   int aSatisfied = a.satisfied ?? 0;
                                //   int bSatisfied = b.satisfied ?? 0;
                                //   return bSatisfied.compareTo(
                                //       aSatisfied); // Descending order
                                // });

                                return Container(
                                  margin: EdgeInsets.only(
                                    top: 20,
                                    left: 20,
                                    right: 20,
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
                                          InkWell(
                                            onTap: () {
                                              FirebaseAuth auth =
                                                  FirebaseAuth.instance;
                                              Booking b = Booking(
                                                  user: docs[index].user,
                                                  experience:
                                                      docs[index].experience,
                                                  place: docs[index].place,
                                                  disease: docs[index].disease,
                                                  date: '',
                                                  description: '',
                                                  id: 0,
                                                  receiver: docs[index].uid!,
                                                  sender: auth.currentUser!.uid,
                                                  status: '',
                                                  time: '',
                                                  number: docs[index].number,
                                                  demail: docs[index].email,
                                                  name: docs[index].name,
                                                  doc: docs[index].name,
                                                  degree: docs[index].degree,
                                                  specs: docs[index]
                                                      .specialization,
                                                  did: docs[index].uid!,
                                                  img: docs[index].img);
                                              setState(() {});
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DoctorProfileScreen(
                                                    book: b,
                                                    isDoctor: false,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                50,
                                              ),
                                              child: docs[index].img == ""
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
                                                        docs[index].img,
                                                        height: 80,
                                                        width: 80,
                                                        fit: BoxFit.cover,
                                                      ),
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
                                                InkWell(
                                                  onTap: () {
                                                    FirebaseAuth auth =
                                                        FirebaseAuth.instance;
                                                    Booking b = Booking(
                                                        user: docs[index].user,
                                                        experience: docs[index]
                                                            .experience,
                                                        place:
                                                            docs[index].place,
                                                        disease:
                                                            docs[index].disease,
                                                        date: '',
                                                        description: '',
                                                        id: 0,
                                                        receiver:
                                                            docs[index].uid!,
                                                        sender: auth
                                                            .currentUser!.uid,
                                                        status: '',
                                                        time: '',
                                                        number:
                                                            docs[index].number,
                                                        demail:
                                                            docs[index].email,
                                                        name: docs[index].name,
                                                        doc: docs[index].name,
                                                        degree:
                                                            docs[index].degree,
                                                        specs: docs[index]
                                                            .specialization,
                                                        did: docs[index].uid!,
                                                        img: docs[index].img);
                                                    setState(() {});
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DoctorProfileScreen(
                                                          book: b,
                                                          isDoctor: false,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 220,
                                                    height: 35,
                                                    child: Text(
                                                      docs[index].name,
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
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    FirebaseAuth auth =
                                                        FirebaseAuth.instance;
                                                    Booking b = Booking(
                                                        user: docs[index].user,
                                                        experience: docs[index]
                                                            .experience,
                                                        place:
                                                            docs[index].place,
                                                        disease:
                                                            docs[index].disease,
                                                        date: '',
                                                        description: '',
                                                        id: 0,
                                                        receiver:
                                                            docs[index].uid!,
                                                        sender: auth
                                                            .currentUser!.uid,
                                                        status: '',
                                                        time: '',
                                                        number:
                                                            docs[index].number,
                                                        demail:
                                                            docs[index].email,
                                                        name: docs[index].name,
                                                        doc: docs[index].name,
                                                        degree:
                                                            docs[index].degree,
                                                        specs: docs[index]
                                                            .specialization,
                                                        did: docs[index].uid!,
                                                        img: docs[index].img);
                                                    setState(() {});
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DoctorProfileScreen(
                                                          book: b,
                                                          isDoctor: false,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "${docs[index].specialization == '' ? "No Specialization Entered" : docs[index].specialization}",
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
                                                ),
                                                Text(
                                                  "${docs[index].degree == '' ? 'No Degree Entered' : docs[index].degree}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.015,
                                                  ),
                                                  overflow: TextOverflow.fade,
                                                  textScaler: TextScaler.linear(
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
                                                "${docs[index].time == '' ? 'No Time Entered' : docs[index].time}",
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
                                                "${docs[index].experience == '' ? "No Experiece Entered" : docs[index].experience + ''}",
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
                                                "100%(${docs[index].satisfied})",
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
                                          bottom: 10,
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
                                            index1 = index;
                                            setState(() {});
                                            if (Constants.forSearch ==
                                                "In-Clinic") {
                                              _showAddressDialog(
                                                  context, docs[index].place);
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PatientBookingScreen(
                                                    doc: docs[index],
                                                    index: index,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Text("Book Appointment"),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text("No Psychiatrist Available!"),
                            ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddressDialog(BuildContext context, List<String> addresses) {
    String? selectedAddress;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Address'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: addresses.map((address) {
                  return RadioListTile<String>(
                    title: Text(address),
                    value: address,
                    groupValue: selectedAddress,
                    onChanged: (value) {
                      setState(() {
                        selectedAddress = value!;
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (selectedAddress != null) {
                  Constants.selectedAddress = selectedAddress;
                  setState(() {});
                  Navigator.of(context).pop(); // Close the dialog

                  // Proceed to next screen
                  Constants.forSearch = "In-Clinic";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientBookingScreen(
                        doc: docs[index1],
                        index: index1,
                      ),
                    ),
                  );
                }
              },
              child: Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  get_psychiatrist() async {
    originalDocs.clear();
    docs.clear();
    setState(() {});
    final ref = FirebaseDatabase.instance.ref('patients');
    DataSnapshot data = await ref.get();
    Map<dynamic, dynamic> ins = data.value as Map<dynamic, dynamic>;
    ins.forEach((key, value) {
      var doc = psychiatrist(
        user: value['user'] ?? '',
        email: value['email'] ?? '',
        degree: value['degree'] ?? '',
        experience: value['experience'] ?? '',
        number: value['number'] ?? '',
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
      if (Constants.forSearch == "In-Clinic") {
        if (doc.user == 'In-Clinic') {
          originalDocs.add(doc);
          docs.add(doc);
          print(doc);
        } else {
          print("not a doctor:${doc.name}");
        }
      } else if (Constants.forSearch == "Online") {
        if (doc.user == 'Online') {
          originalDocs.add(doc);
          docs.add(doc);
          print(doc);
        } else {
          print("not a doctor:${doc.name}");
        }
      }
    });
    loading = true;
    setState(() {});
    print(docs.length);
  }
}

class searching_text {
  String name;
  final function;
  searching_text({
    required this.name,
    required this.function,
  });
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
