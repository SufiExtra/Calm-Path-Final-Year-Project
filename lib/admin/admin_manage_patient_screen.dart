import 'package:flutter/material.dart';
import 'package:mind_guide_ui/admin/admin_delete_patients.dart';
import 'package:mind_guide_ui/signup_screen.dart';

class AdminManagePatientScreen extends StatefulWidget {
  const AdminManagePatientScreen({super.key});

  @override
  State<AdminManagePatientScreen> createState() =>
      _AdminManagePatientScreenState();
}

class _AdminManagePatientScreenState extends State<AdminManagePatientScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          "Manage Patients",
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupScreen(),
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.deepOrangeAccent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(
                    18,
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  children: [
                    Image.asset(
                      "images/add_patients.gif",
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Text(
                      "Add Patients",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminDeletePatients(),
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.deepOrangeAccent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(
                    18,
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  children: [
                    Image.asset(
                      "images/edit_patients.gif",
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Text(
                      "Delete Patients",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
