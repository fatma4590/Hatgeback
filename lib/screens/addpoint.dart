import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/screens/homepage.dart';
import 'package:hatgeback/widgets/base_screen.dart';
import 'package:intl/intl.dart';

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
          onPressed: () async {
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
                int parkingId = await getNextParkingId(isRecurring: false);
                FirebaseFirestore.instance.collection('parkingareas').add({
                  'userid': _auth.currentUser!.email,
                  'parkingid': parkingId.toString(),
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
                  SizedBox(height: 16),
                  DateTimeField(
                    format: DateFormat('HH:mm'),
                    decoration: InputDecoration(
                      labelText: 'Choose Start Time',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    controller: TextEditingController(
                        text: startTime != null
                            ? startTime!.format(context)
                            : ''),
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
                          ? DateTime(
                              startDate!.year,
                              startDate!.month,
                              startDate!.day,
                              startTime!.hour,
                              startTime!.minute)
                          : currentValue ?? DateTime.now();
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
                  SizedBox(height: 16),
                  DateTimeField(
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
                          ? DateTime(endDate!.year, endDate!.month,
                              endDate!.day, endTime!.hour, endTime!.minute)
                          : currentValue ?? DateTime.now();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: [
            ChoiceChip(
              label: Text('Mon'),
              selected: selectedDays.contains('Mon'),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedDays.add('Mon');
                  } else {
                    selectedDays.remove('Mon');
                  }
                });
              },
            ),
            ChoiceChip(
              label: Text('Tue'),
              selected: selectedDays.contains('Tue'),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedDays.add('Tue');
                  } else {
                    selectedDays.remove('Tue');
                  }
                });
              },
            ),
            ChoiceChip(
              label: Text('Wed'),
              selected: selectedDays.contains('Wed'),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedDays.add('Wed');
                  } else {
                    selectedDays.remove('Wed');
                  }
                });
              },
            ),
            ChoiceChip(
              label: Text('Thu'),
              selected: selectedDays.contains('Thu'),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedDays.add('Thu');
                  } else {
                    selectedDays.remove('Thu');
                  }
                });
              },
            ),
            ChoiceChip(
              label: Text('Fri'),
              selected: selectedDays.contains('Fri'),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedDays.add('Fri');
                  } else {
                    selectedDays.remove('Fri');
                  }
                });
              },
            ),
            ChoiceChip(
              label: Text('Sat'),
              selected: selectedDays.contains('Sat'),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedDays.add('Sat');
                  } else {
                    selectedDays.remove('Sat');
                  }
                });
              },
            ),
            ChoiceChip(
              label: Text('Sun'),
              selected: selectedDays.contains('Sun'),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedDays.add('Sun');
                  } else {
                    selectedDays.remove('Sun');
                  }
                });
              },
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
          onPressed: () async {
            if (startDate != null &&
                endDate != null &&
                startTime != null &&
                endTime != null &&
                selectedDays.isNotEmpty) {
              // Combine startDate and startTime, endDate and endTime
              DateTime startDateTime = DateTime(
                startDate!.year,
                startDate!.month,
                startDate!.day,
                startTime!.hour,
                startTime!.minute,
              );
              DateTime endDateTime = DateTime(
                endDate!.year,
                endDate!.month,
                endDate!.day,
                endTime!.hour,
                endTime!.minute,
              );

              // Validate end time is at least 1 hour after start time
              if (endDateTime.isAfter(startDateTime)) {
                int parkingId = await getNextParkingId(isRecurring: true);
                await FirebaseFirestore.instance
                    .collection('parkingareas')
                    .add({
                  'userid': _auth.currentUser!.email,
                  'parkingid': parkingId.toString(),
                  'Location': location.text,
                  'Name': name.text,
                  'price': int.parse(price.text),
                  'startDate': Timestamp.fromDate(startDateTime),
                  'endDate': Timestamp.fromDate(endDateTime),
                  'isRecurring': true,
                  'selectedDays': selectedDays,
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

Future<int> getNextParkingId({bool isRecurring = false}) async {
  DocumentReference counterRef;
  if (isRecurring) {
    counterRef = FirebaseFirestore.instance
        .collection('counters')
        .doc('recurring_parkingid');
  } else {
    counterRef =
        FirebaseFirestore.instance.collection('counters').doc('once_parkingid');
  }

  DocumentSnapshot counterSnapshot = await counterRef.get();

  if (counterSnapshot.exists) {
    int currentCounter =
        counterSnapshot[isRecurring ? 'recurring_parkingid' : 'once_parkingid'];
    int newCounter = currentCounter + 1;
    await counterRef.update(
        {isRecurring ? 'recurring_parkingid' : 'once_parkingid': newCounter});
    return newCounter;
  } else {
    if (isRecurring) {
      await counterRef.set({'recurring_parkingid': 100});
      return 100;
    } else {
      await counterRef.set({'once_parkingid': 1});
      return 1;
    }
  }
}
