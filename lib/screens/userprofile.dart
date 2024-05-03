//shery old code
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
//                     onPressed: () => editField('username'), sectionName: '',
//                   ),
//                   // phone
//                   MyTextBox(
//                       text: userData['phone'],
//                       SectionName: 'phone',
//                       onPressed: () => editField('phone'), sectionName: '',),
//                   //password
//                   MyTextBox(
//                     text: userData['password'],
//                     SectionName: 'Password',
//                     onPressed: () => editField('password '), sectionName: '',
//                   ),
//
//                   MyTextBox(
//                     text: userData['address'],
//                     SectionName: 'Address',
//                     onPressed: () => editField('address'), sectionName: '',
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  static String id = 'userprofile';

  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> editField(String field, String value) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.email)
          .update({field: value});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$field updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error updating $field: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update $field. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            final userData =
            snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.person,
                  color: Colors.green,
                  size: 72,
                ),
                const SizedBox(height: 10),
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green),
                ),
                const SizedBox(height: 50),
                _buildProfileField('Username', 'Username:', userData['username']?? ''),
                _buildProfileField('Phone Number', 'Phone Number:', userData['phone']?? ''),
                _buildChangePasswordButton(),
                _buildProfileField('Address', 'Address:', userData['address']?? ''),
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
    );
  }

  Widget _buildProfileField(String fieldName, String label, String value) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        value.isEmpty? '[Hidden]' : value,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit, color: Colors.green),
        onPressed: () {
          _editFieldDialog(fieldName, value);
        },
      ),
    );
  }

  Future<void> _editFieldDialog(String field, String initialValue) async {
    TextEditingController controller = TextEditingController(
        text: initialValue);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: field),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String newValue = controller.text.trim();
                if (newValue.isNotEmpty && newValue!= initialValue) {
                  if (field == 'Phone Number') {
                    if (_validatePhoneNumber(newValue)) {
                      editField(field, newValue);
                    } else if (RegExp(r"^\+?0[0-9]{10}$").hasMatch(newValue)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Phone number must be 11 digits numeric.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    editField(field, newValue);
                  }
                }
                Navigator.pop(context);
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }

  bool _validatePhoneNumber(String phoneNumber) {
    return phoneNumber.length == 11 && phoneNumber.replaceAll(RegExp(r"^\+?0[0-9]{10}$"), '') == phoneNumber;
  }

  Widget _buildChangePasswordButton() {
    return ListTile(
      title: Text(
        'Password :\n*******',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit, color: Colors.green),
        onPressed: () {
          _changePasswordDialog();
        },
      ),
    );
  }

  Future<void> _changePasswordDialog() async {
    String newPassword = '';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                onChanged: (value) {
                  newPassword = value;
                },
                decoration: InputDecoration(labelText: 'New Password'),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  if (value != newPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Passwords do not match.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                decoration: InputDecoration(labelText: 'Confirm New Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newPassword.isNotEmpty) {
                  editField('Password', newPassword);
                }
                Navigator.pop(context);
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }
}