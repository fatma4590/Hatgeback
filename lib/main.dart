import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hatgeback/screens/addpoint.dart';
import 'package:hatgeback/screens/homepage.dart';
import 'package:hatgeback/screens/loginscreen.dart';
import 'package:hatgeback/screens/registerpage.dart';
import 'package:hatgeback/screens/userprofile.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
      routes: {

        loginscreen.id:(context)=>loginscreen(),
        homepage.id: (context) => homepage(),
        registerpage.id: (context)=>registerpage(),
        addpoint.id:(context)=>addpoint(),
        UserProfile.id:(context)=>UserProfile(),

      },
      initialRoute: loginscreen.id,
    );
  }
}


