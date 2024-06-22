//momen old register
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:hatgeback/screens/loginscreen.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
//
// class registerpage extends StatelessWidget {
//   static String id = 'registerpage';
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();
//   TextEditingController phone = TextEditingController();
//   TextEditingController username = TextEditingController();
//   TextEditingController address = TextEditingController();
//   bool _passwordVisible = true;
//   bool isloading = false;
//   GlobalKey<FormState> formkey = GlobalKey();
//   registerpage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ModalProgressHUD(
//       inAsyncCall: isloading,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: Form(
//             key: formkey,
//             child: ListView(
//               children: <Widget>[
//                 Container(
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       bottomRight: Radius.circular(50),
//                       bottomLeft: Radius.circular(50),
//                     ),
//                   ),
//                 ),
//                 Text(
//                   "Register",
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       fontSize: 26.0),
//                 ),
//                 TextFormField(
//                     controller: email,
//                     validator: (data) {
//                       if (data!.isEmpty) {
//                         return "Required";
//                       } else if (!RegExp(
//                               r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                           .hasMatch(data)) {
//                         return 'Enter valid email';
//                       }
//                       return null;
//                     },
//                     cursorColor: Colors.black,
//                     showCursor: true,
//                     style: TextStyle(color: Colors.black),
//                     decoration: InputDecoration(
//                       hintText: "Email",
//                       hintStyle: TextStyle(color: Colors.black, fontSize: 18),
//                     )),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 TextFormField(
//                     controller: password,
//                     validator: (data) {
//                       if (data!.isEmpty) {
//                         return "Required";
//                       } else if (data.length < 6) {
//                         return 'Password must be at least 6 characters.';
//                       } else if (!data.contains(RegExp(r'[A-Z]'))) {
//                         return '• Uppercase letter is missing.';
//                       } else if (!data.contains(RegExp(r'[a-z]'))) {
//                         return '• Lowercase letter is missing.';
//                       } else if (!data.contains(RegExp(r'[0-9]'))) {
//                         return '• Digit is missing';
//                       }
//                       return null;
//                     },
//                     obscureText: _passwordVisible,
//                     cursorColor: Colors.black,
//                     showCursor: true,
//                     style: TextStyle(color: Colors.black),
//                     decoration: InputDecoration(
//                       hintText: "Password",
//                       hintStyle: TextStyle(color: Colors.black, fontSize: 18),
//                     )),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 TextFormField(
//                     controller: username,
//                     validator: (data) {
//                       if (data!.isEmpty) {
//                         return "Required";
//                       }
//                       return null;
//                     },
//                     cursorColor: Colors.black,
//                     showCursor: true,
//                     style: TextStyle(color: Colors.black),
//                     decoration: InputDecoration(
//                       hintText: "User Name",
//                       hintStyle: TextStyle(color: Colors.black, fontSize: 18),
//                     )),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 TextFormField(
//                     controller: phone,
//                     validator: (data) {
//                       if (data!.isEmpty) {
//                         return "Required";
//                       } else if (!data.isEmpty ||
//                           RegExp(r"^\+?0[0-9]{10}$").hasMatch(data)) {
//                         return null;
//                       }
//                       return null;
//                     },
//                     cursorColor: Colors.black,
//                     showCursor: true,
//                     style: TextStyle(color: Colors.black),
//                     decoration: InputDecoration(
//                       hintText: "Phone",
//                       hintStyle: TextStyle(color: Colors.black, fontSize: 18),
//                     )),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 TextFormField(
//                     controller: address,
//                     validator: (data) {
//                       if (data!.isEmpty) {
//                         return "Required";
//                       }
//                       return null;
//                     },
//                     cursorColor: Colors.black,
//                     showCursor: true,
//                     style: TextStyle(color: Colors.black),
//                     decoration: InputDecoration(
//                       hintText: "Address",
//                       hintStyle: TextStyle(color: Colors.black, fontSize: 18),
//                     )),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 ElevatedButton(
//                     style:
//                         ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                     onPressed: () async {
//                       if (formkey.currentState!.validate()) {
//                         try {
//                           final Credential = await FirebaseAuth.instance
//                               .createUserWithEmailAndPassword(
//                                   email: email.text, password: password.text);
//                           FirebaseFirestore.instance
//                               .collection('users')
//                               .doc(Credential.user!.email)
//                               .set({
//                             'email': email.text,
//                             'password': password.text,
//                             'username': username.text,
//                             'phone': phone.text,
//                             'address': address.text,
//                           });
//
//                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             content: Text("Sign up success ."),
//                             backgroundColor: Colors.green,
//                           ));
//                           FirebaseAuth.instance.currentUser!
//                               .sendEmailVerification();
//                           Navigator.pushNamed(context, loginscreen.id);
//                         } on FirebaseAuthException catch (e) {
//                           if (e.code == 'weak-password') {
//                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                 content: Text(
//                                     "The password provided is too weak.")));
//                           } else if (e.code == 'email-already-in-use') {
//                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                 content: Text(
//                                     "The account already exists for that email.")));
//                           }
//                         } catch (e) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text("there is an error.")));
//                         }
//                       }
//                     },
//                     child: Text(
//                       "Sign Up ",
//                       style: TextStyle(fontSize: 22, color: Colors.white),
//                     )),
//                 SizedBox(
//                   height: 11.0,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     //dont have account
//                     Text(
//                       "already have account ",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     //register
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pushNamed(context, loginscreen.id);
//                       },
//                       child: Text(
//                         " Login",
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }










