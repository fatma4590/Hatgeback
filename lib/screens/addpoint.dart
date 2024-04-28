import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/screens/homepage.dart';
import 'package:intl/intl.dart';

class addpoint extends StatefulWidget {
  static String id = 'addpointpage';

  @override
  _AddpointState createState() => _AddpointState();
}

class _AddpointState extends State<addpoint> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController userid = TextEditingController();
  TextEditingController Location = TextEditingController();
  TextEditingController Name = TextEditingController();
  TextEditingController Price = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('yyyy-MM-dd HH:mm a');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        actions: [],
        title: Text('My parking Space'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: <Widget>[
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(75),
                  bottomLeft: Radius.circular(25),
                ),
              ),
            ),
            TextFormField(
              controller: Location,
              validator: (data) {
                if (data!.isEmpty) {
                  return "feild is emply";
                }
              },
              decoration: InputDecoration(
                hintText: "Location",
                hintStyle: TextStyle(color: Colors.black, fontSize: 18),
              ),
              cursorColor: Colors.black,
              showCursor: true,
            ),
            SizedBox(
              height: 12.0,
            ),
            TextFormField(
              controller: Name,
              validator: (data) {
                if (data == null || data.isEmpty) {
                  return 'Required';
                } else if (!RegExp(r"^[A-Za-z][A-Za-z0-9_]{7,29}$")
                    .hasMatch(data)) {
                  return "Enter valid name";
                }
                return null;
              },
              cursorColor: Colors.black,
              showCursor: true,
              decoration: InputDecoration(
                hintText: "Name",
                hintStyle: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            TextFormField(
                controller: Price,
                validator: (data) {
                  if (data == null || data.isEmpty) {
                    return 'Required';
                  } else if (!RegExp(r"^[1-9]\d{0,7}(?:\.\d{1,4})?$")
                      .hasMatch(data)) {
                    return "Enter valid price";
                  }
                  return null;
                },
                cursorColor: Colors.black,
                showCursor: true,
                decoration: InputDecoration(
                  hintText: "Price Per hour",
                  hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                ),
                keyboardType: TextInputType.number),
            SizedBox(
              height: 12.0,
            ),
            DateTimeField(
                format: format,
                decoration:
                InputDecoration(hintText: 'Choose Start Date & Time'),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: currentValue ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));

                  if (date != null) {
                    final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()));
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    startDate = value ?? DateTime.now();
                  });
                }),
            SizedBox(height: 16.0),
            DateTimeField(
                format: format,
                decoration: InputDecoration(hintText: 'Choose End Date & Time'),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: currentValue ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));

                  if (date != null) {
                    final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()));
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    endDate = value ?? DateTime.now();
                  });
                }),
            SizedBox(
              height: 12.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('parkingareas')
                    .doc(Name!.text)
                    .set({
                  'userid': _auth.currentUser!.email,
                  'Location': Location.text,
                  'Name': Name.text,
                  'price': Price.text,
                  'startDate': Timestamp.fromDate(startDate!),
                  'endDate': Timestamp.fromDate(endDate!),
                });

                Navigator.pushNamed(context, homepage.id);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("added succefully"),
                  backgroundColor: Colors.green,
                ));
              },
              child: Text(
                "Add",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/screens/homepage.dart';

class addpoint extends StatelessWidget {
  static String id = 'addpointpage';
  addpoint({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController userid = TextEditingController();
  TextEditingController Location = TextEditingController();
  TextEditingController Name = TextEditingController();
  TextEditingController Price = TextEditingController();
  TextEditingController Time = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        actions: [],
        title: Text('My parking Space'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: <Widget>[
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(75),
                  bottomLeft: Radius.circular(25),
                ),
              ),
            ),
            TextFormField(
              controller: Location,
              validator: (data) {
                if (data!.isEmpty) {
                  return "feild is emply";
                }
              },
              decoration: InputDecoration(
                hintText: "Location",
                hintStyle: TextStyle(color: Colors.black, fontSize: 18),
              ),
              cursorColor: Colors.black,
              showCursor: true,
            ),
            SizedBox(
              height: 12.0,
            ),
            TextFormField(
              controller: Name,
              validator: (data) {
                if (data == null || data.isEmpty) {
                  return 'Required';
                } else if (!RegExp(r"^[A-Za-z][A-Za-z0-9_]{7,29}$")
                    .hasMatch(data)) {
                  return "Enter valid name";
                }
                return null;
              },
              cursorColor: Colors.black,
              showCursor: true,
              decoration: InputDecoration(
                hintText: "Name",
                hintStyle: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            TextFormField(
                controller: Price,
                validator: (data) {
                  if (data == null || data.isEmpty) {
                    return 'Required';
                  } else if (!RegExp(r"^[1-9]\d{0,7}(?:\.\d{1,4})?$")
                      .hasMatch(data)) {
                    return "Enter valid price";
                  }
                  return null;
                },
                cursorColor: Colors.black,
                showCursor: true,
                decoration: InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                ),
                keyboardType: TextInputType.number),
            SizedBox(
              height: 12.0,
            ),
          





            TextFormField(
              controller: Time,
              validator: (data) {
                if (data!.isEmpty) {
                  return "feild is emply";
                }
              },
              cursorColor: Colors.black,
              showCursor: true,
              decoration: InputDecoration(
                hintText: "Time",
                hintStyle: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            
            
            
            
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('parkingareas')
                    .doc(Name!.text)
                    .set({
                  'userid': _auth.currentUser!.email,
                  'Location': Location.text,
                  'Name': Name.text,
                  'price': Price.text,
                  'time': Time.text
                });

                Navigator.pushNamed(context, homepage.id);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("added succefully"),
                  backgroundColor: Colors.green,
                ));
              },
              child: Text(
                "Add",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/