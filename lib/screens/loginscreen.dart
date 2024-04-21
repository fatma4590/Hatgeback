import 'package:flutter/material.dart';
import 'package:hatgeback/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hatgeback/screens/registerpage.dart';

class loginscreen extends StatelessWidget {
  static String id = 'loginpage';

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey();
  bool _passwordVisible = true;
  loginscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child:  Form(
          key: formkey,
          child: ListView(
            children: <Widget>[
              Container(
                child:Image(image: AssetImage('assets/asd.jpg')),

                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),

                ),
              ),
              Text(
                "login Page",
                style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              TextFormField(
                validator: (data) {
                  if (data!.isEmpty) {
                    return "field is empty";
                  }
                },
                controller: email,
                cursorColor: Colors.black,
                showCursor: true,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: password,
                validator: (data) {
                  if (data!.isEmpty) {
                    return "field is empty";
                  }
                },
                cursorColor: Colors.black,
                showCursor: true,
                obscureText: _passwordVisible,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      try {
                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email.text, password: password.text);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("sign in success."),
                          backgroundColor: Colors.grey,
                        ));
                        Navigator.pushNamed(context, homepage.id);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          ScaffoldMessenger.of(context).showSnackBar((SnackBar(
                            content: Text('No user found for that email.'),
                          )));
                        } else if (e.code == 'wrong-password') {
                          ScaffoldMessenger.of(context).showSnackBar((SnackBar(
                            content:
                                Text('Wrong password provided for that user.'),
                          )));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("there was an error.")));
                      }
                    }
                  },
                  child: Text(
                    "log in ",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
              SizedBox(
                height: 11.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //dont have account
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.black),
                  ),
                  //register
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, registerpage.id);
                    },
                    child: Text(
                      " Register",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
