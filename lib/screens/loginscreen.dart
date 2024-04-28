//old login
// import 'package:flutter/material.dart';
// import 'package:hatgeback/screens/homepage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:hatgeback/screens/registerpage.dart';
//
// class loginscreen extends StatelessWidget {
//   static String id = 'loginpage';
//
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();
//   GlobalKey<FormState> formkey = GlobalKey();
//   bool _passwordVisible = true;
//   loginscreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child:  Form(
//           key: formkey,
//           child: ListView(
//             children: <Widget>[
//               Container(
//                 child:Image(image: AssetImage('assets/asd.jpg')),
//
//                 height: MediaQuery.of(context).size.height * 0.5,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     bottomRight: Radius.circular(50),
//                     bottomLeft: Radius.circular(50),
//                   ),
//
//                 ),
//               ),
//               Text(
//                 "login Page",
//                 style: TextStyle(
//                     fontSize: 26.0,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white),
//               ),
//               TextFormField(
//                 validator: (data) {
//                   if (data!.isEmpty) {
//                     return "field is empty";
//                   }
//                 },
//                 controller: email,
//                 cursorColor: Colors.black,
//                 showCursor: true,
//                 style: TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                   hintText: "Email",
//                   hintStyle: TextStyle(color: Colors.black, fontSize: 18),
//                 ),
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               TextFormField(
//                 controller: password,
//                 validator: (data) {
//                   if (data!.isEmpty) {
//                     return "field is empty";
//                   }
//                 },
//                 cursorColor: Colors.black,
//                 showCursor: true,
//                 obscureText: _passwordVisible,
//                 decoration: InputDecoration(
//                   hintText: "Password",
//                   hintStyle: TextStyle(color: Colors.black, fontSize: 18),
//                 ),
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               ElevatedButton(
//                   style:
//                   ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                   onPressed: () async {
//                     if (formkey.currentState!.validate()) {
//                       try {
//                         final credential = await FirebaseAuth.instance
//                             .signInWithEmailAndPassword(
//                             email: email.text, password: password.text);
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text("sign in success."),
//                           backgroundColor: Colors.grey,
//                         ));
//                         Navigator.pushNamed(context, homepage.id);
//                       } on FirebaseAuthException catch (e) {
//                         if (e.code == 'user-not-found') {
//                           ScaffoldMessenger.of(context).showSnackBar((SnackBar(
//                             content: Text('No user found for that email.'),
//                           )));
//                         } else if (e.code == 'wrong-password') {
//                           ScaffoldMessenger.of(context).showSnackBar((SnackBar(
//                             content:
//                             Text('Wrong password provided for that user.'),
//                           )));
//                         }
//                       } catch (e) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("there was an error.")));
//                       }
//                     }
//                   },
//                   child: Text(
//                     "log in ",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   )),
//               SizedBox(
//                 height: 11.0,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   //dont have account
//                   Text(
//                     "Don't have an account? ",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   //register
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, registerpage.id);
//                     },
//                     child: Text(
//                       " Register",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hatgeback/screens/registerpage.dart';
import 'package:hatgeback/screens/homepage.dart';

class loginscreen extends StatefulWidget {
  static String id = 'loginpage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<loginscreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F3E9),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/asd.jpg'), // replace with the path to your logo image
                  ),
                  SizedBox(height: 30.0),

                  SizedBox(height: 30.0),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Color(0xFFE3F3E9),
                      prefixIcon: Icon(Icons.email, color: Color(0xFF33AD60)),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Color(0xFFE3F3E9),
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF33AD60)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xFF33AD60),
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                  SizedBox(height:20.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        try{
                          final UserCredential userCredential =
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sign in successful.'),
                              backgroundColor: Color(0xFFE3F3E9),
                            ),
                          );
                          Navigator.pushNamed(context, homepage.id);
                        } on FirebaseAuthException catch (e) {
                          _showErrorDialog('Error signing in.');
                        } catch (e) {
                          _showErrorDialog('Error signing in.');
                        }
                      }
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF33AD60),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      backgroundColor: Color(0xFFE3F3E9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Color(0xFF33AD60)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, registerpage.id);
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Color(0xFF33AD60),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage, style: TextStyle(color: Color(0xFF33AD60))),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}