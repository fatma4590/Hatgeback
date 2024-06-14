// shery old code
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
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Profile Page"),
          centerTitle: true,
          backgroundColor: Colors.black26,
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(currentUser.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Text('No user data found.'),
              );
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>?;

            if (userData == null) {
              return Center(
                child: Text('No user data found.'),
              );
            }

            // Set initial values from Firestore
            _usernameController.text = userData['username'] ?? '';
            _phoneController.text = userData['phone'] ?? '';
            _passwordController.text = ''; // Clear password field
            _addressController.text = userData['address'] ?? '';

            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              children: [
                SizedBox(height: 50),
                // Profile pic (you can use a real profile picture here)
                Icon(
                  Icons.person,
                  color: Colors.green,
                  size: 72,
                ),
                SizedBox(height: 10),
                // User email
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green),
                ),
                SizedBox(height: 50),
                // Editable fields
                buildEditableField(
                  'username',
                  'User Name',
                  _usernameController,
                ),
                buildEditableField(
                  'phone',
                  'Phone',
                  _phoneController,
                ),
                buildPasswordChangeField(),
                buildEditableField(
                  'address',
                  'Address',
                  _addressController,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildEditableField(
      String fieldKey, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$label: ${controller.text}',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Edit $label'),
                  content: TextFormField(
                    controller: controller,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Save changes to Firestore
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(currentUser.email)
                            .update({fieldKey: controller.text});

                        Navigator.of(context).pop();
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildPasswordChangeField() {
    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Password: ********', // Display masked password
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Text('Change Password'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: oldPasswordController,
                            decoration:
                                InputDecoration(labelText: 'Current Password'),
                            obscureText: true,
                          ),
                          TextFormField(
                            controller: newPasswordController,
                            decoration:
                                InputDecoration(labelText: 'New Password'),
                            obscureText: true,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            String oldPassword = oldPasswordController.text;
                            String newPassword = newPasswordController.text;

                            // Validate the new password
                            if (newPassword.length < 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Password must be at least 6 characters')),
                              );
                              return;
                            }
                            if (!newPassword.contains(RegExp(r'[A-Z]')) ||
                                !newPassword.contains(RegExp(r'[a-z]')) ||
                                !newPassword.contains(RegExp(r'[0-9]'))) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Password must include at least one uppercase letter, one lowercase letter, and one digit')),
                              );
                              return;
                            }
                            if (newPassword == oldPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'New password must be different from old password')),
                              );
                              return;
                            }

                            try {
                              // Re-authenticate user to verify old password
                              AuthCredential credential =
                                  EmailAuthProvider.credential(
                                email: currentUser.email!,
                                password: oldPassword,
                              );

                              await currentUser
                                  .reauthenticateWithCredential(credential);

                              // Update password in Firebase Authentication
                              await currentUser.updatePassword(newPassword);

                              // Update password in Firestore (optional)
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(currentUser.email)
                                  .update({'password': newPassword});

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Password updated successfully')),
                              );

                              Navigator.of(context).pop(); // Close dialog
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Failed to update password')),
                              );
                            }
                          },
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
