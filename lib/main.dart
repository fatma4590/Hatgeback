import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/screens/CardDetailsScreen.dart';
//import 'package:hatgeback/screens/accountuser.dart';
import 'package:hatgeback/screens/addpoint.dart';
import 'package:hatgeback/screens/homepage.dart';
import 'package:hatgeback/screens/loginscreen.dart';
import 'package:hatgeback/screens/myReservations.dart';
import 'package:hatgeback/screens/myparking.dart';
import 'package:hatgeback/screens/registerpage.dart';
import 'package:hatgeback/screens/userprofile.dart';
import 'package:hatgeback/payment/payscreen.dart';
import 'package:hatgeback/screens/myReservations.dart';
import 'package:isar/isar.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => mainmyapp();
}

class mainmyapp extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null
          ? loginscreen()
          : homepage(),
      routes: <String, WidgetBuilder>{
        UserProfile.id: (context) => UserProfile(),
        loginscreen.id: (context) => loginscreen(),
        homepage.id: (context) => homepage(),
        registerpage.id: (context) => registerpage(),
        addpoint.id: (context) => addpoint(),
        myparking.id: (context) => myparking(),
        CardDetailsScreen.id: (context) => CardDetailsScreen(),
        payscreen.id: (contexts) => payscreen(),
        myReservations.id: (context) =>myReservations(),
      },
      initialRoute: loginscreen.id,
    );
    //momen to fatma
  }
}
