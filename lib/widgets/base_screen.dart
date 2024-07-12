/* import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hatgeback/screens/CardDetailsScreen.dart';
import 'package:hatgeback/screens/addpoint.dart';
import 'package:hatgeback/screens/loginscreen.dart';
import 'package:hatgeback/screens/myparking.dart';
import 'package:hatgeback/screens/userprofile.dart';
import 'package:hatgeback/screens/WalletScreen.dart';
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
                Color(0xFF33AD60),
                Color(0xFF33AD60),
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
              _buildFooterButton(
                icon: Icons.paste_rounded,
                onPressed: () {
                  Navigator.pushNamed(context, CardDetailsScreen.id);
                },
              ),
              _buildFooterButton(
                icon: Icons.paste_rounded,
                onPressed: () {
                  Navigator.pushNamed(context, WalletPage.id);
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
            Color(0xFF33AD60),
            Color(0xFF33AD60),
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
 }*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/payment/payscreen.dart';
import 'package:hatgeback/screens/FeedbackScreen.dart';
import 'package:hatgeback/screens/WalletScreen.dart';
import 'package:hatgeback/screens/addpoint.dart';
import 'package:hatgeback/screens/homepage.dart';
import 'package:hatgeback/screens/loginscreen.dart';
import 'package:hatgeback/screens/myReservations.dart';
import 'package:hatgeback/screens/myparking.dart';
import 'package:hatgeback/screens/userprofile.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final String pageTitle;
  final bool showBackButton;
  final bool isHomeScreen;
  final VoidCallback? onBackButtonPressed;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  BaseScreen({
    required this.child,
    required this.pageTitle,
    this.showBackButton = false,
    this.isHomeScreen = false,
    this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200], // Background color for the screen
      drawer: isHomeScreen ? _buildDrawer(context) : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              16.0, 12.0, 16.0, 12.0), // Padding adjusted for top and bottom
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.0)), // Adjusted border radius
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
                Color(0xFF33AD60),
                Color(0xFF33AD60),
              ],
            ),
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0)), // Adjusted border radius
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFooterButton(
                icon: Icons.add,
                onPressed: () {
                  Navigator.pushNamed(context, addpoint.id);
                },
              ),
              //momen to fatma
              // _buildFooterButton(
              //   icon: Icons.paste_rounded,
              //   onPressed: () {
              //     Navigator.pushNamed(context, myparking.id);
              //   },
              // ),

              _buildFooterButton(
                icon: Icons.payment,
                onPressed: () {
                  Navigator.pushNamed(context, payscreen.id);
                },
              ),
              _buildFooterButton(
                icon: Icons.payment,
                onPressed: () {
                  Navigator.pushNamed(context, FeedbackScreen.id);
                },
              ),
              _buildFooterButton(
                icon: Icons.home,
                onPressed: () {
                  Navigator.pushNamed(context, homepage.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      padding: EdgeInsets.fromLTRB(
          16.0, 12.0, 16.0, 12.0), // Padding adjusted for top and bottom
      margin:
          EdgeInsets.only(bottom: 12.0), // Added bottom margin to match footer
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF33AD60),
            Color(0xFF33AD60),
          ],
        ),
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0)), // Adjusted border radius
      ),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed:
                  onBackButtonPressed ?? () => Navigator.of(context).pop(),
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
          if (isHomeScreen)
            GestureDetector(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  user?.photoURL ?? 'https://example.com/default-user.png',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFooterButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'Guest User'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                user?.photoURL ?? 'https://example.com/default-user.png',
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF33AD60),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('My Reservations'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => myReservations()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.wallet),
            title: Text('Wallet'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WalletPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.garage_outlined),
            title: Text('My Parking Areas'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => myparking()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => loginscreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
