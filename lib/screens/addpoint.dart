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
import 'package:hatgeback/widgets/base_screen.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

class addpoint extends StatefulWidget {
  static String id = 'addpointpage';

  @override
  _AddPointPageState createState() => _AddPointPageState();
}

class _AddPointPageState extends State<addpoint>
    with SingleTickerProviderStateMixin {
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
    return BaseScreen(
      pageTitle: 'Add Parking Area',
      showBackButton: true,
      onBackButtonPressed: () {
        Navigator.of(context).pop(); // Handle back button press as needed
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 16),
              TabBar(
                tabs: [
                  Tab(text: 'Just Once'),
                  Tab(text: 'Recurring'),
                ],
                controller: _tabController,
                indicatorColor: Color(0xFF33AD60),
                labelColor: Color(0xFF33AD60),
                unselectedLabelColor: Colors.black,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    buildJustOnceForm(format),
                    buildRecurringForm(format),
                  ],
                ),
              ),
            ],
          ),
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
        SizedBox(height: 16),
        DateTimeField(
          format: DateFormat('yyyy-MM-dd'),
          decoration: InputDecoration(
            labelText: 'Choose Date',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.calendar_today),
          ),
          controller: TextEditingController(
              text: selectedDate != null
                  ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                  : ''),
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
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DateTimeField(
                format: DateFormat('HH:mm'),
                decoration: InputDecoration(
                  labelText: 'Choose Start Time',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
                controller: TextEditingController(
                    text: startTime != null ? startTime!.format(context) : ''),
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
                      ? DateTime(selectedDate!.year, selectedDate!.month,
                      selectedDate!.day, startTime!.hour, startTime!.minute)
                      : currentValue ?? DateTime.now();
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: DateTimeField(
                format: DateFormat('HH:mm'),
                decoration: InputDecoration(
                  labelText: 'Choose End Time',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
                controller: TextEditingController(
                    text: endTime != null ? endTime!.format(context) : ''),
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
                      ? DateTime(selectedDate!.year, selectedDate!.month,
                      selectedDate!.day, endTime!.hour, endTime!.minute)
                      : currentValue ?? DateTime.now();
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF33AD60),
            padding: EdgeInsets.all(16),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
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

              // Validate end time is at least 1 hour after start time
              if (endTime!.hour > startTime!.hour ||
                  (endTime!.hour == startTime!.hour &&
                      endTime!.minute > startTime!.minute)) {
                FirebaseFirestore.instance.collection('parkingareas').add({
                  'userid': _auth.currentUser!.email,
                  'parkingid': Isar.defaultMaxSizeMiB,
                  'Location': location.text,
                  'Name': name.text,
                  'price': int.parse(price.text),
                  'startDate': Timestamp.fromDate(startDate),
                  'endDate': Timestamp.fromDate(endDate),
                  'isRecurring': false,
                });
                Navigator.pushNamed(context, homepage.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Added successfully"),
                    backgroundColor: Color(0xFF33AD60),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("End time must be after start time"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Please fill in all fields"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child:
              Text("Add", style: TextStyle(fontSize: 22, color: Colors.white)),
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
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DateTimeField(
                    format: DateFormat('yyyy-MM-dd'),
                    decoration: InputDecoration(
                      labelText: 'Choose Start Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                        text: startDate != null
                            ? DateFormat('yyyy-MM-dd').format(startDate!)
                            : ''),
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
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DateTimeField(
                    format: DateFormat('yyyy-MM-dd'),
                    decoration: InputDecoration(
                      labelText: 'Choose End Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                        text: endDate != null
                            ? DateFormat('yyyy-MM-dd').format(endDate!)
                            : ''),
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
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DateTimeField(
                format: DateFormat('HH:mm'),
                decoration: InputDecoration(
                  labelText: 'Choose Start Time',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
                controller: TextEditingController(
                    text: startTime != null ? startTime!.format(context) : ''),
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
                      ? DateTime(startDate!.year, startDate!.month,
                      startDate!.day, startTime!.hour, startTime!.minute)
                      : currentValue ?? DateTime.now();
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: DateTimeField(
                format: DateFormat('HH:mm'),
                decoration: InputDecoration(
                  labelText: 'Choose End Time',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
                controller: TextEditingController(
                    text: endTime != null ? endTime!.format(context) : ''),
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
            ),
          ],
        ),
        SizedBox(height: 16),
        Text(
          'Select Days',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            for (String day in [
              'Monday',
              'Tuesday',
              'Wednesday',
              'Thursday',
              'Friday',
              'Saturday',
              'Sunday'
            ])
              ChoiceChip(
                label: Text(day),
                selected: selectedDays.contains(day),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedDays.add(day);
                    } else {
                      selectedDays.remove(day);
                    }
                  });
                },
              ),
          ],
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            if (startDate != null &&
                endDate != null &&
                startTime != null &&
                endTime != null) {
              // Check if start time is before end time
              if (startTime!.hour > endTime!.hour ||
                  (startTime!.hour == endTime!.hour &&
                      startTime!.minute >= endTime!.minute)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Start time must be before end time"),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                storeRecurringParkingAreas();
                Navigator.pushNamed(context, homepage.id);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Added successfully"),
                  backgroundColor: Colors.green,
                ));
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Please fill in all fields"),
                backgroundColor: Colors.red,
              ));
            }
          },
          child:
          Text("Add", style: TextStyle(fontSize: 22, color: Colors.white)),
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
          'isRecurring': true,
        });
      }

      // Move to the next day
      current = current.add(Duration(days: 1));
    }
  }

  Widget buildTextField(TextEditingController controller, String labelText,
      {bool isNumeric = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}