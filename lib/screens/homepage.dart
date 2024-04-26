import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/screens/addpoint.dart';
import 'package:hatgeback/screens/userprofile.dart';
import 'package:hatgeback/widgets/parkingwidget.dart';

class homepage extends StatefulWidget {
  static String id = 'homepage';

  homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<Map<String, dynamic>> parkingareas = [];

  getParking() {
    List<Map<String, dynamic>> list = [];
    var db = FirebaseFirestore.instance;
    db.collection('parkingareas').get().then(
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
        title: Text("Home Page"),
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        height: 70,
        child: Container(
          child: Row(children: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, addpoint.id);
                // Add button action
              },
            ),
            SizedBox(
              width: 50,
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.pushNamed(context, addpoint.id);
              },
            ),
            SizedBox(width: 50),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context,UserProfile.id);
                },
                icon: Icon(Icons.account_circle_sharp)),
          ]),
        ),
      ),
    );
  }
}
