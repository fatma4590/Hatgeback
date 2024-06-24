import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hatgeback/screens/CardDetailsScreen.dart';

class WalletPage extends StatefulWidget {
  static String id = 'WalletPage';

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _cards = [];

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  void _fetchCards() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cards')
          .get();

      setState(() {
        _cards = snapshot.docs.map((doc) => doc.data()).toList();
      });
    }
  }

  void _addCard(Map<String, dynamic> card) {
    setState(() {
      _cards.add(card);
    });
    _saveCardToFirestore(card);
  }

  void _saveCardToFirestore(Map<String, dynamic> card) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cards')
          .add(card);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
        backgroundColor: Color(0xFF33AD60), // Primary color for AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  return CreditCard(
                    cardNumber: card['cardNumber'].toString(),
                    cardholderName: card['cardholderName'],
                    expiryMonth: card['expiryDatemonth'],
                    expiryYear: card['expiryDateyear'],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final newCard = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CardDetailsScreen()),
                );
                if (newCard != null) {
                  _addCard(newCard);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text('Add Card', style: TextStyle(fontSize: 16)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button background color
                foregroundColor: Colors.white, // Button text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreditCard extends StatelessWidget {
  final String cardNumber;
  final String cardholderName;
  final String expiryMonth;
  final String expiryYear;

  CreditCard({
    required this.cardNumber,
    required this.cardholderName,
    required this.expiryMonth,
    required this.expiryYear,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              cardholderName.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'EXP: $expiryMonth/$expiryYear',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
