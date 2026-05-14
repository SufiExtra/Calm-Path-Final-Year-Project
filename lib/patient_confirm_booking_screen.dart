import 'package:flutter/material.dart';
import 'package:mind_guide_ui/constants.dart';
import 'package:mind_guide_ui/patient_search_screen.dart';
import 'package:mind_guide_ui/patient_select_payment_method_screen.dart';

class PatientConfirmBookingScreen extends StatefulWidget {
  psychiatrist docs;

  int index;
  String doc;
  String time;
  String month;
  String date;
  String fees;
  PatientConfirmBookingScreen({
    super.key,
    required this.time,
    required this.fees,
    required this.date,
    required this.doc,
    required this.month,
    required this.index,
    required this.docs,
  });

  @override
  State<PatientConfirmBookingScreen> createState() =>
      _PatientConfirmBookingScreenState();
}

class _PatientConfirmBookingScreenState
    extends State<PatientConfirmBookingScreen> {
  String gender = "male";
  TextEditingController name = TextEditingController(
    text: Constants.name,
  );
  TextEditingController number = TextEditingController(
    text: Constants.number,
  );
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          "Confirm Booking",
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
        color: Colors.deepOrangeAccent.withOpacity(
          0.1,
        ),
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 20,
                  ),
                  width: width,
                  height: height * 0.38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          left: 20,
                        ),
                        width: width,
                        child: Text(
                          "Personal Details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.025,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 5,
                          left: 20,
                        ),
                        width: width,
                        child: Text(
                          "We share this information with the doctor",
                          style: TextStyle(
                            fontSize: height * 0.015,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: Divider(),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          left: 20,
                          right: 20,
                        ),
                        child: TextField(
                          controller: name,
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            hintText: "ABC DEF",
                            labelText: "Patient's Name",
                            labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
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
                          controller: number,
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            hintText: "Number eg:03** *******",
                            labelText: "Phone Number",
                            labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
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
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Gender",
                          style: TextStyle(
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          left: 20,
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                gender = "male";
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: 5,
                                  left: 5,
                                  right: 5,
                                  bottom: 5,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: gender == "male" ? 1 : 0,
                                    color: gender == "male"
                                        ? Colors.deepOrangeAccent
                                        : Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                  color: gender == "male"
                                      ? Colors.deepOrangeAccent.withOpacity(
                                          0.1,
                                        )
                                      : Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: gender == "male"
                                          ? Colors.deepOrangeAccent
                                          : Colors.transparent,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Male",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                gender = "female";
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: 5,
                                  left: 5,
                                  right: 5,
                                  bottom: 5,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: gender == "female" ? 1 : 0,
                                    color: gender == "female"
                                        ? Colors.deepOrangeAccent
                                        : Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                  color: gender == "female"
                                      ? Colors.deepOrangeAccent.withOpacity(
                                          0.1,
                                        )
                                      : Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: gender == "female"
                                          ? Colors.deepOrangeAccent
                                          : Colors.transparent,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Female",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
                  width: width,
                  height: height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          left: 20,
                        ),
                        width: width,
                        child: Text(
                          "Personal Details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.025,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 5,
                          left: 20,
                        ),
                        width: width,
                        child: Text(
                          "How will you pay for the appointment?",
                          style: TextStyle(
                            fontSize: height * 0.015,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: Divider(),
                      ),
                      Container(
                        width: width,
                        height: height * 0.055,
                        margin: EdgeInsets.only(
                          top: 10,
                          left: 20,
                          right: 20,
                        ),
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepOrangeAccent.withOpacity(
                            0.1,
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          border: Border.all(
                            width: 1,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.deepOrangeAccent,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Online Payment",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Rs ${widget.fees}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
                bottom: 10,
              ),
              color: Colors.white,
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${widget.month} ${widget.date}, ${widget.time} PM",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.017,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "images/profile.gif",
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            // width: 145,
                            child: Text(
                              "${widget.doc}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.017,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
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
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepOrangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PatientSelectPaymentMethodScreen(
                              name: widget.doc,
                              time: widget.time,
                              month: widget.month,
                              date: widget.date,
                              fees: widget.fees,
                              index: widget.index,
                              doc: widget.docs,
                            ),
                          ),
                        );
                      },
                      child: Text("Confirm Booking"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
