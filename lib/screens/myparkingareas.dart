import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/widgets/parkingwidget.dart';

class myparkingareas extends StatefulWidget {
  static String id = 'myparking areas';

  myparkingareas({super.key});

  @override
  State<myparkingareas> createState() => _myparkingareasState();
}

class _myparkingareasState extends State<myparkingareas> {
  var dbb = FirebaseAuth.instance.tenantId;

  List<Map<String, dynamic>> parkingareas = [];
  getParking() {
    List<Map<String, dynamic>> list = [];
    var db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    var uid = user!.uid.toString();

    db.collection('parkingareas').where('userid', isEqualTo: uid).get().then(
      (QuerySnapshot) {
        print("Succefully Completed");
        for (var docSnapshot in QuerySnapshot.docs) {
          list.add(docSnapshot.data());
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
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ...parkingareas
              .map((parking) => parkingwidget(
                  Location: parking['Location'],
                  Name: parking['Name'],
                  Price: parking['price'],
                  time: parking['time']))
              .toList()
        ],
      ),
    );
  }
}
