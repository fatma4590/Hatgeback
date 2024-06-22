/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'EditParkingScreen.dart';

class myparking extends StatefulWidget {
  static String id = 'myparking';

  myparking({Key? key}) : super(key: key);

  @override
  State<myparking> createState() => _myparkingareasState();
}

class _myparkingareasState extends State<myparking> {
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
        backgroundColor: Colors.black26,
        title: Text('My Parking Areas'),
        titleTextStyle: TextStyle(
          color: Colors.black,

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
                Text('Price: ${parking['price']}'),
                Text('StartDate: ${parking['startDate'].toString()}'),
                Text('endDate: ${parking['endDate'].toString()}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
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
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Show confirmation dialog and delete parking area
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm Deletion'),
                        content: Text('Are you sure you want to delete this parking area?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              var db = FirebaseFirestore.instance;
                              // Delete the Firestore document corresponding to the parking area
                              try {
                                await db.collection('parkingareas').doc(parking['docId']).delete();
                                Navigator.pop(context); // Close the dialog
                                // Optionally, update the UI to reflect the deletion
                                setState(() {
                                  parkingareas.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Parking area deleted successfully'),
                                ));
                              } catch (e) {
                                print('Error deleting parking area: $e');
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Failed to delete parking area. Please try again.'),
                                ));
                              }
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),

    );

  }
}*/









/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'EditParkingScreen.dart';

class myparking extends StatefulWidget {
  static String id = 'fatma';

  myparking({Key? key}) : super(key: key);

  @override
  State<myparking> createState() => _myparkingareasState();
}

class _myparkingareasState extends State<myparking> {
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
//       body: ListView.builder(
//         itemCount: parkingareas.length,
//         itemBuilder: (context, index) {
//           var parking = parkingareas[index];
//           return ListTile(
//             title: Text(parking['Name']),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Location: ${parking['Location']}'),
//                 Text('Price: ${parking['price'].toString()}'),
//                 Text('startDate: ${parking['startDate'].toString()}'),
//                 Text('endDate: ${parking['endDate'].toString()}'),
//               ],
//             ),
//             trailing: IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: () {
//                 // Navigate to the EditParkingScreen with selected parking details
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => EditParkingScreen(parking: parking),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
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
                Text('Price per hour: ${parking['price']}'),
                Text('StartDate: ${parking['startDate'].toDate()}'),
                Text('endDate: ${parking['endDate'].toDate()}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
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
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Show confirmation dialog and delete parking area
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm Deletion'),
                        content: Text('Are you sure you want to delete this parking area?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              var db = FirebaseFirestore.instance;
                              // Delete the Firestore document corresponding to the parking area
                              try {
                                await db.collection('parkingareas').doc(parking['docId']).delete();
                                Navigator.pop(context); // Close the dialog
                                // Optionally, update the UI to reflect the deletion
                                setState(() {
                                  parkingareas.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Parking area deleted successfully'),
                                ));
                              } catch (e) {
                                print('Error deleting parking area: $e');
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Failed to delete parking area. Please try again.'),
                                ));
                              }
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),

    );

  }
}*/














/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'EditParkingScreen.dart';

class myparking extends StatefulWidget {
  static String id = 'myparking';

  myparking({Key? key}) : super(key: key);

  @override
  State<myparking> createState() => _myparkingareasState();
}

class _myparkingareasState extends State<myparking> {
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
          // Initialize isAvailable to false if it's null
          data['isAvailable'] = data['isAvailable'] ?? false;
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
          bool isAvailable = parking['isAvailable']; // assume 'isAvailable' field exists in Firestore document
          return ListTile(
            title: Text(parking['Name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location: ${parking['Location']}'),
                Text('Price: ${parking['price']}'),
                Text('StartDate: ${parking['startDate'].toString()}'),
                Text('endDate: ${parking['endDate'].toString()}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: isAvailable? Icon(
                    Icons.toggle_on,
                    color: Color.fromRGBO(76, 175, 80, 1),
                    size: 30,
                  ) : Icon(
                    Icons.toggle_off,
                    // color: Color.fromRGBO(76, 175, 80, 1),
                    size: 30,
                  ),
                  onPressed: () async {
                    // Toggle availability status
                    var db = FirebaseFirestore.instance;
                    try {
                      await db.collection('parkingareas').doc(parking['docId']).update({
                        'isAvailable':!isAvailable,
                      });
                      setState(() {
                        parkingareas[index]['isAvailable'] =!isAvailable;
                      });
                    } catch (e) {
                      print('Error updating availability status: $e');
                    }
                  },
                ),
                IconButton(
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

                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Show confirmation dialog and delete parking area
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm Deletion'),
                        content: Text('Are you sure you want to delete this parking area?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              var db = FirebaseFirestore.instance;
                              // Delete the Firestore document corresponding to the parking area
                              try {
                                await db.collection('parkingareas').doc(parking['docId']).delete();
                                Navigator.pop(context); // Close the dialog
                                // Optionally, update the UI to reflect the deletion
                                setState(() {
                                  parkingareas.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Parking area deleted successfully'),
                                ));
                              } catch (e) {
                                print('Error deleting parking area: $e');
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Failed to delete parking area. Please try again.'),
                                ));
                              }
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}*/










import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hatgeback/screens/EditParkingScreen.dart';
import 'package:hatgeback/widgets/base_screen.dart';

class myparking extends StatefulWidget {
  static String id = 'myparking';

