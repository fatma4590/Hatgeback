import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/Helper/textbox.dart';

class UserProfile extends StatefulWidget {
  static String id = 'userprofile';

  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

// edit
  Future<void> editField(String field) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile Page"),
        backgroundColor: Colors.black26,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          //get user data
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic?>;
            return ListView(
              children: [
                const SizedBox(height: 50),
                // profile pic
                const Icon(
                  Icons.person,
                  color: Colors.green,
                  size: 72,
                ),
                const SizedBox(height: 10),
                // user email
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green),
                ),
                const SizedBox(height: 50),
                //user details
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Details',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
                // username
                MyTextBox(
                  text: userData['username'],
                  SectionName: 'User Name',
                  onPressed: () => editField('username'),
                ),
                // phone
                MyTextBox(
                    text: userData['phone'],
                    SectionName: 'phone',
                    onPressed: () => editField('phone')),
                //password
                MyTextBox(
                  text: userData['password'],
                  SectionName: 'Password',
                  onPressed: () => editField('password '),
                ),

                MyTextBox(
                  text: userData['address'],
                  SectionName: 'Address',
                  onPressed: () => editField('address'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error' + snapshot.error.toString()),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}