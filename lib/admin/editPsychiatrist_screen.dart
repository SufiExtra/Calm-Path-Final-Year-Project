import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditPsychiatristScreen extends StatefulWidget {
  final String psychiatristId;

  EditPsychiatristScreen({required this.psychiatristId});

  @override
  _EditPsychiatristScreenState createState() => _EditPsychiatristScreenState();
}

class _EditPsychiatristScreenState extends State<EditPsychiatristScreen> {
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('patients');

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String profileImageUrl = '';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPsychiatristData();
  }

  void _loadPsychiatristData() async {
    DatabaseEvent snapshot =
        await _databaseRef.child(widget.psychiatristId).once();

    if (snapshot.snapshot.value != null) {
      Map<dynamic, dynamic> data =
          snapshot.snapshot.value as Map<dynamic, dynamic>;

      setState(() {
        firstNameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneNumberController.text = data['number'] ?? '';
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updatePsychiatristData() {
    _databaseRef.child(widget.psychiatristId).update({
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'city': cityController.text,
      'email': emailController.text,
      'phoneNumber': phoneNumberController.text,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Psychiatrist updated successfully!')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update data: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0064FA),
        title: Text('Edit Psychiatrist'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : AssetImage('images/profile.gif') as ImageProvider,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: firstNameController,
                      decoration: InputDecoration(labelText: 'First Name'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: lastNameController,
                      decoration: InputDecoration(labelText: 'Last Name'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: cityController,
                      decoration: InputDecoration(labelText: 'City'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updatePsychiatristData,
                      child: Text('Update Psychiatrist'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff0064FA),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
