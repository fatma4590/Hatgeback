import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/screens/homepage.dart';

class CardDetailsScreen extends StatefulWidget {
  static String id = 'CardDetailsScreen';

  @override
  _CardDetailsScreenState createState() => _CardDetailsScreenState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardholderNameController = TextEditingController();
  final _expiryDateControlleryear = TextEditingController();
  final _expiryDateControllermonth = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Card Details'),
        backgroundColor: Color(0xFF33AD60), // Primary color for AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildCardField(
                controller: _cardNumberController,
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  if (value.length != 16) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildCardField(
                controller: _cardholderNameController,
                labelText: 'Cardholder Name',
                hintText: 'John Doe',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cardholder name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildCardField(
                controller: _expiryDateControllermonth,
                labelText: 'Expiration Date (MM)',
                hintText: 'MM/YY',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expiration date month';
                  }
                  if (int.parse(value) > 31) {
                    return 'Write the correct month ';
                  }

                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildCardField(
                controller: _expiryDateControlleryear,
                labelText: 'Expiration Date (YY)',
                hintText: 'YY',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expiration date year';
                  }
                  if (int.parse(value) < 24) {
                    return 'Write the correct month ';
                  }

                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildCardField(
                controller: _cvvController,
                labelText: 'CVV',
                hintText: '123',
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter CVV';
                  }
                  if (value.length != 3) {
                    return 'CVV must be 3 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveCardData();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => homepage()),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  child: Text('Save Card', style: TextStyle(fontSize: 16)),
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
      ),
    );
  }

  Widget _buildCardField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }

  void _saveCardData() async {
    final cardNumber = int.parse(_cardNumberController.text);
    final cardholderName = _cardholderNameController.text;
    final expiryDateyear = _expiryDateControlleryear.text;
    final expiryDatemonth = _expiryDateControllermonth.text;
    final cvv = int.parse(_cvvController.text);
    await FirebaseFirestore.instance.collection('CARDS')
      ..doc(cvv.toString()).set({
        'userid': _auth.currentUser!.email,
        'cardNumber': cardNumber,
        'cardholderName': cardholderName,
        'expiryDateyear': expiryDateyear,
        'expiryDatemonth': expiryDatemonth,
        'cvv': cvv,
      });
    //momen to fatma
    // Save the card data logic here
    // For now, just print the card data

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Card details saved successfully!'),
        backgroundColor: Color(0xFF33AD60),
      ),
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardholderNameController.dispose();
    _expiryDateControlleryear.dispose();
    _expiryDateControllermonth.dispose();
    _cvvController.dispose();
    super.dispose();
  }
}
