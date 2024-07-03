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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Feedback Reviews',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildFeedbackList(),
                SizedBox(height: 40),
                Text(
                  'Your Feedback',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildFeedbackForm(),
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

  Widget _buildFeedbackList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('feedback').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No feedback available.'));
        }
        final feedbackDocs = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: feedbackDocs.length,
          itemBuilder: (context, index) {
            final feedback = feedbackDocs[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text('Rating: ${feedback['rating']}'),
                subtitle: Text(feedback['feedback']),
                trailing: Text(
                  (feedback['timestamp'] as Timestamp).toDate().toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFeedbackForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
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

      _feedbackController.clear();
      setState(() {
        _rating = 1; // Reset rating after submission
      });
    }
  }
}
