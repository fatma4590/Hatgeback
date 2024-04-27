
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hatgeback/widgets/parkingwidget.dart';

import 'EditParkingScreen.dart';

class fatma extends StatefulWidget {
  static String id = 'fatma';

  fatma({Key? key}) : super(key: key);

  @override
  State<fatma> createState() => _myparkingareasState();
}

class _myparkingareasState extends State<fatma> {
  List<Map<String, dynamic>> parkingareas = [];

  void getParking() {
    var db = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    db
        .collection('parkingareas')
        .where('userid', isEqualTo: _auth.currentUser!.email)
        .get()
        .then(
          (QuerySnapshot) {
        print("Successfully Completed");
        List<Map<String, dynamic>> list = [];
        for (var docSnapshot in QuerySnapshot.docs) {
          var data = docSnapshot.data();
          data['docId'] = docSnapshot.id; // Store document ID
          list.add(data);
        }
        setState(() {
          parkingareas = list;
        });
      },
      onError: (e) => print("Error completing : $e"),
    );
  }

  @override
  void initState() {
    getParking();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('My Parking Areas'),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: parkingareas.length,
        itemBuilder: (context, index) {
          var parking = parkingareas[index];
          return ListTile(
            title: Text(parking['Name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location: ${parking['Location']}'),
                Text('Price: ${parking['price'].toString()}'),
                Text('Time: ${parking['time'].toString()}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Navigate to the EditParkingScreen with selected parking details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditParkingScreen(parking: parking),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
