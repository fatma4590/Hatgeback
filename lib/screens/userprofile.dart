// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:hatgeback/Helper/textbox.dart';
//
// class UserProfile extends StatefulWidget {
//   static String id = 'userprofile';
//
//   const UserProfile({super.key});
//
//   @override
//   State<UserProfile> createState() => _UserProfileState();
// }
//
// class _UserProfileState extends State<UserProfile> {
//   // user
//   final currentUser = FirebaseAuth.instance.currentUser!;
//
// // edit
//   Future<void> editField(String field) async {}
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: Text("Profile Page"),
//           backgroundColor: Colors.black26,
//         ),
//         body: StreamBuilder<DocumentSnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection("users")
//               .doc(currentUser.email)
//               .snapshots(),
//           builder: (context, snapshot) {
//             //get user data
//             if (snapshot.hasData) {
//               final userData = snapshot.data!.data() as Map<String, dynamic?>;
//               return ListView(
//                 children: [
//                   const SizedBox(height: 50),
//                   // profile pic
//                   const Icon(
//                     Icons.person,
//                     color: Colors.green,
//                     size: 72,
//                   ),
//                   const SizedBox(height: 10),
//                   // user email
//                   Text(
//                     currentUser.email!,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.green),
//                   ),
//                   const SizedBox(height: 50),
//                   //user details
//                   Padding(
//                     padding: const EdgeInsets.only(left: 25.0),
//                     child: Text(
//                       'My Details',
//                       style: TextStyle(
//                           color: Colors.green, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   // username
//                   MyTextBox(
//                     text: userData['username'],
//                     SectionName: 'User Name',
//                     onPressed: () => editField('username'),
//                   ),
//                   // phone
//                   MyTextBox(
//                       text: userData['phone'],
//                       SectionName: 'phone',
//                       onPressed: () => editField('phone')),
//                   //password
//                   MyTextBox(
//                     text: userData['password'],
//                     SectionName: 'Password',
//                     onPressed: () => editField('password '),
//                   ),
//
//                   MyTextBox(
//                     text: userData['address'],
//                     SectionName: 'Address',
//                     onPressed: () => editField('address'),
//                   ),
//                 ],
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text('Error' + snapshot.error.toString()),
//               );
//             }
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatefulWidget {
  static String id = 'userprofile';

  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  void _editEmailDialog(String initialValue) {
    TextEditingController controller = TextEditingController(text: initialValue);
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller,
                decoration: InputDecoration(labelText: 'New Email'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String newEmail = controller.text.trim();
                String currentPassword = passwordController.text.trim();

                try {
                  // Re-authenticate user before updating email
                  await _reauthenticateUser(currentPassword);

                  // Check if the new email is different from the current email
                  if (newEmail != FirebaseAuth.instance.currentUser!.email) {
                    // Update email in Firebase Authentication
                    await FirebaseAuth.instance.currentUser!.updateEmail(newEmail);

                    // Update email in Firestore user document
                    await FirebaseFirestore.instance.collection("users").doc(currentUser.email).update({'email': newEmail});

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Email updated successfully.'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.pop(context); // Close dialog
                  } else {
                    // New email is the same as the current email
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('New email must be different from the current email.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  print('Failed to update email: $e');
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update email: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _reauthenticateUser(String currentPassword) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: currentPassword,
      );
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
    } catch (e) {
      throw FirebaseAuthException(code: 'wrong-password', message: 'Incorrect current password.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile Page"),
        backgroundColor: Colors.black26,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("users").doc(currentUser.email).snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.person,
                      size: 72,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    title: Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(currentUser.email!),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.green),
                      onPressed: () {
                        _editEmailDialog(currentUser.email!);
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  ListTile(
                    title: Text(
                      'My Details',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Username'),
                    subtitle: Text(userData['username'] ?? ''),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.green),
                      onPressed: () {
                        // Implement edit username functionality
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Phone'),
                    subtitle: Text(userData['phone'] ?? ''),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.green),
                      onPressed: () {
                        // Implement edit phone functionality
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Address'),
                    subtitle: Text(userData['address'] ?? ''),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.green),
                      onPressed: () {
                        // Implement edit address functionality
                      },
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error.toString()}'),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
