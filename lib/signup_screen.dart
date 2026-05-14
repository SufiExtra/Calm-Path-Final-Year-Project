import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mind_guide_ui/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  String? name;
  String? email;
  String? number;
  String? password;
  String? confirm_password;
  bool p = true;
  bool cp = true;

  // Validation variables
  bool nameValid = true;
  bool numberValid = true;
  bool emailValid = true;
  bool passwordValid = true;
  bool confirmPasswordValid = true;

  // Error messages
  String nameError = '';
  String numberError = '';
  String emailError = '';
  String passwordError = '';
  String confirmPasswordError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          "Signup",
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
                  top: 40,
                ),
                child: Image.asset(
                  "images/signup.gif",
                  width: 120,
                  height: 120,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        name = value;
                        if (value.isEmpty) {
                          nameValid = true;
                          nameError = '';
                        } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                          nameValid = false;
                          nameError = 'Only letters (a-z, A-Z) are allowed';
                        } else if (value.length < 3) {
                          nameValid = false;
                          nameError = 'Name must be at least 3 characters';
                        } else {
                          nameValid = true;
                          nameError = '';
                        }
                        setState(() {});
                      },
                      cursorColor: Colors.deepOrangeAccent,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                          borderSide: BorderSide(
                            color: nameValid
                                ? Colors.deepOrangeAccent
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                          borderSide: BorderSide(
                            color: nameValid
                                ? Colors.deepOrangeAccent
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        hintText: "ABC DEF",
                        labelText: "Name",
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                    if (!nameValid && nameError.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          nameError,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        number = value;
                        if (value.isEmpty) {
                          numberValid = true;
                          numberError = '';
                        } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          numberValid = false;
                          numberError = 'Only digits (0-9) are allowed';
                        } else if (value.length != 11) {
                          numberValid = false;
                          numberError = 'Number must be 11 digits';
                        } else {
                          numberValid = true;
                          numberError = '';
                        }
                        setState(() {});
                      },
                      cursorColor: Colors.deepOrangeAccent,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                          borderSide: BorderSide(
                            color: numberValid
                                ? Colors.deepOrangeAccent
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                          borderSide: BorderSide(
                            color: numberValid
                                ? Colors.deepOrangeAccent
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        hintText: "03** *******",
                        labelText: "Phone Number",
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                    if (!numberValid && numberError.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          numberError,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                        if (value.isEmpty) {
                          emailValid = true;
                          emailError = '';
                        } else if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                            .hasMatch(value)) {
                          emailValid = false;
                          emailError = 'Enter a valid email address';
                        } else {
                          emailValid = true;
                          emailError = '';
                        }
                        setState(() {});
                      },
                      cursorColor: Colors.deepOrangeAccent,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                          borderSide: BorderSide(
                            color: emailValid
                                ? Colors.deepOrangeAccent
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                          borderSide: BorderSide(
                            color: emailValid
                                ? Colors.deepOrangeAccent
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        hintText: "abc123@gmail.com",
                        labelText: "Email Address",
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                    if (!emailValid && emailError.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          emailError,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (value) {
                        password = value;
                        if (value.isEmpty) {
                          passwordValid = true;
                          passwordError = '';
                        } else if (value.length < 8) {
                          passwordValid = false;
                          passwordError =
                              'Password must be at least 8 characters';
                        } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          passwordValid = false;
                          passwordError =
                              'Include at least one uppercase letter';
                        } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                          passwordValid = false;
                          passwordError =
                              'Include at least one lowercase letter';
                        } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                          passwordValid = false;
                          passwordError = 'Include at least one number';
                        } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                            .hasMatch(value)) {
                          passwordValid = false;
                          passwordError =
                              'Include at least one special character';
                        } else {
                          passwordValid = true;
                          passwordError = '';
                        }
                        setState(() {});
                      },
                      obscureText: p,
                      cursorColor: Colors.deepOrangeAccent,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            p == true ? p = false : p = true;
                            setState(() {});
                          },
                          icon: Icon(
                            p == true ? Icons.visibility : Icons.visibility_off,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                          borderSide: BorderSide(
                            color: passwordValid
                                ? Colors.deepOrangeAccent
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                          borderSide: BorderSide(
                            color: passwordValid
                                ? Colors.deepOrangeAccent
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        hintText: "****************",
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                    if (!passwordValid && passwordError.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          passwordError,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (value) {
                        confirm_password = value;
                        if (value.isEmpty) {
                          confirmPasswordValid = true;
                          confirmPasswordError = '';
                        } else if (password != value) {
                          confirmPasswordValid = false;
                          confirmPasswordError = 'Passwords do not match';
                        } else {
                          confirmPasswordValid = true;
                          confirmPasswordError = '';
                        }
                        setState(() {});
                      },
                      obscureText: cp,
                      cursorColor: Colors.deepOrangeAccent,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            cp == true ? cp = false : cp = true;
                            setState(() {});
                          },
                          icon: Icon(
                            cp == true
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                          borderSide: BorderSide(
                            color: confirmPasswordValid
                                ? Colors.deepOrangeAccent
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                          borderSide: BorderSide(
                            color: confirmPasswordValid
                                ? Colors.deepOrangeAccent
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        hintText: "****************",
                        labelText: "Confirm Password",
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                    if (!confirmPasswordValid &&
                        confirmPasswordError.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          confirmPasswordError,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Already have an Account?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.deepOrangeAccent,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                    ),
                    side: BorderSide(
                      width: 1,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  onPressed: () async {
                    // Validate all fields before proceeding
                    bool allValid = true;

                    // Name validation
                    if (name == null || name!.isEmpty) {
                      nameValid = false;
                      nameError = 'Enter name first!';
                      allValid = false;
                    } else if (name!.length < 3) {
                      nameValid = false;
                      nameError = 'Name must be at least 3 characters';
                      allValid = false;
                    } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(name!)) {
                      nameValid = false;
                      nameError = 'Only letters (a-z, A-Z) are allowed';
                      allValid = false;
                    }

                    // Number validation
                    if (number == null || number!.isEmpty) {
                      numberValid = false;
                      numberError = 'Enter number first!';
                      allValid = false;
                    } else if (!RegExp(r'^[0-9]+$').hasMatch(number!)) {
                      numberValid = false;
                      numberError = 'Only digits (0-9) are allowed';
                      allValid = false;
                    } else if (number!.length != 11) {
                      numberValid = false;
                      numberError = 'Number must be 11 digits';
                      allValid = false;
                    }

                    // Email validation
                    if (email == null || email!.isEmpty) {
                      emailValid = false;
                      emailError = 'Enter email first!';
                      allValid = false;
                    } else if (!RegExp(
                            r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                        .hasMatch(email!)) {
                      emailValid = false;
                      emailError = 'Enter a valid email address';
                      allValid = false;
                    }

                    // Password validation
                    if (password == null || password!.isEmpty) {
                      passwordValid = false;
                      passwordError = 'Enter password first!';
                      allValid = false;
                    } else if (password!.length < 8) {
                      passwordValid = false;
                      passwordError = 'Password must be at least 8 characters';
                      allValid = false;
                    } else if (!RegExp(r'[A-Z]').hasMatch(password!)) {
                      passwordValid = false;
                      passwordError = 'Include at least one uppercase letter';
                      allValid = false;
                    } else if (!RegExp(r'[a-z]').hasMatch(password!)) {
                      passwordValid = false;
                      passwordError = 'Include at least one lowercase letter';
                      allValid = false;
                    } else if (!RegExp(r'[0-9]').hasMatch(password!)) {
                      passwordValid = false;
                      passwordError = 'Include at least one number';
                      allValid = false;
                    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                        .hasMatch(password!)) {
                      passwordValid = false;
                      passwordError = 'Include at least one special character';
                      allValid = false;
                    }

                    // Confirm password validation
                    if (confirm_password == null || confirm_password!.isEmpty) {
                      confirmPasswordValid = false;
                      confirmPasswordError = 'Enter confirm password first!';
                      allValid = false;
                    } else if (password != confirm_password) {
                      confirmPasswordValid = false;
                      confirmPasswordError = 'Passwords do not match';
                      allValid = false;
                    }

                    setState(() {});

                    if (!allValid) {
                      return;
                    }

                    loading = true;
                    setState(() {});

                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final DatabaseReference databaseRef =
                          FirebaseDatabase.instance.ref("patients");
                      bool userExistsInDatabase = false;
                      User? firebaseUser;

                      try {
                        // Step 1: Check if the user already exists in Authentication
                        try {
                          print("Trying to create user...");
                          UserCredential userCredential =
                              await auth.createUserWithEmailAndPassword(
                            email: email!,
                            password: password!,
                          );
                          firebaseUser = userCredential.user;
                          print(
                              "User created in authentication: ${firebaseUser!.uid}");
                        } on FirebaseAuthException catch (e) {
                          print(e.code);
                          if (e.code == 'email-already-in-use') {
                            print(
                                "User already exists in Authentication. Signing in...");
                            UserCredential existingUser =
                                await auth.signInWithEmailAndPassword(
                              email: email!,
                              password: password!,
                            );
                            firebaseUser = existingUser.user;
                          } else {
                            print("Firebase Auth Exception: ${e.message}");
                            Fluttertoast.showToast(
                                msg: "Error: ${e.message}",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor: CupertinoColors.systemOrange,
                                textColor: CupertinoColors.white,
                                fontSize: 16.0);
                            loading = false;
                            setState(() {});
                            return;
                          }
                        }

                        // Step 2: Check if user exists in Realtime Database
                        print("Checking if user exists in database...");
                        DataSnapshot snapshot = await databaseRef
                            .orderByChild('email')
                            .equalTo(email!)
                            .once()
                            .then((event) => event.snapshot);

                        if (snapshot.value != null) {
                          userExistsInDatabase = true;
                          print("User already exists in the database.");
                        } else {
                          print(
                              "User does not exist in the database. Adding user...");
                        }

                        // Step 3: If the user does not exist in the database, add them
                        if (!userExistsInDatabase) {
                          var patient = {
                            'name': name,
                            'number': number,
                            'email': email,
                            'patientid': firebaseUser!.uid,
                            'user': 'patient',
                          };
                          await databaseRef.push().set(patient);
                          print("User added to database successfully.");
                          Fluttertoast.showToast(
                              msg: "Patient registered successfully!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: CupertinoColors.systemOrange,
                              textColor: CupertinoColors.white,
                              fontSize: 16.0);
                        }
                        loading = false;
                        setState(() {});
                        Navigator.pop(context);
                      } catch (e) {
                        loading = false;
                        setState(() {});
                        print("Error: $e");
                        Fluttertoast.showToast(
                            msg: "Error: $e",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: CupertinoColors.systemOrange,
                            textColor: CupertinoColors.white,
                            fontSize: 16.0);
                      }
                    } catch (e) {
                      loading = false;
                      setState(() {});
                      print("Error: $e");
                      Fluttertoast.showToast(
                          msg: "Error: $e",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 3,
                          backgroundColor: CupertinoColors.systemOrange,
                          textColor: CupertinoColors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: loading == false
                      ? Text(
                          "Signup",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        )
                      : CircularProgressIndicator(
                          color: Colors.deepOrangeAccent,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
