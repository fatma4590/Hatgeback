import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/Services/asd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class fatma extends StatelessWidget {
  static String id = 'fatma';

   fatma({super.key});
  final ParkingService _parkingService = ParkingService();

  @override
  Widget build(BuildContext context) {
    String userId = ''; // Retrieve the userId from authentication

    return FutureBuilder<List<DocumentSnapshot>>(
      future: _parkingService.getParkingAreasForUser(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<DocumentSnapshot> parkingAreas = snapshot.data ?? [];

        return ListView.builder(
          itemCount: parkingAreas.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> parkingAreaData = parkingAreas[index]
                .data() as Map<String, dynamic>;

            return ListTile(
              title: Text(parkingAreaData['name']),
              subtitle: Text('Price: ${parkingAreaData['price']}'),


              // Add more details from parkingAreaData as needed
            );
          },
        );
      },
    );
  }
}
