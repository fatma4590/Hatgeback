import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../paymobmanger/paymobmanager.dart';
import '../screens/homepage.dart'; // Adjust import as per your project structure
import '../widgets/base_screen.dart';

class ReservationScreen extends StatefulWidget {
  final Map<String, dynamic> parkingArea;

  ReservationScreen({required this.parkingArea});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _paymentMethod;
  double _fee = 0.0;
  double _commission = 0.0;
  double _profit = 0.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _cardNumberController = TextEditingController();
  final _cardholderNameController = TextEditingController();
  final _expiryDateControllerYear = TextEditingController();
  final _expiryDateControllerMonth = TextEditingController();
  final _cvvController = TextEditingController();

  DateTime? _allowedStartDate;
  DateTime? _allowedEndDate;

  @override
  void initState() {
    super.initState();
    _fetchAllowedTimes();
  }

  void _fetchAllowedTimes() async {
    try {
      String parkingId = widget.parkingArea['parkingid'].toString();

      QuerySnapshot querySnapshot = await _firestore
          .collection('parkingareas')
          .where('parkingid', isEqualTo: parkingId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('Document exists');
        DocumentSnapshot snapshot = querySnapshot.docs.first;

        if (snapshot['startDate'] != null && snapshot['endDate'] != null) {
          setState(() {
            _allowedStartDate = (snapshot['startDate'] as Timestamp).toDate();
            _allowedEndDate = (snapshot['endDate'] as Timestamp).toDate();
          });

          print('Allowed Start Date: $_allowedStartDate');
          print('Allowed End Date: $_allowedEndDate');
        } else {
          print('startDate or endDate is null');
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching allowed times: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      pageTitle: 'Reservation Screen',
      showBackButton: true,
      onBackButtonPressed: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Parking Area: ${widget.parkingArea['Name']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  _buildTimeField(
                    labelText: 'Start Time',
                    hintText: 'Choose Start Time',
                    onChanged: (value) {
                      setState(() {
                        _startTime = value;
                      });
                    },
                    validator: (value) {
                      if (_startTime == null) {
                        return 'Please select a start time';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  _buildTimeField(
                    labelText: 'End Time',
                    hintText: 'Choose End Time',
                    onChanged: (value) {
                      setState(() {
                        _endTime = value;
                      });
                    },
                    validator: (value) {
                      if (_endTime == null) {
                        return 'Please select an end time';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  _buildPaymentMethodDropdown(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_isTimeWithinAllowedParkingTimes(
                            _startTime, _endTime)) {
                          _calculateFee();
                          _showConfirmationDialog();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Selected times are outside the allowed parking times"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        print("Form validation failed");
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        'Confirm Reservation',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF33AD60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeField({
    required String labelText,
    required String hintText,
    required ValueChanged<TimeOfDay?> onChanged,
    required FormFieldValidator<TimeOfDay>? validator,
  }) {
    return FormField<TimeOfDay>(
      validator: validator,
      builder: (state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorText: state.errorText,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          child: InkWell(
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              // Ensure end time is at least 1 hour after start time
              if (labelText == 'End Time' && _startTime != null) {
                final startTimeInMinutes =
                    _startTime!.hour * 60 + _startTime!.minute;
                final selectedTimeInMinutes = time!.hour * 60 + time.minute;
                if (selectedTimeInMinutes <= startTimeInMinutes + 60) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'End time must be at least 1 hour after start time.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
              }

              state.didChange(time);
              onChanged(time);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.value?.format(context) ?? hintText,
                    style: TextStyle(
                      fontSize: 16,
                      color: state.value == null
                          ? Theme.of(context).hintColor
                          : Colors.black,
                    ),
                  ),
                  Icon(Icons.access_time, color: Colors.black),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Payment Method',
        hintText: 'Choose Payment Method',
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      value: _paymentMethod,
      onChanged: (value) {
        setState(() {
          _paymentMethod = value;
        });
      },
      items: [
        'Bank Card',
        'PayMob',
      ].map((e) {
        return DropdownMenuItem<String>(
          value: e,
          child: Text(e),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Required';
        }
        return null;
      },
    );
  }

  void _calculateFee() {
    final startTimeInMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endTimeInMinutes = _endTime!.hour * 60 + _endTime!.minute;
    final durationInMinutes = endTimeInMinutes - startTimeInMinutes;
    final hours = durationInMinutes / 60.0;
    _fee = hours * widget.parkingArea['price'];
    double commissionRate = 0.15;
    _commission = _fee * commissionRate;
    _profit = _fee - _commission;
    FirebaseFirestore.instance
        .collection('fees')
        .add({'fees': _fee, 'commission': _commission, 'profit': _profit});
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Reservation'),
          content: Text(
            'You are about to reserve a parking spot from ${_startTime!.format(context)} to ${_endTime!.format(context)} for a fee of $_fee EG. Proceed?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (_paymentMethod == 'Bank Card') {
                  _showBankCardDetailsDialog();
                } else if (_paymentMethod == 'PayMob') {
                  PaymobManager()
                      .getPaymentKey(10, "EGP")
                      .then((String paymentKey) {
                    launchUrl(
                      Uri.parse(
                          "https://accept.paymob.com/api/acceptance/iframes/852900?payment_token=$paymentKey"),
                    );
                  });
                }
              },
              child: Text('Proceed'),
            ),
          ],
        );
      },
    );
  }

  void _showPayMobPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("PayMob Payment Details"),
          content: Center(
            child: Text("Place PayMob Payment UI here."),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showBankCardDetailsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Card Details"),
          content: Form(
            key: _formKey, // Ensure card details form is validated
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  Row(
                    children: [
                      Expanded(
                        child: _buildCardField(
                          controller: _expiryDateControllerMonth,
                          labelText: 'MM',
                          hintText: 'MM',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter expiration date month';
                            }
                            if (int.tryParse(value) == null ||
                                int.parse(value) < 1 ||
                                int.parse(value) > 12) {
                              return 'Please enter a valid month';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildCardField(
                          controller: _expiryDateControllerYear,
                          labelText: 'YY',
                          hintText: 'YY',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter expiration date year';
                            }
                            if (int.tryParse(value) == null ||
                                int.parse(value) < DateTime.now().year % 100) {
                              return 'Please enter a valid year';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final cardCheckResult = await _checkCardInFirestore(
                          cardNumber: _cardNumberController.text,
                          cardholderName: _cardholderNameController.text,
                          expiryMonth: _expiryDateControllerMonth.text,
                          expiryYear: _expiryDateControllerYear.text,
                          cvv: _cvvController.text,
                        );

                        if (cardCheckResult == 'Card is valid') {
                          _submitReservation();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  homepage(), // Replace with your Homepage widget
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(cardCheckResult == 'Card not found'
                                  ? 'Card not found. Please try again.'
                                  : 'Insufficient balance. Please try again.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      child: Text(
                        'Save Card',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }

  Future<String> _checkCardInFirestore({
    required String cardNumber,
    required String cardholderName,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      return 'User not authenticated';
    }
    final userId = user.uid;

    final cardSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('cards')
        .where('cardNumber', isEqualTo: int.tryParse(cardNumber))
        .where('cardholderName', isEqualTo: cardholderName)
        .where('expiryDatemonth', isEqualTo: expiryMonth)
        .where('expiryDateyear', isEqualTo: expiryYear)
        .where('cvv', isEqualTo: int.tryParse(cvv))
        .get();

    if (cardSnapshot.docs.isEmpty) {
      return 'Card not found';
    }

    final cardData = cardSnapshot.docs.first.data();
    final balance = cardData['Balance'] ?? 0.0;

    if (balance >= _fee) {
      final newBalance = balance - _fee;
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cards')
          .doc(cardSnapshot.docs.first.id)
          .update({'Balance': newBalance});
      return 'Card is valid';
    } else {
      return 'Insufficient balance';
    }
  }

  void _submitReservation() async {
    final user = _auth.currentUser;
    if (user != null) {
      final reservation = {
        'userId': user.uid,
        'parkingAreaId': widget.parkingArea['id'],
        'startTime': _startTime!.format(context),
        'endTime': _endTime!.format(context),
        'fee': _fee,
        'paymentMethod': _paymentMethod,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('reservations').add(reservation);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reservation successful!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  bool _isTimeWithinAllowedParkingTimes(
      TimeOfDay? startTime, TimeOfDay? endTime) {
    if (startTime == null || endTime == null) {
      return false;
    }

    if (_allowedStartDate == null || _allowedEndDate == null) {
      return false;
    }

    final selectedStartTime = DateTime(
      _allowedStartDate!.year,
      _allowedStartDate!.month,
      _allowedStartDate!.day,
      startTime.hour,
      startTime.minute,
    );

    final selectedEndTime = DateTime(
      _allowedEndDate!.year,
      _allowedEndDate!.month,
      _allowedEndDate!.day,
      endTime.hour,
      endTime.minute,
    );

    bool isWithin = selectedStartTime.isAfter(_allowedStartDate!) &&
        selectedEndTime.isBefore(_allowedEndDate!);

    return isWithin;
  }
}
