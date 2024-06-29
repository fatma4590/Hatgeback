import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/widgets/base_screen.dart';

class FeedbackScreen extends StatefulWidget {
  static String id = 'FeedbackScreen';

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _rating = 1; // Default rating value

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      pageTitle: 'Feedback',
      showBackButton: true,
      onBackButtonPressed: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Your Feedback',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildRatingField(),
                SizedBox(height: 20),
                TextFormField(
                  controller: _feedbackController,
                  decoration: InputDecoration(
                    labelText: 'Feedback',
                    hintText: 'Enter your feedback here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Feedback is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitFeedback();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      'Submit Feedback',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF33AD60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Rating:',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(width: 20),
        DropdownButton<int>(
          value: _rating,
          onChanged: (value) {
            setState(() {
              _rating = value!;
            });
          },
          items: List.generate(5, (index) {
            return DropdownMenuItem(
              value: index + 1,
              child: Text('${index + 1}'),
            );
          }),
        ),
      ],
    );
  }

  Future<void> _submitFeedback() async {
    final user = _auth.currentUser;
    if (user != null) {
      final feedbackData = {
        'userId': user.uid,
        'feedback': _feedbackController.text,
        'rating': _rating,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('feedback').add(feedbackData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Feedback submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();
    }
  }
}
