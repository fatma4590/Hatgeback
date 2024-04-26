import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/screens/addpoint.dart';
import 'package:hatgeback/screens/fatma.dart';
import 'package:hatgeback/screens/myparkingareas.dart';
import 'package:hatgeback/widgets/parkingwidget.dart';

class homepage extends StatefulWidget {
  static String id = 'homepage';
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
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
        automaticallyImplyLeading: false,
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
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, addpoint.id);
                },
                icon: Icon(Icons.add)),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, myparkingareas.id);
                },
                icon: Icon(Icons.paste_rounded)),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, fatma.id);
                },
                icon: Icon(Icons.home)),
          ],
        ),
      ),
    );
  }
}
