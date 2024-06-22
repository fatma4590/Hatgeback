import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hatgeback/screens/loginscreen.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF33AD60),
        title: Text('My Parking Areas'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white), // Changing back arrow color to white
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFE3F3E9),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your e-mail',
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password reset email sent. Check your inbox.'),
                      backgroundColor: Color(0xFF33AD60),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to send password reset email.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => loginscreen()),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.white, // Text color of the button
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF33AD60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
















//Fatma Trail
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import
//
// class ForgotPasswordPage extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Forgot Password'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextFormField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 String email = emailController.text.trim();
//                 try {
//                   await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Password reset email sent. Check your inbox.')),
//                   );
//
//                   // Update user's document in Firestore (NOT RECOMMENDED TO STORE PASSWORDS IN PLAINTEXT)
//                    await updateFirestoreUserPassword(email);
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Failed to send password reset email.')),
//                   );
//                 }
//               },
//               child: Text('Reset Password'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// // NOT RECOMMENDED TO STORE PASSWORDS IN PLAINTEXT
// Future<void> updateFirestoreUserPassword(String email) async {
//   final user = FirebaseAuth.instance.currentUser;
//   final newPassword = 'new_password'; // Get the new password from the user (NOT RECOMMENDED TO STORE PASSWORDS IN PLAINTEXT)
//   final firestore = FirebaseFirestore.instance;
//   final userRef = firestore.collection('users').doc(user?.uid);
//   await userRef.update({'password': newPassword});
// }
// }