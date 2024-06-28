import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/widgets/base_screen.dart';

class myReservations extends StatelessWidget {
  static String id = 'myReservatins';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchReservations() async {
    final user = _auth.currentUser;
    if (user == null) {
      // User not authenticated
      return [];
    }

    final reservationsSnapshot = await _firestore
        .collection('reservations')
        .where('userId', isEqualTo: user.uid)
        .get();

    return reservationsSnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      pageTitle: 'My Reservations',
      showBackButton: true,
      onBackButtonPressed: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchReservations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('An error occurred. Please try again.'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No reservations found.'));
            }

            final reservations = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Parking Area ID: ${reservation['parkingAreaId']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Start Time: ${reservation['startTime']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'End Time: ${reservation['endTime']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Fee: ${reservation['fee']} EG',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Payment Method: ${reservation['paymentMethod']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
