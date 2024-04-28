
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/screens/homepage.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class EditParkingScreen extends StatefulWidget {
  final Map<String, dynamic> parking;

  EditParkingScreen({required this.parking});

  @override
  _EditParkingScreenState createState() => _EditParkingScreenState();
}

class _EditParkingScreenState extends State<EditParkingScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final DateFormat _format = DateFormat('yyyy-MM-dd HH:mm a');

  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.parking['Name']);
    _locationController = TextEditingController(text: widget.parking['Location']);
    _priceController = TextEditingController(text: widget.parking['price'].toString());
    _startDateController = TextEditingController(text: _format.format(widget.parking['startDate'].toDate()));
    _endDateController = TextEditingController(text: _format.format(widget.parking['endDate'].toDate()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Parking'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                // Update the 'Name' field in the parking map
                widget.parking['Name'] = value;
              },
            ),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
              onChanged: (value) {
                // Update the 'Location' field in the parking map
                widget.parking['Location'] = value;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Update the 'Price' field in the parking map
                widget.parking['price'] = double.parse(value);
              },
            ),
            DateTimeField(
              format: _format,
              controller: _startDateController,
              decoration: InputDecoration(labelText: 'Start Date & Time'),
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(context: context, initialDate: currentValue ?? DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100));
                if (date != null) {
                  final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()));
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
              onChanged: (value) {
                // Update the 'startDate' field in the parking map
                widget.parking['startDate'] = Timestamp.fromDate(value!);
              },
            ),
            DateTimeField(
              format: _format,
              controller: _endDateController,
              decoration: InputDecoration(labelText: 'End Date& Time'),
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(context: context, initialDate: currentValue ?? DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100));
                if (date != null) {
                  final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()));
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
              onChanged: (value) {
                // Update the 'endDate' field in the parking map
                widget.parking['endDate'] = Timestamp.fromDate(value!);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                // Convert price and time values to double (assuming they are numeric fields)
                double price = double.parse(widget.parking['price'].toString());

                // Update the Firestore document
                try {
                  await _db.collection('parkingareas').doc(widget.parking['docId']).update({
                    'Name': widget.parking['Name'],
                    'Location': widget.parking['Location'],
                    'price': price, // Ensure price is converted to double
                    'startDate': widget.parking['startDate'],
                    'endDate': widget.parking['endDate'],
                  });

                  // Show a message or navigate back to the previous screen
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Changes saved successfully'),
                  ));

                  // You can also navigate back to the previous screen after saving
                  Navigator.pop(context); // This will pop the current screen off the navigation stack
                } catch (e) {
                  print('Error saving changes: $e');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to save changes. Please try again.'),
                  ));
                }
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}