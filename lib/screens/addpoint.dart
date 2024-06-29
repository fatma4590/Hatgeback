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
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
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
          controller: dateController,
          decoration: InputDecoration(
            labelText: 'Choose Date',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.calendar_today),
          ),
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
                dateController.text = DateFormat('yyyy-MM-dd').format(date);
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
                controller: startTimeController,
                decoration: InputDecoration(
                  labelText: 'Choose Start Time',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
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
                      startTimeController.text = time.format(context);
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
                controller: endTimeController,
                decoration: InputDecoration(
                  labelText: 'Choose End Time',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
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
                      endTimeController.text = time.format(context);
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

              if (startDate.isBefore(endDate)) {
                FirebaseFirestore.instance
                    .collection('parkingareas')
                    .doc(name.text)
                    .set({
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
                    content: Text("Start time must be before end time"),
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
          child: Text(
            "Add",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
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
        DateTimeField(
          format: DateFormat('yyyy-MM-dd'),
          controller: startDateController,
          decoration: InputDecoration(
            labelText: 'Choose Start Date',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.calendar_today),
          ),
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
                startDateController.text = DateFormat('yyyy-MM-dd').format(date);
              });
            }
            return startDate ?? currentValue ?? DateTime.now();
          },
        ),
        SizedBox(height: 16),
        DateTimeField(
          format: DateFormat('yyyy-MM-dd'),
          controller: endDateController,
          decoration: InputDecoration(
            labelText: 'Choose End Date',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.calendar_today),
          ),
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
                endDateController.text = DateFormat('yyyy-MM-dd').format(date);
              });
            }
            return endDate ?? currentValue ?? DateTime.now();
          },
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DateTimeField(
                format: DateFormat('HH:mm'),
                controller: startTimeController,
                decoration: InputDecoration(
                  labelText: 'Choose Start Time',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
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
                      startTimeController.text = time.format(context);
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
                controller: endTimeController,
                decoration: InputDecoration(
                  labelText: 'Choose End Time',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
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
                      endTimeController.text = time.format(context);
                    });
                  }
                  return endTime != null
                      ? DateTime(endDate!.year, endDate!.month,
                      endDate!.day, endTime!.hour, endTime!.minute)
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
            if (startDate != null && endDate != null && startTime != null && endTime != null) {
              DateTime tempStartDate = DateTime(
                startDate!.year,
                startDate!.month,
                startDate!.day,
                startTime!.hour,
                startTime!.minute,
              );
              DateTime tempEndDate = DateTime(
                endDate!.year,
                endDate!.month,
                endDate!.day,
                endTime!.hour,
                endTime!.minute,
              );

              if (tempStartDate.isBefore(tempEndDate)) {
                storeRecurringParkingAreas();
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
                    content: Text("Start time must be before end time"),
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
          child: Text(
            "Add",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  void storeRecurringParkingAreas() {
    FirebaseFirestore.instance.collection('parkingareas').doc(name.text).set({
      'userid': _auth.currentUser!.email,
      'parkingid': Isar.defaultMaxSizeMiB,
      'Location': location.text,
      'Name': name.text,
      'price': int.parse(price.text),
      'startDate': Timestamp.fromDate(startDate!),
      'endDate': Timestamp.fromDate(endDate!),
      'isRecurring': true,
      'recurrenceType': recurrenceType,
      'selectedDays': selectedDays,
    });
  }
}
