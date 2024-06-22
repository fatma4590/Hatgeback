import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hatgeback/screens/addpoint.dart';
import 'package:hatgeback/screens/loginscreen.dart';
import 'package:hatgeback/screens/myparking.dart';
import 'package:hatgeback/screens/userprofile.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final String pageTitle;
  final bool showBackButton;
  final VoidCallback? onBackButtonPressed;

  BaseScreen({
    required this.child,
    required this.pageTitle,
    this.showBackButton = false,
    this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Background color for the screen
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0), // Padding adjusted for top and bottom
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)), // Adjusted border radius
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.green.withOpacity(0.8),
                Colors.green.withOpacity(0.95),
              ],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)), // Adjusted border radius
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFooterButton(
                icon: Icons.account_circle_sharp,
                onPressed: () {
                  Navigator.pushNamed(context, UserProfile.id);
                },
              ),
              _buildFooterButton(
                icon: Icons.add,
                onPressed: () {
                  Navigator.pushNamed(context, addpoint.id);
                },
              ),
              _buildFooterButton(
                icon: Icons.paste_rounded,
                onPressed: () {
                  Navigator.pushNamed(context, myparking.id);
                },
              ),
              _buildFooterButton(
                icon: Icons.logout,
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => loginscreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0), // Padding adjusted for top and bottom
      margin: EdgeInsets.only(bottom: 12.0), // Added bottom margin to match footer
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green.withOpacity(0.8),
            Colors.green.withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)), // Adjusted border radius
      ),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBackButtonPressed ?? () => Navigator.of(context).pop(),
            ),
          Expanded(
            child: Text(
              pageTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 48), // Spacer for potential actions on the right
        ],
      ),
    );
  }

  Widget _buildFooterButton({required IconData icon, required VoidCallback onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}
