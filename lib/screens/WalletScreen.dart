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
  List<String> _cardIds = [];

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
        _cardIds = snapshot.docs.map((doc) => doc.id).toList();
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
      final docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cards')
          .add(card);

      setState(() {
        _cardIds.add(docRef.id);
      });
    }
  }

  void _deleteCard(int index) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;
      final cardId = _cardIds[index];

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cards')
          .doc(cardId)
          .delete();

      setState(() {
        _cards.removeAt(index);
        _cardIds.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Card deleted successfully!'),
          backgroundColor: Colors.red,
        ),
      );
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
                  return Dismissible(
                    key: Key(_cardIds[index]),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      _deleteCard(index);
                    },
                    child: CreditCard(
                      cardNumber: card['cardNumber'].toString(),
                      cardholderName: card['cardholderName'],
                      expiryMonth: card['expiryDatemonth'],
                      expiryYear: card['expiryDateyear'],
                    ),
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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(16.0),
      height: 200.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFECCD4D),
            Color(0xFFF8F09F),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10.0,
            right: 10.0,
            child: Image.asset(
              'assets/visa_logo.png',
              height: 40.0,
              width: 60.0,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CARD NUMBER',
                style: TextStyle(
                  fontSize: 10.0,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}',
                style: TextStyle(
                  fontSize: 20.0,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CARDHOLDER NAME',
                        style: TextStyle(
                          fontSize: 10.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        cardholderName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXPIRES',
                        style: TextStyle(
                          fontSize: 10.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        '$expiryMonth/$expiryYear',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
