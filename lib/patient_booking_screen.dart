import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mind_guide_ui/patient_confirm_booking_screen.dart';
import 'package:mind_guide_ui/patient_search_screen.dart';

import 'constants.dart';

class PatientBookingScreen extends StatefulWidget {
  int index;
  psychiatrist doc;
  PatientBookingScreen({
    super.key,
    required this.doc,
    required this.index,
  });

  @override
  State<PatientBookingScreen> createState() => _PatientBookingScreenState();
  static List<eveningslots> times1 = [];
  static List<eveningslots> times = [];
}

class _PatientBookingScreenState extends State<PatientBookingScreen> {
  @override
  void initState() {
    super.initState();
    print(Constants.forSearch);
    // Initialize times based on appointment type
    if (Constants.forSearch == "In-Clinic") {
      // For in-clinic, generate fixed times once
      PatientBookingScreen.times1 = _generateFixedTimeSlots(DateTime.now());
      PatientBookingScreen.times = _generateFixedTimeSlots(DateTime.now());
    } else {
      // For other types, start with empty lists
      PatientBookingScreen.times1 = [];
      PatientBookingScreen.times = [];
    }
  }

  DateTime? startTime;
  DateTime? endTime;
  int date = 0;
  bool loading = false;
  int time = 0;
  String fr = DateFormat.EEEE().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text(
          "Select a Time Slot",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          size: 30,
          color: Colors.white,
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: widget.doc.img == ""
                            ? Image.asset(
                                "images/profile.gif",
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.network(
                                  widget.doc.img,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.doc.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              widget.doc.specialization,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "Fee: ${widget.doc.fees}",
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 80,
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 20,
                    ),
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            date = index;
                            setState(() {});
                            if (Constants.forSearch == "In-Clinic") {
                              print(DateTime.now()
                                  .add(Duration(days: date))
                                  .weekday);
                              print("heheh");
                              // For in-clinic, use fixed times without database fetch
                              PatientBookingScreen.times1 =
                                  _generateFixedTimeSlots(
                                      DateTime.now().add(Duration(days: date)));
                              PatientBookingScreen.times =
                                  _generateFixedTimeSlots(
                                      DateTime.now().add(Duration(days: date)));
                              setState(() {});
                            } else {
                              getTime(DateTime.now().add(Duration(days: date)));
                            }
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: date == index
                                  ? Colors.deepOrangeAccent.withOpacity(0.2)
                                  : Colors.white,
                              border: Border.all(
                                width: 1,
                                color: date == index
                                    ? Colors.deepOrangeAccent
                                    : Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 80),
                              margin: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                                right: 10,
                                bottom: 10,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "${index == 0 ? "Today" : DateFormat.EEEE().format(DateTime.now().add(Duration(days: index)))}",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.017,
                                      fontWeight: FontWeight.bold,
                                      color: date == index
                                          ? Colors.deepOrangeAccent
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "${(DateTime.now().day + index) > getDaysInMonth(DateTime.now().year, DateTime.now().month) ? (DateTime.now().day + index) % (getDaysInMonth(DateTime.now().year, DateTime.now().month)) : DateTime.now().day + index}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                      color: date == index
                                          ? Colors.deepOrangeAccent
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 20),
                    alignment: Alignment.bottomLeft,
                    child: const Text(
                      "Available Slots",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  loading == false
                      ? Container(
                          height: 410,
                          margin: const EdgeInsets.only(
                            top: 10,
                            left: 20,
                            right: 20,
                          ),
                          width: double.infinity,
                          child: PatientBookingScreen.times.isNotEmpty
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    mainAxisExtent: 40,
                                  ),
                                  itemCount: PatientBookingScreen.times.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        time = index;
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 5,
                                          bottom: 5,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 60,
                                          minHeight: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: time == index
                                              ? Colors.deepOrangeAccent
                                                  .withOpacity(0.2)
                                              : Colors.white,
                                          border: Border.all(
                                            width: 1,
                                            color: time == index
                                                ? Colors.deepOrangeAccent
                                                : Colors.grey.withOpacity(0.5),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            PatientBookingScreen
                                                .times[index].time,
                                            style: TextStyle(
                                              color: time == index
                                                  ? Colors.deepOrangeAccent
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.017,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  height: 410,
                                  child: const Center(
                                    child: Text("No Available Slots!"),
                                  ),
                                ),
                        )
                      : Container(
                          height: 420,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.deepOrangeAccent,
                            ),
                          ),
                        ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 20,
                    ),
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        const Icon(Icons.access_time),
                        const SizedBox(width: 10),
                        PatientBookingScreen.times.isNotEmpty
                            ? Text(
                                "${(DateTime.now().day + date) > getDaysInMonth(DateTime.now().year, DateTime.now().month) ? DateFormat.MMM().format(DateTime.now().add(Duration(days: 10))) : DateFormat.MMM().format(DateTime.now())} ${(DateTime.now().day + date) >= getDaysInMonth(DateTime.now().year, DateTime.now().month) + 1 ? (DateTime.now().day + date) % (getDaysInMonth(DateTime.now().year, DateTime.now().month)) : DateTime.now().day + date}, ${PatientBookingScreen.times[time].time}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      right: 10,
                      left: 10,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: PatientBookingScreen.times.isNotEmpty
                            ? Colors.deepOrangeAccent
                            : Colors.deepOrangeAccent.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () async {
                        var booked = 0;
                        if (PatientBookingScreen.times.isNotEmpty) {
                          var dates =
                              "${(DateTime.now().day + date) > getDaysInMonth(DateTime.now().year, DateTime.now().month) ? DateFormat.MMM().format(DateTime.now().add(Duration(days: 10))) : DateFormat.MMM().format(DateTime.now())} ${(DateTime.now().day + date) >= getDaysInMonth(DateTime.now().year, DateTime.now().month) + 1 ? (DateTime.now().day + date) % (getDaysInMonth(DateTime.now().year, DateTime.now().month)) : DateTime.now().day + date}, ${PatientBookingScreen.times[time].time} ";
                          print(dates);
                          DatabaseReference ref =
                              FirebaseDatabase.instance.ref("Requests");
                          final data = await ref.get();
                          if (data.exists) {
                            Map<dynamic, dynamic> ins =
                                data.value as Map<dynamic, dynamic>;

                            ins.forEach((key, value) {
                              print(value['date']);
                              print("here");
                              print(booked);
                              if (value['date'].toString().contains(dates) &&
                                  value['doc'] == widget.doc.name) {
                                Fluttertoast.showToast(
                                  msg: "Slot Already Booked!",
                                );
                                booked++;
                                print(value['date']);
                                print("here");
                                print(booked);
                                setState(() {});
                              }
                            });
                            if (booked == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PatientConfirmBookingScreen(
                                    doc: widget.doc.name,
                                    fees: widget.doc.fees,
                                    month: (DateTime.now().day + date) >
                                            getDaysInMonth(DateTime.now().year,
                                                DateTime.now().month)
                                        ? DateFormat.MMM().format(DateTime.now()
                                            .add(Duration(days: 15)))
                                        : DateFormat.MMM()
                                            .format(DateTime.now()),
                                    date: (DateTime.now().day + date) >
                                            getDaysInMonth(DateTime.now().year,
                                                DateTime.now().month)
                                        ? ((DateTime.now().day + date) %
                                                getDaysInMonth(
                                                    DateTime.now().year,
                                                    DateTime.now().month))
                                            .toString()
                                        : (DateTime.now().day + date)
                                            .toString(),
                                    time: PatientBookingScreen.times[time].time,
                                    index: widget.index,
                                    docs: widget.doc,
                                  ),
                                ),
                              );
                            }
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PatientConfirmBookingScreen(
                                  doc: widget.doc.name,
                                  fees: widget.doc.fees,
                                  month: (DateTime.now().day + date) >
                                          getDaysInMonth(DateTime.now().year,
                                              DateTime.now().month)
                                      ? DateFormat.MMM().format(DateTime.now()
                                          .add(Duration(days: 15)))
                                      : DateFormat.MMM().format(DateTime.now()),
                                  date: (DateTime.now().day + date) >
                                          getDaysInMonth(DateTime.now().year,
                                              DateTime.now().month)
                                      ? ((DateTime.now().day + date) %
                                              getDaysInMonth(
                                                  DateTime.now().year,
                                                  DateTime.now().month))
                                          .toString()
                                      : (DateTime.now().day + date).toString(),
                                  time: PatientBookingScreen.times[time].time,
                                  index: widget.index,
                                  docs: widget.doc,
                                ),
                              ),
                            );
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please Select Time Slot First!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: CupertinoColors.systemOrange,
                              textColor: CupertinoColors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: const Text("Book Appointment"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<eveningslots> _generateFixedTimeSlots(DateTime selectedDate) {
    loading == true;
    setState(() {});
    // Check if selected date is Saturday (6) or Sunday (7)
    if (selectedDate.weekday == DateTime.saturday ||
        selectedDate.weekday == DateTime.sunday) {
      return []; // Return empty list for weekends
    }

    // Fixed working hours for in-clinic appointments (9 AM to 5 PM)
    DateTime startTime = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, 9, 0); // 9:00 AM
    DateTime endTime = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, 17, 0); // 5:00 PM
    print("here");
    // Generate all possible slots (30 minutes each)
    List<eveningslots> slots = [];
    DateFormat slotFormat = DateFormat('h:mm a');

