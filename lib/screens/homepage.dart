//momen old home
/* import 'package:cloud_firestore/cloud_firestore.dart';
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
    Text('Price per hour: ${parking['price']}'),
    Text('StartDate: ${parking['startDate'].toDate()}'),
    Text('endDate: ${parking['endDate'].toDate()}'),
    ],
    ));}),
      //momen parjing_widget
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
me but the parking area design is not true
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/screens/addpoint.dart';
import 'package:hatgeback/screens/myparking.dart';
import 'package:hatgeback/screens/userprofile.dart';
import 'package:hatgeback/screens/ReservationScreen.dart';
import 'package:intl/intl.dart';

class homepage extends StatefulWidget {
  static String id = 'homepage';

  homepage({Key? key}) : super(key: key);

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<Map<String, dynamic>> _parkingAreas = [];

  Future<void> _fetchParkingAreas() async {
    final db = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final QuerySnapshot snapshot = await db
        .collection('parkingareas')
        .get();
    final List<Map<String, dynamic>> list = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    setState(() {
      _parkingAreas = list;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchParkingAreas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F3E9),
      appBar: AppBar(
        title: Text("Home Page"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xFF33AD60),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  "Parking Areas",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33AD60),
                  ),
                ),
                SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemCount: _parkingAreas.length,
                  itemBuilder: (context, index) {
                    var parking = _parkingAreas[index];
                    return Container(
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Container(
                              height: 150,
                              width: double.infinity,
                              child: Image.network(
                                'https://example.com/image.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    parking['Name'] != null
                                        ? parking['Name']
                                        : '',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF33AD60),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    parking['Location'] != null
                                        ? "Location: ${parking['Location']}"
                                        : '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    parking['price'] != null
                                        ? "Price: ${parking['price']}"
                                        : '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    parking['startDate'] != null
                                        ? "Start Date: ${DateFormat('MM/dd/yyyy HH:mm').format(parking['startDate'].toDate())}"
                                        : '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    parking['endDate'] != null
                                        ? "End Date: ${DateFormat('MM/dd/yyyy HH:mm').format(parking['endDate'].toDate())}"
                                        : '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  parking['isAvailable'] == true
                                      ? Container()
                                      : Container(
                                    color: Colors.grey.withOpacity(0.5),
                                    child: Center(
                                      child: Text(
                                        'Unavailable',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReservationScreen(parkingArea: {},
                                          ),
                                        ),
                                      );
                                    },
                                    /* onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: Column(
                                              children: [/* here fatam*/ ],
                                            ),
                                          );
                                        },
                                      );
                                    },*/
                                    child: Text(
                                      "Reserve",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, UserProfile.id);
                },
                icon: Icon(
                  Icons.account_circle_sharp,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, addpoint.id);
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, myparking.id);
                },
                icon: Icon(
                  Icons.paste_rounded,
                  color: Colors.black,
                )),
          ],
        ),
      ),
    );
  }
}
*/









/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/screens/ReservationScreen.dart';
import 'package:hatgeback/screens/addpoint.dart';
import 'package:hatgeback/screens/loginscreen.dart';
import 'package:hatgeback/screens/myparking.dart';
import 'package:hatgeback/screens/userprofile.dart';
import 'package:intl/intl.dart';

class homepage extends StatefulWidget {
  static String id = 'homepage';

  homepage({Key? key}) : super(key: key);

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<Map<String, dynamic>> _parkingAreas = [];

