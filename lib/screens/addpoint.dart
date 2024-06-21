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























/*
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
        backgroundColor: Colors.black26,
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
                return null;
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
                    .doc(Name.text)
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
*/












import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/screens/homepage.dart';
import 'package:intl/intl.dart';

class addpoint extends StatefulWidget {
  static String id = 'addpointpage';

  @override
  _AddPointState createState() => _AddPointState();
}
class _AddPointState extends State<addpoint> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController userid = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  DateTime? startDate;
  DateTime? endDate;
  bool isRecurring = false;
  String recurrenceType = 'daily'; // or 'weekly', 'monthly'
  List<String> selectedDays = []; // Store selected days for recurring events
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('yyyy-MM-dd HH:mm a');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Text('My Parking Space'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Just Once'),
            Tab(text: 'Recurring'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            buildJustOnceForm(format),
            buildRecurringForm(format),
          ],
        ),
      ),
    );
  }

  Widget buildJustOnceForm(DateFormat format) {
    return ListView(
      children: <Widget>[
        buildTextField(location, 'Location'),
        buildTextField(name, 'Name'),
        buildTextField(price, 'Price Per Hour', isNumeric: true),
        DateTimeField(
          format: DateFormat('yyyy-MM-dd'),
          decoration: InputDecoration(hintText: 'Choose Date'),
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
              context: context,
              initialDate: currentValue ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() {
                selectedDate = date;
              });
            }
            return selectedDate ?? currentValue ?? DateTime.now();
          },
        ),
        DateTimeField(
          format: DateFormat('HH:mm'),
          decoration: InputDecoration(hintText: 'Choose Start Time'),
          onShowPicker: (context, currentValue) async {
            final time = await showTimePicker(
              context: context,
              initialTime: currentValue != null
                  ? TimeOfDay.fromDateTime(currentValue)
                  : TimeOfDay.now(),
            );
            if (time != null) {
              setState(() {
                startTime = time;
              });
            }
            return startTime != null
                ? DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day,
                startTime!.hour, startTime!.minute)
                : currentValue ?? DateTime.now();
          },
        ),
        DateTimeField(
          format: DateFormat('HH:mm'),
          decoration: InputDecoration(hintText: 'Choose End Time'),
          onShowPicker: (context, currentValue) async {
            final time = await showTimePicker(
              context: context,
              initialTime: currentValue != null
                  ? TimeOfDay.fromDateTime(currentValue)
                  : TimeOfDay.now(),
            );
            if (time != null) {
              setState(() {
                endTime = time;
              });
            }
            return endTime != null
                ? DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day,
                endTime!.hour, endTime!.minute)
                : currentValue ?? DateTime.now();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            if (selectedDate != null && startTime != null && endTime != null) {
              // Combine selectedDate with startTime and endTime
              DateTime startDate = DateTime(
                selectedDate!.year,
                selectedDate!.month,
                selectedDate!.day,
                startTime!.hour,
                startTime!.minute,
              );
              DateTime endDate = DateTime(
                selectedDate!.year,
                selectedDate!.month,
                selectedDate!.day,
                endTime!.hour,
                endTime!.minute,
              );
              FirebaseFirestore.instance.collection('parkingareas').doc(name.text).set({
                'userid': _auth.currentUser!.email,
                'Location': location.text,
                'Name': name.text,
                'price': price.text,
                'startDate': Timestamp.fromDate(startDate),
                'endDate': Timestamp.fromDate(endDate),
                'isRecurring': false,
              });
              Navigator.pushNamed(context, homepage.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Added successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Please fill in all fields"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Text("Add", style: TextStyle(fontSize: 22, color: Colors.white)),
        ),
      ],
    );
  }

  Widget buildRecurringForm(DateFormat format) {
    return ListView(
      children: <Widget>[
        buildTextField(location, 'Location'),
        buildTextField(name, 'Name'),
        buildTextField(price, 'Price Per Hour', isNumeric: true),
        DateTimeField(
          format: DateFormat('yyyy-MM-dd'),
          decoration: InputDecoration(hintText: 'Choose Start Date'),
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
              context: context,
              initialDate: currentValue ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() {
                startDate = date;
              });
            }
            return startDate ?? currentValue ?? DateTime.now();
          },
        ),
        DateTimeField(
          format: DateFormat('yyyy-MM-dd'),
          decoration: InputDecoration(hintText: 'Choose End Date'),
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
              context: context,
              initialDate: currentValue ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() {
                endDate = date;
              });
            }
            return endDate ?? currentValue ?? DateTime.now();
          },
        ),
        DateTimeField(
          format: DateFormat('HH:mm'),
          decoration: InputDecoration(hintText: 'Choose Start Time'),
          onShowPicker: (context, currentValue) async {
            final time = await showTimePicker(
              context: context,
              initialTime: currentValue != null
                  ? TimeOfDay.fromDateTime(currentValue)
                  : TimeOfDay.now(),
            );
            if (time != null) {
              setState(() {
                startTime = time;
              });
            }
            return startTime != null
                ? DateTime(startDate!.year, startDate!.month, startDate!.day,
                startTime!.hour, startTime!.minute)
                : currentValue ?? DateTime.now();
          },
        ),
        DateTimeField(
          format: DateFormat('HH:mm'),
          decoration: InputDecoration(hintText: 'Choose End Time'),
          onShowPicker: (context, currentValue) async {
            final time = await showTimePicker(
              context: context,
              initialTime: currentValue != null
                  ? TimeOfDay.fromDateTime(currentValue)
                  : TimeOfDay.now(),
            );
            if (time != null) {
              setState(() {
                endTime = time;
              });
            }
            return endTime != null
                ? DateTime(endDate!.year, endDate!.month, endDate!.day,
                endTime!.hour, endTime!.minute)
                : currentValue ?? DateTime.now();
          },
        ),
        CheckboxListTile(
          title: Text('Monday'),
          value: selectedDays.contains('Monday'),
          onChanged: (value) {
            setState(() {
              value!
                  ? selectedDays.add('Monday')
                  : selectedDays.remove('Monday');
            });
          },
        ),
        CheckboxListTile(
          title: Text('Tuesday'),
          value: selectedDays.contains('Tuesday'),
          onChanged: (value) {
            setState(() {
              value!
                  ? selectedDays.add('Tuesday')
                  : selectedDays.remove('Tuesday');
            });
          },
        ),
        CheckboxListTile(
          title: Text('Wednesday'),
          value: selectedDays.contains('Wednesday'),
          onChanged: (value) {
            setState(() {
              value!
                  ? selectedDays.add('Wednesday')
                  : selectedDays.remove('Wednesday');
            });
          },
        ),
        CheckboxListTile(
          title: Text('Thursday'),
          value: selectedDays.contains('Thursday'),
          onChanged: (value) {
            setState(() {
              value!
                  ? selectedDays.add('Thursday')
                  : selectedDays.remove('Thursday');
            });
          },
        ),
        CheckboxListTile(
          title: Text('Friday'),
          value: selectedDays.contains('Friday'),
          onChanged: (value) {
            setState(() {
              value!
                  ? selectedDays.add('Friday')
                  : selectedDays.remove('Friday');
            });
          },
        ),
        CheckboxListTile(
          title: Text('Saturday'),
          value: selectedDays.contains('Saturday'),
          onChanged: (value) {
            setState(() {
              value!
                  ? selectedDays.add('Saturday')
                  : selectedDays.remove('Saturday');
            });
          },
        ),
        CheckboxListTile(
          title: Text('Sunday'),
          value: selectedDays.contains('Sunday'),
          onChanged: (value) {
            setState(() {
              value!
                  ? selectedDays.add('Sunday')
                  : selectedDays.remove('Sunday');
            });
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            if (startDate != null && endDate != null && startTime != null && endTime != null) {
              storeRecurringParkingAreas();
              Navigator.pushNamed(context, homepage.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Added successfully"),
                backgroundColor: Colors.green,
              ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Please fill in all fields"),
                backgroundColor: Colors.red,
              ));
            }
          },
          child: Text("Add", style: TextStyle(fontSize: 22, color: Colors.white)),
        ),
      ],
    );
  }

  void storeRecurringParkingAreas() {
    DateTime current = startDate!;
    while (current.isBefore(endDate!) || current.isAtSameMomentAs(endDate!)) {
      // Check if the current date matches any of the selected days
      if (selectedDays.contains(DateFormat('EEEE').format(current))) {
        // Create the start and end DateTime objects for the current date
        DateTime currentStartDate = DateTime(
          current.year,
          current.month,
          current.day,
          startTime!.hour,
          startTime!.minute,
        );
        DateTime currentEndDate = DateTime(
          current.year,
          current.month,
          current.day,
          endTime!.hour,
          endTime!.minute,
        );

        // Store the parking area entry in Firestore
        FirebaseFirestore.instance.collection('parkingareas').add({
          'userid': _auth.currentUser!.email,
          'Location': location.text,
          'Name': name.text,
          'price': price.text,
          'startDate': Timestamp.fromDate(currentStartDate),
          'endDate': Timestamp.fromDate(currentEndDate),
          'isRecurring': false,
        });
      }

      // Move to the next day
      current = current.add(Duration(days: 1));
    }
  }

  Widget buildTextField(TextEditingController controller, String hintText, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hintText),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      ),
    );
  }
}








