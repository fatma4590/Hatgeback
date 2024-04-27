// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:hatgeback/Services/asd.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class fatma extends StatelessWidget {
//   static String id = 'fatma';
//
//    fatma({super.key});
//   final ParkingService _parkingService = ParkingService();
//
//   @override
//   Widget build(BuildContext context) {
//     String userId = ''; // Retrieve the userId from authentication
//
//     return FutureBuilder<List<DocumentSnapshot>>(
//       future: _parkingService.getParkingAreasForUser(userId),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }
//
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }
//
//         List<DocumentSnapshot> parkingAreas = snapshot.data ?? [];
//
//         return ListView.builder(
//           itemCount: parkingAreas.length,
//           itemBuilder: (context, index) {
//             Map<String, dynamic> parkingAreaData = parkingAreas[index]
//                 .data() as Map<String, dynamic>;
//
//             return ListTile(
//               title: Text(parkingAreaData['name']),
//               subtitle: Text('Price: ${parkingAreaData['price']}'),
//
//
//               // Add more details from parkingAreaData as needed
//             );
//           },
//         );
//       },
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/widgets/parkingwidget.dart';

class fatma extends StatefulWidget {
  static String id = 'fatma';

  const fatma({Key? key}) : super(key: key);

  @override
  State<fatma> createState() => _MyParkingAreasState();
}

class _MyParkingAreasState extends State<fatma> {
  List<Map<String, dynamic>> parkingAreas = [];

  void getParking() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var db = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await db
          .collection('parkingareas')
          .where('userId', isEqualTo: user.uid) // Filter by user ID
          .get();

      List<Map<String, dynamic>> list = [];
      querySnapshot.docs.forEach((docSnapshot) {
        // Use as Map<String, dynamic>? to handle nullable return
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          list.add(data);
        }
      });

      setState(() {
        parkingAreas = list;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getParking();
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
      body: Column(
        children: parkingAreas.map((parking) => parkingwidget(
            Location: parking['Location'],
            Name: parking['Name'],
            Price: parking['price'],
            time: parking['time']))
            .toList()

      ),
    );
  }
}