import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/screens/loginscreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class registerpage extends StatefulWidget {
  static String id = 'registerpage';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<registerpage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F3E9),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
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
                      child: Image.asset(
                          'assets/CompleteLogo   (1).png'), // replace with the path to your logo image
                    ),
                    SizedBox(height: 30.0),
                    SizedBox(height: 30.0),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required';
                        } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'Enter valid email';
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
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters.';
                        } else if (!value.contains(RegExp(r'[A-Z]'))) {
                          return '• Uppercase letter is missing.';
                        } else if (!value.contains(RegExp(r'[a-z]'))) {
                          return '• Lowercase letter is missing.';
                        } else if (!value.contains(RegExp(r'[0-9]'))) {
                          return '• Digit is missing';
                        }
                        return null;
                      },
                      obscureText:!_passwordVisible,
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
                              _passwordVisible =!_passwordVisible;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: usernameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Username',
                        filled: true,
                        fillColor: Color(0xFFE3F3E9),
                        prefixIcon: Icon(Icons.person, color: Color(0xFF33AD60)),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Phone is required';
                        } else if (!RegExp(r"^\+?0[0-9]{10}$").hasMatch(value)) {
                          return 'Enter valid phone number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Phone',
                        filled: true,
                        fillColor: Color(0xFFE3F3E9),
                        prefixIcon: Icon(Icons.phone, color: Color(0xFF33AD60)),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: addressController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Address is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Address',
                        filled: true,
                        fillColor: Color(0xFFE3F3E9),
                        prefixIcon: Icon(Icons.location_on, color: Color(0xFF33AD60)),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final Credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(Credential.user!.email)
                                .set({
                              'email': emailController.text,
                              'password':passwordController.text,
                              'username': usernameController.text,
                              'phone': phoneController.text,
                              'address': addressController.text,
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Sign up success ."),
                              backgroundColor: Colors.green,
                            ));
                            FirebaseAuth.instance.currentUser!
                                .sendEmailVerification();
                            Navigator.pushNamed(context, loginscreen.id);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "The password provided is too weak.")));
                            } else if (e.code == 'email-already-in-use') {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "The account already exists for that email.")));
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("there is an error.")));
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: Text(
                        "Sign Up ",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        backgroundColor: Color(0xFF33AD60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 11.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //dont have account
                        Text(
                          "already have account ",
                          style: TextStyle(color: Colors.black),
                        ),
                        //register
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, loginscreen.id);
                          },
                          child: Text(
                            " Login",
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}