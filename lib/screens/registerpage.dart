import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hatgeback/screens/loginscreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class registerpage extends StatelessWidget {
  static String id='registerpage';
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController address = TextEditingController();
  bool _passwordVisible = true;
  bool isloading = false;
  GlobalKey<FormState> formkey = GlobalKey();
   registerpage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Form(
            key: formkey,
            child: ListView(
              children: <Widget>[
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/IMG________________.jpg')),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                  ),
                ),
                Text(
                  "Register",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 26.0),
                ),
                TextFormField(
                    controller: email,
                    validator: (data) {
                      if (data!.isEmpty) {
                        return "Required";
                      } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(data)) {
                        return 'Enter valid email';
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    showCursor: true,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                    )),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                    controller: password,
                    validator: (data) {
                      if (data!.isEmpty) {
                        return "Required";
                      } else if (data.length < 6) {
                        return 'Password must be longer than 6 characters.';
                      } else if (!data.contains(RegExp(r'[A-Z]'))) {
                        return '• Uppercase letter is missing.';
                      } else if (!data.contains(RegExp(r'[a-z]'))) {
                        return '• Lowercase letter is missing.';
                      } else if (!data.contains(RegExp(r'[0-9]'))) {
                        return '• Digit is missing';
                      }
                      return null;
                    },
                    obscureText: _passwordVisible,
                    cursorColor: Colors.black,
                    showCursor: true,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                    )),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                    controller: username,
                    validator: (data) {
                      if (data!.isEmpty) {
                        return "Required";
                      }
                    },
                    cursorColor: Colors.black,
                    showCursor: true,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "User Name",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                    )),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                    controller: phone,
                    validator: (data) {
                      if (data!.isEmpty) {
                        return "Required";
                      } else if (data!.isEmpty ||
                          RegExp(r"^\+?0[0-9]{10}$").hasMatch(data)) {
                        return null;
                      }
                    },
                    cursorColor: Colors.black,
                    showCursor: true,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Phone",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                    )),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                    controller: address,
                    validator: (data) {
                      if (data!.isEmpty) {
                        return "Required";
                      }
                    },
                    cursorColor: Colors.black,
                    showCursor: true,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Address",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                    )),
                SizedBox(
                  height: 15.0,
                ),
                ElevatedButton(
                    style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        try {
                          final Credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                              email: email.text, password: password.text);
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(Credential.user!.email)
                              .set({
                            'email': email.text,
                            'password': password.text,
                            'username': username.text,
                            'phone': int.parse(phone.text),
                            'address': address.text
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Sign up success ."),
                            backgroundColor: Colors.green,
                          ));
                          Navigator.pushNamed(context, loginpage.id);
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
                      }
                    },
                    child: Text(
                      "Sign Up ",
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    )),
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
    );
  }
}