  Future<void> _fetchParkingAreas() async {
    final db = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final QuerySnapshot snapshot = await db.collection('parkingareas').get();
    final List<Map<String, dynamic>> list =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    setState(() {
      _parkingAreas = list;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchParkingAreas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F3E9),
      appBar: AppBar(
        title: Text("Home Page"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xFF33AD60),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  "Parking Areas",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33AD60),
                  ),
                ),
                SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _parkingAreas.length,
                  itemBuilder: (context, index) {
                    var parking = _parkingAreas[index];
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
                          SizedBox(height: 10),
                          Container(
                            height: 150,
                            width: double.infinity,
                            child: Image.network(
                              'https://example.com/image.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  parking['Name'] != null
                                      ? parking['Name']
                                      : '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF33AD60),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  parking['Location'] != null
                                      ? "Location: ${parking['Location']}"
                                      : '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  parking['price'] != null
                                      ? "Price: ${parking['price']}"
                                      : '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  parking['startDate'] != null
                                      ? "Start Date: ${DateFormat('MM/dd/yyyy HH:mm').format(parking['startDate'].toDate())}"
                                      : '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  parking['endDate'] != null
                                      ? "End Date: ${DateFormat('MM/dd/yyyy HH:mm').format(parking['endDate'].toDate())}"
                                      : '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 10),
                                parking['isAvailable'] == true
                                    ? Container()
                                    : Container(
                                        color: Colors.grey.withOpacity(0.5),
                                        child: Center(
                                          child: Text(
                                            'Unavailable',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                ElevatedButton(
                                  onPressed: parking['isAvailable'] == true
                                      ? () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReservationScreen(
                                                parkingArea: parking,
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                  child: Text(
                                    "Reserve",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    // onSurface: Colors.grey, // Color when the button is disabled
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, UserProfile.id);
                },
                icon: Icon(
                  Icons.account_circle_sharp,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, addpoint.id);
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, myparking.id);
                },
                icon: Icon(
                  Icons.paste_rounded,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => loginscreen()),
                  );
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                )),
          ],
        ),
      ),
    );
  }
}*/






















/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/screens/ReservationScreen.dart';
import 'package:hatgeback/screens/addpoint.dart';
import 'package:hatgeback/screens/loginscreen.dart';
import 'package:hatgeback/screens/myparking.dart';
import 'package:hatgeback/screens/userprofile.dart';
import 'package:intl/intl.dart';

class homepage extends StatefulWidget {
  static String id = 'homepage';

  homepage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<homepage> {
  List<Map<String, dynamic>> _parkingAreas = [];

  Future<void> _fetchParkingAreas() async {
    final db = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final QuerySnapshot snapshot = await db.collection('parkingareas').get();
    final List<Map<String, dynamic>> list =
    snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    setState(() {
      _parkingAreas = list.where((parking) {
        final startDate = parking['startDate'].toDate();
        final endDate = parking['endDate'].toDate();
        final now = DateTime.now();
        final currentDateTime = DateTime(now.year, now.month, now.day);
        final startDateWithoutTime = DateTime(startDate.year, startDate.month, startDate.day);
        final endDateWithoutTime = DateTime(endDate.year, endDate.month, endDate.day);

        return  startDateWithoutTime == currentDateTime
            && endDateWithoutTime == currentDateTime;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchParkingAreas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F3E9),
      appBar: AppBar(
        title: Text("Home Page"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xFF33AD60),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  "Parking Areas",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33AD60),
                  ),
                ),
                SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _parkingAreas.length,
                  itemBuilder: (context, index) {
                    var parking = _parkingAreas[index];
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
                          SizedBox(height: 10),
                          Container(
                            height: 150,
                            width: double.infinity,
                            child: Image.network(
                              'https://example.com/image.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  parking['Name'] != null
                                      ? parking['Name']
                                      : '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF33AD60),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  parking['Location'] != null
                                      ? "Location: ${parking['Location']}"
                                      : '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  parking['price'] != null
                                      ? "Price: ${parking['price']}"
                                      : '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  parking['startDate'] != null
                                      ? "Start Date: ${DateFormat('MM/dd/yyyy HH:mm').format(parking['startDate'].toDate())}"
                                      : '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height:10),
                                Text(
                                  parking['endDate'] != null
                                      ? "End Date: ${DateFormat('MM/dd/yyyy HH:mm').format(parking['endDate'].toDate())}"
                                      : '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 10),
                                parking['isAvailable'] == true
                                    ? Container()
                                    : Container(
                                  color: Colors.grey.withOpacity(0.5),
                                  child: Center(
                                    child: Text(
                                      'Unavailable',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: parking['isAvailable'] == true
                                      ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReservationScreen(
                                              parkingArea: parking,
                                            ),
                                      ),
                                    );
                                  }
                                      : null,
                                  child: Text(
                                    "Reserve",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    // onSurface: Colors.grey, // Color when the button is disabled
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, UserProfile.id);
                },
                icon: Icon(
                  Icons.account_circle_sharp,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, addpoint.id);
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, myparking.id);
                },
                icon: Icon(
                  Icons.paste_rounded,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => loginscreen()),
                  );
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                )),
          ],
        ),
      ),
    );
  }
}*/


















