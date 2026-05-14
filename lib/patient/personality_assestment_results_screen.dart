import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PersonalityAssestmentResultsScreen extends StatefulWidget {
  const PersonalityAssestmentResultsScreen({super.key});

  @override
  State<PersonalityAssestmentResultsScreen> createState() =>
      _PersonalityAssestmentResultsScreenState();
}

class _PersonalityAssestmentResultsScreenState
    extends State<PersonalityAssestmentResultsScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final database = FirebaseDatabase.instance;

  List<Map<String, dynamic>> personalityEntries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllPersonalityResults();
  }

  Future<void> fetchAllPersonalityResults() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    final ref = database.ref("personality").child(uid);
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;

      List<Map<String, dynamic>> tempList = [];

      data.forEach((key, value) {
        final item = Map<String, dynamic>.from(value);
        // item['timestamp_key'] =
        //     key; // optional: useful for debugging or deletion
        tempList.add(item);
      });

      // Sort manually in descending order (latest first)
      tempList.sort((a, b) {
        final aTime = int.tryParse(a['timestamp'].toString()) ?? 0;
        final bTime = int.tryParse(b['timestamp'].toString()) ?? 0;
        return bTime.compareTo(aTime);
      });

      setState(() {
        personalityEntries = tempList;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildPersonalityCard(Map<String, dynamic> data) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...data.entries.map((entry) {
              if (entry.key == 'timestamp') {
                final timestamp = int.tryParse(entry.value.toString()) ?? 0;
                final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
                final formattedDate =
                    "${dateTime.day.toString().padLeft(2, '0')}-"
                    "${dateTime.month.toString().padLeft(2, '0')}-"
                    "${dateTime.year} "
                    "${dateTime.hour.toString().padLeft(2, '0')}:"
                    "${dateTime.minute.toString().padLeft(2, '0')} ";

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Text(
                          "Date:",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        "${entry.key}:",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        entry.value.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        title: const Text(
          'Personality Assessment Results',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          size: 30,
          color: Colors.white,
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.deepOrangeAccent,
            ))
          : personalityEntries.isEmpty
              ? const Center(child: Text("No results found."))
              : ListView.builder(
                  itemCount: personalityEntries.length,
                  itemBuilder: (context, index) {
                    return buildPersonalityCard(personalityEntries[index]);
                  },
                ),
    );
  }
}