    while (startTime.isBefore(endTime)) {
      slots.add(eveningslots(time: slotFormat.format(startTime)));
      startTime = startTime.add(const Duration(minutes: 30));
    }
    loading == false;
    setState(() {});
    return slots;
  }

  void getTime(DateTime selectedDate) async {
    PatientBookingScreen.times.clear();
    loading = true;
    setState(() {});

    try {
      // Original implementation for non-in-clinic appointments
      final ref = FirebaseDatabase.instance
          .ref("Psychiatrists")
          .child(widget.doc.uid.toString());
      final data = await ref.get();

      final ins = data.value as Map<dynamic, dynamic>?;
      if (ins == null) {
        print("No psychiatrist data found");
        loading = false;
        setState(() {});
        return;
      }

      final availability = ins['availability'];
      if (availability == null) {
        print("No availability data found");
        loading = false;
        setState(() {});
        return;
      }

      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      if (!availability.containsKey(formattedDate)) {
        print("No availability for selected date: $formattedDate");
        loading = false;
        setState(() {});
        return;
      }

      // 2. Get working hours
      String startTimeString = availability[formattedDate]['start_time'];
      String endTimeString = availability[formattedDate]['end_time'];

      List<String> startParts = startTimeString.split(':');
      List<String> endParts = endTimeString.split(':');

      DateTime startTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        int.parse(startParts[0]),
        int.parse(startParts[1]),
      );
      DateTime endTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        int.parse(endParts[0]),
        int.parse(endParts[1]),
      );

      if (!startTime.isBefore(endTime)) {
        print("Invalid time range");
        loading = false;
        setState(() {});
        return;
      }

      // 3. Generate all possible slots
      List<String> allSlots = [];
      DateFormat slotFormat = DateFormat('HH:mm');

      while (startTime.isBefore(endTime)) {
        allSlots.add(slotFormat.format(startTime));
        startTime = startTime.add(Duration(minutes: 30));
      }

      // 4. Fetch existing appointments
      final requestsSnapshot =
          await FirebaseDatabase.instance.ref("Requests").get();
      Set<String> bookedSlots = {};

      if (requestsSnapshot.exists) {
        final requests =
            Map<dynamic, dynamic>.from(requestsSnapshot.value as Map);

        for (var entry in requests.entries) {
          final data = Map<String, dynamic>.from(entry.value);

          if (data['doc']?.toString().trim().toLowerCase() ==
              widget.doc.name.trim().toLowerCase()) {
            try {
              // Parse the stored date string
              String storedDate = data['date'] ?? '';
              if (storedDate.isEmpty) continue;

              DateTime appointmentDate;

              // Try parsing both possible formats
              try {
                appointmentDate = DateFormat('MMM d, h:mm a').parse(storedDate);
              } catch (e) {
                try {
                  appointmentDate =
                      DateFormat('yyyy-MM-dd HH:mm').parse(storedDate);
                } catch (e) {
                  print("Couldn't parse date: $storedDate");
                  continue;
                }
              }

              // Check if appointment is on selected date
              if (DateFormat('yyyy-MM-dd').format(appointmentDate) ==
                  formattedDate) {
                String slotTime = DateFormat('HH:mm').format(appointmentDate);
                bookedSlots.add(slotTime);
              }
            } catch (e) {
              print("Error parsing appointment: $e");
            }
          }
        }
      }

      // 5. Filter out booked slots
      List<String> availableSlots =
          allSlots.where((slot) => !bookedSlots.contains(slot)).toList();

      // 6. Update UI
      PatientBookingScreen.times.clear();
      for (var slot in availableSlots) {
        PatientBookingScreen.times.add(
          eveningslots(time: slot),
        );
      }

      loading = false;
      setState(() {});
      print("Available slots: ${availableSlots.length}");
    } catch (e) {
      loading = false;
      setState(() {});
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error fetching time slots: ${e.toString()}")));
    }
  }

  int getDaysInMonth(int year, int month) {
    DateTime firstDayOfNextMonth =
        (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);
    DateTime lastDayOfCurrentMonth =
        firstDayOfNextMonth.subtract(const Duration(days: 1));
    return lastDayOfCurrentMonth.day;
  }
}

class eveningslots {
  String time;
  eveningslots({
    required this.time,
  });
}
