import 'package:flutter/material.dart';
import 'package:mind_guide_ui/admin/admin_add_psychiatrist.dart';
import 'package:mind_guide_ui/admin/admin_delete_pschiatrist.dart';
import 'package:mind_guide_ui/constants.dart';

class AdminManagePsychiatrist extends StatefulWidget {
  const AdminManagePsychiatrist({super.key});

  @override
  State<AdminManagePsychiatrist> createState() =>
      _AdminManagePsychiatristState();
}

class _AdminManagePsychiatristState extends State<AdminManagePsychiatrist> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Constants.name = null;
    Constants.number = null;
    Constants.email = null;
    Constants.img = null;
    Constants.place = null;
    Constants.time = null;
    Constants.experience = null;
    Constants.specialization = null;
    Constants.degree = null;
    Constants.disease = null;
    Constants.user = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          "Manage Psychiatrist",
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
                    builder: (context) => AdminAddPsychiatrist(),
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
                      "images/add_doc.gif",
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Text(
                      "Add Psychiatrist",
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
                    builder: (context) => AdminDeletePschiatrist(),
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
                      "images/delete_doc.gif",
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Text(
                      "Delete Psychiatrist",
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
