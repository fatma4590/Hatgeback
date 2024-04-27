import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditParkingScreen extends StatelessWidget {
  final Map<String, dynamic> parking;

  EditParkingScreen({required this.parking});

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
              initialValue: parking['Name'],
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                // Update the 'Name' field in the parking map
                parking['Name'] = value;
              },
            ),
            TextFormField(
              initialValue: parking['Location'],
              decoration: InputDecoration(labelText: 'Location'),
              onChanged: (value) {
                // Update the 'Location' field in the parking map
                parking['Location'] = value;
              },
            ),
            TextFormField(
              initialValue: parking['price'].toString(),
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Update the 'Price' field in the parking map
                parking['price'] = double.parse(value);
              },
            ),
            TextFormField(
              initialValue: parking['time'].toString(),
              decoration: InputDecoration(labelText: 'time'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Update the 'time' field in the parking map
                parking['time'] = double.parse(value);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                var db = FirebaseFirestore.instance;

                // Convert price and time values to double (assuming they are numeric fields)
                double price = double.parse(parking['price'].toString());
                double time = double.parse(parking['time'].toString());

                // Update the Firestore document
                try {
                  await db.collection('parkingareas').doc(parking['docId']).update({
                    'Name': parking['Name'],
                    'Location': parking['Location'],
                    'price': price, // Ensure price is converted to double
                    'time': time,   // Ensure time is converted to double
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

        ]),
      ),
    );
  }
}
