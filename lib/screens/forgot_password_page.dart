import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Password reset email sent. Check your inbox.')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to send password reset email.')),
                  );
                }
              },
              child: Text('Reset Password'),
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