import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/screens/ReservationScreen.dart';
import 'package:hatgeback/screens/addpoint.dart';
import 'package:hatgeback/screens/loginscreen.dart';
import 'package:hatgeback/screens/myparking.dart';
import 'package:hatgeback/screens/userprofile.dart';
import 'package:intl/intl.dart';

class homepage extends StatefulWidget {
  static String id = 'homepage';

  homepage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<homepage> {
  List<Map<String, dynamic>> _parkingAreas = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _fetchParkingAreas() async {
    final db = FirebaseFirestore.instance;
    final QuerySnapshot snapshot = await db.collection('parkingareas').get();
    final List<Map<String, dynamic>> list =
    snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    setState(() {
      _parkingAreas = list.where((parking) {
        final startDate = parking['startDate'].toDate();
        final endDate = parking['endDate'].toDate();
        final now = DateTime.now();
        final currentDateTime = DateTime(now.year, now.month, now.day);
        final startDateWithoutTime = DateTime(startDate.year, startDate.month, startDate.day);
        final endDateWithoutTime = DateTime(endDate.year, endDate.month, endDate.day);

        return startDateWithoutTime == currentDateTime && endDateWithoutTime == currentDateTime;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchParkingAreas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F3E9),
      appBar: AppBar(
        title: Text("Home Page"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xFF33AD60),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  "Parking Areas",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33AD60),
                  ),
                ),
                SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _parkingAreas.length,
                  itemBuilder: (context, index) {
                    var parking = _parkingAreas[index];
                    final bool isUserParkingArea = parking['userid'] == _auth.currentUser?.email;
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
                          SizedBox(height: 10),
                          Container(
                            height: 150,
                            width: double.infinity,
                            child: Image.network(
                              'https://example.com/image.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  parking['Name'] != null ? parking['Name'] : '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF33AD60),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  parking['Location'] != null
                                      ? "Location: ${parking['Location']}"
                                      : '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  parking['price'] != null
                                      ? "Price: ${parking['price']}"
                                      : '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  parking['startDate'] != null
                                      ? "Start Date: ${DateFormat('MM/dd/yyyy HH:mm').format(parking['startDate'].toDate())}"
                                      : '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  parking['endDate'] != null
                                      ? "End Date: ${DateFormat('MM/dd/yyyy HH:mm').format(parking['endDate'].toDate())}"
                                      : '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 10),
                                parking['isAvailable'] == true
                                    ? Container()
                                    : Container(
                                  color: Colors.grey.withOpacity(0.5),
                                  child: Center(
                                    child: Text(
                                      'Unavailable',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                if (!isUserParkingArea) // Show the reservation button only if it's not the user's parking area
                                  ElevatedButton(
                                    onPressed: parking['isAvailable'] == true
                                        ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReservationScreen(
                                            parkingArea: parking,
                                          ),
                                        ),
                                      );
                                    }
                                        : null,
                                    child: Text(
                                      "Reserve",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      // onSurface: Colors.grey, // Color when the button is disabled
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, UserProfile.id);
                },
                icon: Icon(
                  Icons.account_circle_sharp,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, addpoint.id);
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, myparking.id);
                },
                icon: Icon(
                  Icons.paste_rounded,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => loginscreen()),
                  );
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                )),
          ],
        ),
      ),
    );
  }
}
