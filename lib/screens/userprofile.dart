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
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class UserProfile extends StatefulWidget {
//   static String id = 'userprofile';
//
//   const UserProfile({Key? key}) : super(key: key);
//
//   @override
//   State<UserProfile> createState() => _UserProfileState();
// }
//
// class _UserProfileState extends State<UserProfile> {
//   final currentUser = FirebaseAuth.instance.currentUser!;
//
//   Future<void> editField(String field, String value) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc(currentUser.email)
//           .update({field: value});
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('$field updated successfully.'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       print("Error updating $field: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update $field. Please try again.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text("Profile Page"),
//         backgroundColor: Colors.black26,
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("users")
//             .doc(currentUser.email)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//           if (snapshot.hasData) {
//             final userData =
//             snapshot.data!.data() as Map<String, dynamic>;
//             return ListView(
//               children: [
//                 const SizedBox(height: 50),
//                 const Icon(
//                   Icons.person,
//                   color: Colors.green,
//                   size: 72,
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   currentUser.email!,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.green),
//                 ),
//                 const SizedBox(height: 50),
//                 _buildProfileField('username', userData['username'] ?? ''),
//                 _buildProfileField('phone', userData['phone'] ?? ''),
//                 _buildChangePasswordButton(),
//                 _buildProfileField('address', userData['address'] ?? ''),
//               ],
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error.toString()}'),
//             );
//           }
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildProfileField(String field, String value) {
//     return ListTile(
//       title: Text(
//         value.isEmpty ? '[Hidden]' : value,
//         style: TextStyle(
//           fontSize: 16,
//           color: Colors.black87,
//         ),
//       ),
//       trailing: IconButton(
//         icon: Icon(Icons.edit, color: Colors.green),
//         onPressed: () {
//           _editFieldDialog(field, value);
//         },
//       ),
//     );
//   }
//
//   Future<void> _editFieldDialog(String field, String initialValue) async {
//     TextEditingController controller = TextEditingController(
//         text: initialValue);
//
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Edit $field'),
//           content: TextField(
//             controller: controller,
//             decoration: InputDecoration(labelText: field),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 String newValue = controller.text.trim();
//                 if (newValue.isNotEmpty && newValue != initialValue) {
//                   editField(field, newValue);
//                 }
//                 Navigator.pop(context);
//               },
//               child: Text('Save'),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white, backgroundColor: Colors.green,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildChangePasswordButton() {
//     return ListTile(
//       title: Text(
//         'Change Password',
//         style: TextStyle(
//           fontSize: 16,
//           color: Colors.black87,
//         ),
//       ),
//       trailing: IconButton(
//         icon: Icon(Icons.edit, color: Colors.green),
//         onPressed: () {
//           _showChangePasswordDialog();
//         },
//       ),
//     );
//   }
//
//   Future<void> _showChangePasswordDialog() async {
//     TextEditingController newPasswordController = TextEditingController();
//     TextEditingController currentPasswordController = TextEditingController();
//
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Change Password'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: currentPasswordController,
//                 decoration: InputDecoration(labelText: 'Current Password'),
//                 obscureText: true,
//               ),
//               TextField(
//                 controller: newPasswordController,
//                 decoration: InputDecoration(labelText: 'New Password'),
//                 obscureText: true,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 String currentPassword = currentPasswordController.text.trim();
//                 String newPassword = newPasswordController.text.trim();
//                 if (newPassword.isNotEmpty) {
//                   _validatePassword(newPassword);
//                   _updatePassword(newPassword, currentPassword);
//                 }
//                 Navigator.pop(context);
//               },
//               child: Text('Change'),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white, backgroundColor: Colors.green,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _updatePassword(String newPassword,
//       String currentPassword) async {
//     try {
//       // Re-authenticate user with current password before updating password
//       await _reauthenticateUser(currentPassword);
//
//       // Validate new password
//       _validatePassword(newPassword);
//
//       // Update password in Firebase Authentication
//       await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
//
//       // Update password in Firestore user document
//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc(currentUser.email)
//           .update({'password': newPassword});
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Password updated successfully.'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       print("Error updating password: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update password. Please try again.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//
//   Future<void> _reauthenticateUser(String currentPassword) async {
//     try {
//       AuthCredential credential = EmailAuthProvider.credential(
//         email: currentUser.email!,
//         password: currentPassword,
//       );
//       await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(
//           credential);
//     } catch (e) {
//       throw FirebaseAuthException(
//           code: 'wrong-password', message: 'Incorrect current password.');
//     }
//   }
//
//   void _validatePassword(String newPassword) {
//     if (newPassword.length < 6 ||
//         !newPassword.contains(RegExp(r'[A-Z]')) ||
//         !newPassword.contains(RegExp(r'[a-z]')) ||
//         !newPassword.contains(RegExp(r'[0-9]'))) {
//       throw Exception(
//           'Password must be at least 6 characters long and contain at least one uppercase letter, one lowercase letter, and one digit.');
//     }
//   }
// }
//
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
                _buildProfileField('username', userData['username']?? ''),
                _buildProfileField('phone', userData['phone']?? ''),
                _buildChangePasswordButton(),
                _buildProfileField('address', userData['address']?? ''),
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

  Widget _buildProfileField(String field, String value) {
    return ListTile(
      title: Text(
        value.isEmpty? '[Hidden]' : value,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit, color: Colors.green),
        onPressed: () {
          _editFieldDialog(field, value);
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
                  if (field == 'phone') {
                    if (_validatePhoneNumber(newValue)) {
                      editField(field, newValue);
                    } else {
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
    return phoneNumber.length == 11 && phoneNumber.replaceAll(RegExp(r'[^\d]'), '') == phoneNumber;
  }

  Widget _buildChangePasswordButton() {
    return ListTile(
      title: Text(
        'Change Password',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit, color: Colors.green),
        onPressed: () {
          _showChangePasswordDialog();
        },
      ),
    );
  }

  Future<void> _showChangePasswordDialog() async {
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController currentPasswordController = TextEditingController();

    await showDialog(
    context: context,
    builder: (context) {
    return AlertDialog(
    title: Text('Change Password'),
    content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    TextField(
    controller: currentPasswordController,
    decoration: InputDecoration(labelText: 'Current Password'),
    obscureText: true,
    ),
    TextField(
    controller: newPasswordController,
    decoration: InputDecoration(labelText: 'New Password'),
    obscureText: true,
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
    String currentPassword = currentPasswordController.text.trim();
    String newPassword = newPasswordController.text.trim();
    if (newPassword.isNotEmpty) {
    if (newPassword == currentPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('New password cannot be the same as the current password.'),
    backgroundColor: Colors.red,
    ),
    );
    } else if (newPassword.length < 6) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('New password must be at least 6 characters long.'),
    backgroundColor: Colors.red,
    ),
    );
    }else if (!newPassword.contains(RegExp(r'[A-Z]')) ||
      !newPassword.contains(RegExp(r'[a-z]')) ||
      !newPassword.contains(RegExp(r'[0-9]'))) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
      content: Text('New password must be at least one capital , one small and one number.'),
      backgroundColor: Colors.red,
      ),
      );
      }
     else {
    _updatePassword(newPassword, currentPassword);
    }
         };
    Navigator.pop(context);
    },
    child: Text('Change'),
    style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Colors.green,
    ),
    ),
    ],
    );
    },
    );
  }

  Future<void> _updatePassword(String newPassword,
      String currentPassword) async {
    try {
      // Re-authenticate user with current password before updating password
      await _reauthenticateUser(currentPassword);

      // Validate new password
      _validatePassword(newPassword);

      // Update password in Firebase Authentication
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);

      // Update password in Firestore user document
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.email)
          .update({'password': newPassword});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error updating password: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update password. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _reauthenticateUser(String currentPassword) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: currentPassword,
      );
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(
          credential);
    } catch (e) {
      throw FirebaseAuthException(
          code: 'wrong-password', message: 'Incorrect current password.');
    }
  }

  void _validatePassword(String newPassword) {
    if (newPassword.length < 6 ||
        !newPassword.contains(RegExp(r'[A-Z]')) ||
        !newPassword.contains(RegExp(r'[a-z]')) ||
        !newPassword.contains(RegExp(r'[0-9]'))) {
      throw Exception(
          'Password must be at least 6 characters long and contain at least one uppercase letter, one lowercase letter, and one digit.');
    }
  }
}