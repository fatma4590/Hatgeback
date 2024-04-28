import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/screens/addpoint.dart';
import 'package:hatgeback/screens/myparking.dart';
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
    final FirebaseAuth _auth = FirebaseAuth.instance;
    db
        .collection('parkingareas')
        .where('userid', isNotEqualTo: _auth.currentUser!.email)
        .get()
        .then(
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
    Text('Price: ${parking['price']}'),
    Text('StartDate: ${parking['startDate'].toDate()}'),
    Text('endDate: ${parking['endDate'].toDate()}'),
    ],
    ));}),
      // body: Column(
      //   children: [
      //     ...parkingareas
      //         .map((parking) => parkingwidget(
      //         Location: parking['Location'],
      //         Name: parking['Name'],
      //         Price: parking['price'].toString(),
      //        startDate: parking['startDate'].toDate(),
      //        endDate: parking['endtDate'].toDate(),)
      //     )
      //         .toList()
      //   ],
      // ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, UserProfile.id);
                },
                icon: Icon(Icons.account_circle_sharp)),
            SizedBox(width: 20),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, addpoint.id);
                },
                icon: Icon(Icons.add)),
            SizedBox(
              width: 50,
            ),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, myparking.id);
                },
                icon: Icon(Icons.paste_rounded)),
          ],
        ),
      ),
    );
  }
}