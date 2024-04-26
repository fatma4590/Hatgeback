import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingService {
  final CollectionReference _parkingAreasRef =
  FirebaseFirestore.instance.collection('parking_areas');

  // Retrieve parking areas data for the logged-in user
  Future<List<DocumentSnapshot>> getParkingAreasForUser(String userId) async {
    try {
      QuerySnapshot querySnapshot =
      await _parkingAreasRef.where('userId', isEqualTo: userId).get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error retrieving parking areas: $e');
      return [];
    }
  }
}
