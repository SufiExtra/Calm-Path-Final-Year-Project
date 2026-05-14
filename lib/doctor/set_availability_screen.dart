import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class SetAvailabilityScreen extends StatefulWidget {
  final String psychiatristId;

  SetAvailabilityScreen({required this.psychiatristId});

  @override
  _SetAvailabilityScreenState createState() => _SetAvailabilityScreenState();
}

class _SetAvailabilityScreenState extends State<SetAvailabilityScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<DateTime> selectedDates = [];
  Map<DateTime, Map<String, TimeOfDay?>> availability = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set Availability',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Calendar to select multiple dates
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(Duration(days: 365)),
              focusedDay: DateTime.now(),
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              selectedDayPredicate: (day) => selectedDates.contains(day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  if (selectedDates.contains(selectedDay)) {
                    selectedDates.remove(selectedDay);
                    availability.remove(selectedDay);
                  } else {
                    selectedDates.add(selectedDay);
                    availability[selectedDay] = {"start": null, "end": null};
                  }
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Display selected dates and set time range
            Expanded(
              child: ListView.builder(
                itemCount: selectedDates.length,
                itemBuilder: (context, index) {
                  DateTime date = selectedDates[index];
                  TimeOfDay? start = availability[date]?["start"];
                  TimeOfDay? end = availability[date]?["end"];

                  return Card(
                    child: ListTile(
                      // selectedColor: Colors.white,
                      // focusColor: Colors.white,
                      // hoverColor: Colors.white,
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.deepOrangeAccent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      title: Text(
                        DateFormat('yyyy-MM-dd').format(date),
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      subtitle: Text(
                        start == null || end == null
                            ? "Set time range"
                            : "Time: ${start.format(context)} - ${end.format(context)}",
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          selectedDates.remove(date);
                          availability.remove(date);
                          setState(() {});
                        },
                        child: Container(
                          child: Image.asset(
                            "images/delete.gif",
                          ),
                        ),
                      ),
                      onTap: () {
                        _pickTimeRange(context, date);
                      },
                    ),
                  );
                },
              ),
            ),

            // Save Availability to Firebase
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.deepOrangeAccent,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    width: 1,
                    color: Colors.deepOrangeAccent,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                  ),
                ),
                onPressed: () {
                  if (selectedDates.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Please select at least one date.")),
                    );
                    return;
                  }
                  _saveAvailability();
                },
                child: Text('Save Availability'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to pick start and end time for a specific date
  Future<void> _pickTimeRange(BuildContext context, DateTime date) async {
    TimeOfDay? pickedStart = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
    );

    if (pickedStart != null) {
      TimeOfDay? pickedEnd = await showTimePicker(
        context: context,
        initialTime: pickedStart.replacing(hour: pickedStart.hour + 1),
      );

      if (pickedEnd != null && _isAfter(pickedEnd, pickedStart)) {
        setState(() {
          availability[date] = {"start": pickedStart, "end": pickedEnd};
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('End time must be after start time!')),
        );
      }
    }
  }

  // Function to check if end time is after start time
  bool _isAfter(TimeOfDay end, TimeOfDay start) {
    return end.hour > start.hour ||
        (end.hour == start.hour && end.minute > start.minute);
  }

  // Function to save availability to Firebase Realtime Database
  Future<void> _saveAvailability() async {
    try {
      Map<String, dynamic> availabilityData = {};
      for (var date in selectedDates) {
        var start = availability[date]?["start"];
        var end = availability[date]?["end"];

        if (start != null && end != null) {
          availabilityData[DateFormat('yyyy-MM-dd').format(date)] = {
            "start_time": "${start.hour}:${start.minute}",
            "end_time": "${end.hour}:${end.minute}",
          };
        }
      }

      if (availabilityData.isNotEmpty) {
        await _database
            .child('Psychiatrists/${widget.psychiatristId}/availability')
            .set(availabilityData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Availability saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select time for all selected dates.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }
}