  @override
  State<myparking> createState() => _MyParkingAreasState();
}

class _MyParkingAreasState extends State<myparking> {
  List<Map<String, dynamic>> parkingareas = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void getParking() {
    var db = FirebaseFirestore.instance;

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
          // Initialize isAvailable to false if it's null
          data['isAvailable'] = data['isAvailable'] ?? false;
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
    return BaseScreen(
      pageTitle: 'My Parking Areas',
      showBackButton: true,
      onBackButtonPressed: () {
        Navigator.of(context).pop(); // Handle back button press as needed
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView.builder(
            itemCount: parkingareas.length,
            itemBuilder: (context, index) {
              var parking = parkingareas[index];
              bool isAvailable = parking['isAvailable']; // assume 'isAvailable' field exists in Firestore document
              return Container(
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        child: Image.network(
                          'https://example.com/image.jpg', // Replace with actual image URL
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      color: Color(0xFFE3F3E9),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            parking['Name'] ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF33AD60),
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Color(0xFF33AD60),
                              ),
                              SizedBox(width: 5),
                              Text(
                                parking['Location'] ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.attach_money,
                                size: 16,
                                color: Color(0xFF33AD60),
                              ),
                              SizedBox(width: 5),
                              Text(
                                parking['price'] != null ? "Price: ${parking['price']}" : '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.date_range,
                                size: 16,
                                color: Color(0xFF33AD60),
                              ),
                              SizedBox(width: 5),
                              Text(
                                parking['startDate'] != null
                                    ? "Start Date: ${DateFormat('MM/dd/yyyy HH:mm').format(parking['startDate'].toDate())}"
                                    : '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.date_range,
                                size: 16,
                                color: Color(0xFF33AD60),
                              ),
                              SizedBox(width: 5),
                              Text(
                                parking['endDate'] != null
                                    ? "End Date: ${DateFormat('MM/dd/yyyy HH:mm').format(parking['endDate'].toDate())}"
                                    : '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: isAvailable
                                ? Icon(
                              Icons.toggle_on,
                              color: Color(0xFF33AD60),
                              size: 30,
                            )
                                : Icon(
                              Icons.toggle_off,
                              size: 30,
                            ),
                            onPressed: () async {
                              // Toggle availability status
                              var db = FirebaseFirestore.instance;
                              try {
                                await db.collection('parkingareas').doc(parking['docId']).update({
                                  'isAvailable': !isAvailable,
                                });
                                setState(() {
                                  parkingareas[index]['isAvailable'] = !isAvailable;
                                });
                              } catch (e) {
                                print('Error updating availability status: $e');
                              }
                            },
                          ),
                          IconButton(
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
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Show confirmation dialog and delete parking area
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Confirm Deletion'),
                                  content: Text('Are you sure you want to delete this parking area?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close the dialog
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        var db = FirebaseFirestore.instance;
                                        // Delete the Firestore document corresponding to the parking area
                                        try {
                                          await db.collection('parkingareas').doc(parking['docId']).delete();
                                          Navigator.pop(context); // Close the dialog
                                          // Optionally, update the UI to reflect the deletion
                                          setState(() {
                                            parkingareas.removeAt(index);
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text('Parking area deleted successfully'),
                                          ));
                                        } catch (e) {
                                          print('Error deleting parking area: $e');
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text('Failed to delete parking area. Please try again.'),
                                          ));
                                        }
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


