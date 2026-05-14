import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mind_guide_ui/constants.dart';

import '../splash_screen.dart';

class AdminAddPsychiatrist extends StatefulWidget {
  const AdminAddPsychiatrist({super.key});

  @override
  State<AdminAddPsychiatrist> createState() => _AdminAddPsychiatristState();
}

class _AdminAddPsychiatristState extends State<AdminAddPsychiatrist> {
  ValueNotifier<double> uploadProgress = ValueNotifier<double>(0.0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(Constants.img);
  }

  OverlayEntry? overlayEntry;

  void showPersistentToast(BuildContext context) {
    final overlay = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 270,
        left: MediaQuery.of(context).size.width * 0.3,
        child: Material(
          color: Colors.transparent,
          child: ValueListenableBuilder<double>(
            valueListenable: uploadProgress,
            builder: (context, progress, child) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Uploading: ${(progress * 100).round()}%",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            },
          ),
        ),
      ),
    );
    overlay?.insert(overlayEntry!);
  }

  void removePersistentToast() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  final _formKey = GlobalKey<FormState>();

  String? img_url;
  bool loading = false;
  XFile? pickedFile;
  String img = (Constants.img == '' || Constants.img == null)
      ? "https://cdn-icons-png.flaticon.com/512/9203/9203764.png"
      : Constants.img.toString();
  final ImagePicker _picker = ImagePicker(); // Image picker instance
  String? name;
  String? disease;
  String avail = Constants.user ?? '';

  String? degree;
  String? number;
  String? experience;
  String? spec;
  String? time;
  String? place;
  String? email;
  String? pass;
  String? con_pass;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _diseaseController = TextEditingController();

  List<String> addresses = [];
  List<String> treatedDiseases = [];

  TextEditingController Name =
      TextEditingController(text: Constants.name ?? "");
  // TextEditingController Disease =
  //     TextEditingController(text: Constants.disease ?? "");
  TextEditingController Degree =
      TextEditingController(text: Constants.degree ?? "");
  TextEditingController Number =
      TextEditingController(text: Constants.number ?? "");
  TextEditingController Experience =
      TextEditingController(text: Constants.experience ?? "");
  TextEditingController Spec =
      TextEditingController(text: Constants.specialization ?? "");
  TextEditingController Time =
      TextEditingController(text: Constants.time ?? "");
  // TextEditingController Place =
  //     TextEditingController(text: Constants.place ?? "");
  TextEditingController Email =
      TextEditingController(text: Constants.email ?? "");

  @override
  Widget build(BuildContext context) {
    Future<String?> uploadImageToCloudinary(String filePath) async {
      img_url = null;
      uploadProgress.value = 0.0; // Reset progress

      setState(() {});
      const String cloudName =
          "dolvoltit"; // Replace with your Cloudinary cloud name
      const String apiKey =
          "148232698674769"; // Replace with your Cloudinary API key
      const String apiSecret =
          "V8OE85T_W70IbcBtl1bBO7Borwc"; // Replace with your Cloudinary API secret

      try {
        final cloudinary = Cloudinary.signedConfig(
          apiKey: apiKey,
          apiSecret: apiSecret,
          cloudName: cloudName,
        );
        showPersistentToast(context);

        var response = await cloudinary.upload(
          file: pickedFile!.path,
          // fileBytes: pickedFile!.readAsBytes(),
          resourceType: CloudinaryResourceType.auto,
          folder: "images",
          fileName: DateTime.now().microsecond.toString(),
          progressCallback: (count, total) {
            double progress = count / total;
            uploadProgress.value = progress; // Update progress in real time
            setState(() {});
          },
        );
        removePersistentToast();
        img_url = response.secureUrl;
        Constants.img = img_url;
        img = img_url!;
        setState(() {});
        print("secure url:${img_url}");

        Fluttertoast.showToast(
            msg: "Image Uploaded Successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.deepOrangeAccent,
            textColor: CupertinoColors.white,
            fontSize: 16.0);
      } catch (e) {
        print("Error uploading image: $e");
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.deepOrangeAccent,
            textColor: CupertinoColors.white,
            fontSize: 16.0);
        return null;
      }
      return null;
    }

    Future<void> _pickImage() async {
      showModalBottomSheet(
        context: context,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              tileColor: Colors.white,
              leading: Icon(Icons.photo_library),
              title: Text("Choose from Gallery"),
              onTap: () async {
                Navigator.pop(context); // Close the bottom sheet
                pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    img = pickedFile!.path; // Update image path
                    uploadImageToCloudinary(img);
                  });
                }
              },
            ),
            ListTile(
              tileColor: Colors.white,
              leading: Icon(Icons.camera_alt),
              title: Text("Take a Photo"),
              onTap: () async {
                Navigator.pop(context); // Close the bottom sheet
                pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);

                img = pickedFile!.path; // Update image path
                uploadImageToCloudinary(img);

                setState(() {});
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          Constants.name != null ? "Edit Information" : "Add Psychiatrist",
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: _pickImage,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: img.startsWith('https:')
                        ? Image.network(
                            img,
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(img),
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        avail = "In-Clinic";
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              30,
                            ),
                            bottomLeft: Radius.circular(
                              30,
                            ),
                          ),
                          border: Border.all(
                            width: 1,
                            color: avail == "In-Clinic"
                                ? Colors.deepOrangeAccent
                                : CupertinoColors.darkBackgroundGray,
                          ),
                          color: avail == "In-Clinic"
                              ? Colors.white
                              : Colors.grey.withOpacity(
                                  0.2,
                                ),
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.449,
                        child: Text(
                          "In-Clinic",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: avail == "In-Clinic"
                                ? Colors.deepOrangeAccent
                                : Colors.grey.withOpacity(
                                    0.9,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        avail = "Online";
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(
                              30,
                            ),
                            bottomRight: Radius.circular(
                              30,
                            ),
                          ),
                          border: Border.all(
                            width: 1,
                            color: avail == "Online"
                                ? Colors.deepOrangeAccent
                                : CupertinoColors.darkBackgroundGray,
                          ),
                          color: avail == "Online"
                              ? Colors.white
                              : Colors.grey.withOpacity(
                                  0.2,
                                ),
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.449,
                        child: Text(
                          textAlign: TextAlign.center,
                          "Online",
                          style: TextStyle(
                            color: avail == "Online"
                                ? Colors.deepOrangeAccent
                                : Colors.grey.withOpacity(
                                    0.9,
                                  ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: TextField(
                  controller: Name,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    name = value;
                    setState(() {});
                  },
                  cursorColor: Colors.deepOrangeAccent,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
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
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: TextField(
                  controller: Number,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    number = value;
                    setState(() {});
                  },
                  cursorColor: Colors.deepOrangeAccent,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    hintText: "03** *******",
                    labelText: "Number",
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                ),
              ),
              // Container(
              //   margin: EdgeInsets.only(
              //     top: 10,
              //     left: 20,
              //     right: 20,
              //   ),
              //   child: TextField(
              //     keyboardType: TextInputType.streetAddress,
              //     controller: Place,
              //     onChanged: (value) {
              //       place = value;
              //       setState(() {});
              //     },
              //     cursorColor: Colors.deepOrangeAccent,
              //     decoration: InputDecoration(
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(
              //           30,
              //         ),
              //         borderSide: BorderSide(
              //           color: Colors.deepOrangeAccent,
              //           width: 1,
              //         ),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(
              //           30,
              //         ),
              //         borderSide: BorderSide(
              //           color: Colors.deepOrangeAccent,
              //           width: 1,
              //         ),
              //       ),
              //       disabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(
              //           30,
              //         ),
              //         borderSide: BorderSide(
              //           color: Colors.deepOrangeAccent,
              //           width: 1,
              //         ),
              //       ),
              //       hintText: "Office, Apartment, City",
              //       labelText: "Office",
              //       labelStyle: TextStyle(
              //         fontSize: 16,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.deepOrangeAccent,
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 20,
                  right: 10,
                ),
                child: _buildDynamicInputSection(
                  controller: _addressController,
                  hint: "Add new address",
                  onAdd: () {
                    if (_addressController.text.isNotEmpty) {
                      setState(() {
                        addresses.add(_addressController.text);
                        _addressController.clear();
                      });
                    }
                  },
                  items: addresses,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 20,
                  right: 10,
                ),
                child: _buildDynamicInputSection(
                  controller: _diseaseController,
                  hint: "Add Treated disease",
                  onAdd: () {
                    if (_diseaseController.text.isNotEmpty) {
                      setState(() {
                        treatedDiseases.add(_diseaseController.text);
                        _diseaseController.clear();
                      });
                    }
                  },
                  items: treatedDiseases,
                ),
              ),

              // Container(
              //   margin: EdgeInsets.only(
              //     top: 10,
              //     left: 20,
              //     right: 20,
              //   ),
              //   child: TextField(
              //     controller: Disease,
              //     keyboardType: TextInputType.text,
              //     onChanged: (value) {
              //       disease = value;
              //       setState(() {});
              //     },
              //     cursorColor: Colors.deepOrangeAccent,
              //     decoration: InputDecoration(
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(
              //           30,
              //         ),
              //         borderSide: BorderSide(
              //           color: Colors.deepOrangeAccent,
              //           width: 1,
              //         ),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(
              //           30,
              //         ),
              //         borderSide: BorderSide(
              //           color: Colors.deepOrangeAccent,
              //           width: 1,
              //         ),
              //       ),
              //       disabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(
              //           30,
              //         ),
              //         borderSide: BorderSide(
              //           color: Colors.deepOrangeAccent,
              //           width: 1,
              //         ),
              //       ),
              //       hintText: "Depression, Anxiety, ...",
              //       labelText: "Treated Disease",
              //       labelStyle: TextStyle(
              //         fontSize: 16,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.deepOrangeAccent,
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: Experience,
                  onChanged: (value) {
                    experience = value;
                    setState(() {});
                  },
                  cursorColor: Colors.deepOrangeAccent,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    hintText: "** years in numbers",
                    labelText: "Experience",
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: Time,
                  onChanged: (value) {
                    time = value;
                    setState(() {});
                  },
                  cursorColor: Colors.deepOrangeAccent,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    hintText: "Time for response",
                    labelText: "Time",
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: Degree,
                  onChanged: (value) {
                    degree = value;
                    setState(() {});
                  },
                  cursorColor: Colors.deepOrangeAccent,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    hintText: "MBBS etc etc",
                    labelText: "Degree",
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: Spec,
                  onChanged: (value) {
                    spec = value;
                    setState(() {});
                  },
                  cursorColor: Colors.deepOrangeAccent,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    hintText: "Specialization in psychology",
                    labelText: "Specialization",
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: TextField(
                  enabled: Constants.name == null ? true : false,
                  keyboardType: TextInputType.emailAddress,
                  controller: Email,
                  onChanged: (value) {
                    email = value;
                    setState(() {});
                  },
                  cursorColor: Colors.deepOrangeAccent,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                        width: 1,
                      ),
                    ),
                    hintText: "abc@gmail.com",
                    labelText: "Email",
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                ),
              ),
              Constants.name == null
                  ? Container(
                      margin: EdgeInsets.only(
                        top: 10,
                        left: 20,
                        right: 20,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          pass = value;
                          setState(() {});
                        },
                        cursorColor: Colors.deepOrangeAccent,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            borderSide: BorderSide(
                              color: Colors.deepOrangeAccent,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            borderSide: BorderSide(
                              color: Colors.deepOrangeAccent,
                              width: 1,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            borderSide: BorderSide(
                              color: Colors.deepOrangeAccent,
                              width: 1,
                            ),
                          ),
                          hintText: "*******************",
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Constants.name == null
                  ? Container(
                      margin: EdgeInsets.only(
                        top: 10,
                        left: 20,
                        right: 20,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          con_pass = value;
                          setState(() {});
                        },
                        cursorColor: Colors.deepOrangeAccent,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            borderSide: BorderSide(
                              color: Colors.deepOrangeAccent,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            borderSide: BorderSide(
                              color: Colors.deepOrangeAccent,
                              width: 1,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            borderSide: BorderSide(
                              color: Colors.deepOrangeAccent,
                              width: 1,
                            ),
                          ),
                          hintText: "***********************",
                          labelText: "Confirm Password",
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Constants.name != null
                  ? Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(
                        top: 10,
                        left: 20,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_forever_rounded,
                            color: Colors.deepOrangeAccent,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () async {
                              print("tap");
                              FirebaseAuth auth = FirebaseAuth.instance;
                              showAlertDialog(context, auth.currentUser!.uid);
                            },
                            child: Container(
                              height: 22,
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "Delete my account",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
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
                    loading = true;
                    setState(() {});
                    if (Constants.name == null) {
                      Constants.place = addresses;
                      Constants.disease = treatedDiseases;
                      setState(() {});
                      if (name == null) {
                        loading = false;
                        setState(() {});
                        Fluttertoast.showToast(
                            msg: "Enter name first!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: CupertinoColors.systemOrange,
                            textColor: CupertinoColors.white,
                            fontSize: 16.0);
                      } else if (number == null) {
                        loading = false;
                        setState(() {});
                        Fluttertoast.showToast(
                            msg: "Enter number first!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: CupertinoColors.systemOrange,
                            textColor: CupertinoColors.white,
                            fontSize: 16.0);
                      } else if (number!.length != 11) {
                        loading = false;
                        setState(() {});
                        Fluttertoast.showToast(
                            msg: "Number should be 11 digits long!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: CupertinoColors.systemOrange,
                            textColor: CupertinoColors.white,
                            fontSize: 16.0);
                      } else if (addresses.isEmpty) {
                        loading = false;
                        setState(() {});
                        Fluttertoast.showToast(
                            msg: "Enter Office Address first!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: CupertinoColors.systemOrange,
                            textColor: CupertinoColors.white,
                            fontSize: 16.0);
                      } else if (experience == null) {
                        loading = false;
                        setState(() {});
                        Fluttertoast.showToast(
                            msg: "Enter Experience first!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: CupertinoColors.systemOrange,
                            textColor: CupertinoColors.white,
                            fontSize: 16.0);
                      } else if (time == null) {
                        loading = false;
                        setState(() {});
                        Fluttertoast.showToast(
                            msg: "Enter Time of reply first!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: CupertinoColors.systemOrange,
                            textColor: CupertinoColors.white,
                            fontSize: 16.0);
                      } else if (degree == null) {
                        loading = false;
                        setState(() {});
                        Fluttertoast.showToast(
                            msg: "Enter Degree first!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: CupertinoColors.systemOrange,
                            textColor: CupertinoColors.white,
                            fontSize: 16.0);
                      } else if (spec == null) {
                        loading = false;
                        setState(() {});
                        Fluttertoast.showToast(
                            msg: "Enter Specialization first!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: CupertinoColors.systemOrange,
                            textColor: CupertinoColors.white,
                            fontSize: 16.0);
                      } else if (email == null) {
                        loading = false;
                        setState(() {});
                        Fluttertoast.showToast(
                            msg: "Enter Email first!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: CupertinoColors.systemOrange,
                            textColor: CupertinoColors.white,
                            fontSize: 16.0);
                      } else if (!email!.contains("@gmail.com")) {
                        loading = false;
                        setState(() {});
                        Fluttertoast.showToast(
                            msg: "Email should have @gmail.com in it!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: CupertinoColors.systemOrange,
                            textColor: CupertinoColors.white,
                            fontSize: 16.0);
                      } else if (pass == null) {
                        loading = false;
                        setState(() {});
                        Fluttertoast.showToast(
                            msg: "Enter Password first!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: CupertinoColors.systemOrange,
                            textColor: CupertinoColors.white,
                            fontSize: 16.0);
                      } else if (con_pass == null) {
                        loading = false;
                        setState(() {});
                        Fluttertoast.showToast(
                            msg: "Enter Confirm Password first!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: CupertinoColors.systemOrange,
                            textColor: CupertinoColors.white,
                            fontSize: 16.0);
                      } else if (pass != con_pass) {
                        loading = false;
                        setState(() {});
                        Fluttertoast.showToast(
                            msg: "Both Password fields should be Equal!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: CupertinoColors.systemOrange,
                            textColor: CupertinoColors.white,
                            fontSize: 16.0);
                      } else {
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
                              password: pass!,
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
                                password: pass!,
                              );
                              firebaseUser = existingUser.user;
                            } else {
                              print("Firebase Auth Exception: ${e.message}");
                              return;
                            }
                          }

                          // Step 2: Check if user exists in Realtime Database
                          print("Checking if user exists in database...");
                          DataSnapshot snapshot = await databaseRef
                              .orderByChild('email')
                              .equalTo(email!)
                              .ref
                              .get();
                          Map<dynamic, dynamic> d =
                              snapshot.value as Map<dynamic, dynamic>;
                          print(d['email']);
                          if (d['email'] != null) {
                            userExistsInDatabase = true;
                            print("User already exists in the database.");
                          } else {
                            print(
                                "User does not exist in the database. Adding user...");
                          }

                          // Step 3: If the user does not exist in the database, add them
                          if (!userExistsInDatabase) {
                            var doctor = {
                              'name': name,
                              'number': number,
                              'place': addresses,
                              'experience': experience,
                              'time': time,
                              'degree': degree,
                              'specialization': spec,
                              'email': email,
                              'patientid': firebaseUser!.uid,
                              'user': avail,
                              'img': img_url,
                              'disease': treatedDiseases,
                            };
                            await databaseRef.push().set(doctor);
                            print("User added to database successfully.");
                            Fluttertoast.showToast(
                                msg:
                                    "Psychiatrist added to database successfully!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor: CupertinoColors.systemOrange,
                                textColor: CupertinoColors.white,
                                fontSize: 16.0);
                          }
                          loading = false;
                          setState(() {});
                        } catch (e) {
                          loading = false;
                          setState(() {});
                          print("Error: $e");
                        }

                        Navigator.pop(context);
                        loading = false;
                        setState(() {});
                      }
                    } else {
                      update_profile();
                    }
                  },
                  child: loading == false
                      ? Text(
                          Constants.name == null
                              ? "Add Psychiatrist"
                              : "Update Profile",
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

  update_profile() async {
    loading = true;
    setState(() {});
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      DatabaseReference ref = FirebaseDatabase.instance.ref("patients");
      DatabaseEvent event = await ref
          .orderByChild('patientid')
          .equalTo(auth.currentUser!.uid)
          .once();
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> patients =
            event.snapshot.value as Map<dynamic, dynamic>;
        patients.forEach((key, value) async {
          await ref.child(key).update({
            'name': Name.text.trim(),
            'number': Number.text.trim(),
            'place': addresses,
            'experience': Experience.text.trim(),
            'time': Time.text.trim(),
            'degree': Degree.text.trim(),
            'specialization': Spec.text.trim(),
            // 'email': email,
            // 'patientid': firebaseUser!.uid,
            'user': avail,
            'img': img,
            'disease': treatedDiseases,
          });
          Constants.name = Name.text;
          // Constants.disease = Disease.text;

          Constants.number = Number.text;
          Constants.email = Email.text;
          Constants.img = img;
          // Constants.place = Place.text;
          Constants.time = Time.text;
          Constants.experience = Experience.text;
          Constants.specialization = Spec.text;
          Constants.degree = Degree.text;
          Constants.disease = treatedDiseases;
          Constants.place = addresses;

          Fluttertoast.showToast(
              msg: "Account updated successfully!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.orange,
              textColor: Colors.white,
              fontSize: 16.0);
          print(
              "Patient with ID ${auth.currentUser!.uid} updated successfully.");
        });
        loading = false;
        setState(() {});
      } else {
        loading = false;
        setState(() {});
        Fluttertoast.showToast(
            msg: "User not Found!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      loading = false;
      setState(() {});
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  showAlertDialog(BuildContext context, String patientId) {
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
          // psyco.removeAt(index);
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
              print("Psychiatrist with ID $patientId removed successfully.");
            });
          } else {
            print("No Psychiatrist found with ID: $patientId");
          }
          FirebaseAuth auth = FirebaseAuth.instance;
          auth.signOut();
          Fluttertoast.showToast(
              msg: "Account Deleted Successfully!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.orange,
              textColor: Colors.white,
              fontSize: 16.0);

          setState(() {});
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SplashScreen(),
            ),
          );
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
      content: Text("Do you want to Delete your Account?"),
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

  Widget _buildDynamicInputSection({
    required TextEditingController controller,
    required String hint,
    required Function() onAdd,
    required List<String> items,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                cursorColor: Colors.deepOrangeAccent,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                    borderSide: BorderSide(
                      color: Colors.deepOrangeAccent,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                    borderSide: BorderSide(
                      color: Colors.deepOrangeAccent,
                      width: 1,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                    borderSide: BorderSide(
                      color: Colors.deepOrangeAccent,
                      width: 1,
                    ),
                  ),
                  hintText: hint,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.add_circle,
                size: 40,
                color: Colors.deepOrangeAccent,
              ),
              onPressed: onAdd,
            ),
          ],
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map((item) => Chip(
                    backgroundColor: Colors.deepOrangeAccent.withOpacity(
                      0.1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    side: BorderSide(
                      width: 1,
                      color: Colors.deepOrangeAccent,
                    ),
                    label: Text(
                      item,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    deleteIcon: Icon(
                      Icons.close,
                      color: Colors.deepOrangeAccent,
                      size: 18,
                    ),
                    onDeleted: () {
                      setState(() {
                        items.remove(item);
                      });
                    },
                  ))
              .toList(),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
