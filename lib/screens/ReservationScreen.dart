/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationScreen extends StatefulWidget {
  final Map<String, dynamic> parkingArea;

  ReservationScreen({required this.parkingArea});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _paymentMethod;
  double _fee = 0.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Parking Area: ${widget.parkingArea['Name']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              DateTimeField(
                format: DateFormat('yyyy-MM-dd HH:mm a'),
                decoration:
                    InputDecoration(hintText: 'Choose Start Date & Time'),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: currentValue ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));

                  if (date != null) {
                    final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()));
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    _startDate = value ?? DateTime.now();
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Required';
                  }
                  if (value
                      .isBefore(widget.parkingArea['startDate'].toDate())) {
                    return 'Start date cannot be before available start time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DateTimeField(
                format: DateFormat('yyyy-MM-dd HH:mm a'),
                decoration: InputDecoration(hintText: 'Choose End Date & Time'),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: currentValue ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));

                  if (date != null) {
                    final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()));
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    _endDate = value ?? DateTime.now();
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Required';
                  }
                  if (value.isAfter(widget.parkingArea['endDate'].toDate())) {
                    return 'End date cannot be after available end time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(hintText: 'Payment Method'),
                value: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                },
                items: [
                  'Bank Card',
                  'Instapay',
                  'E Wallet',
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
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _showConfirmationDialog();
                    _calculateFee();
                  }
                },
                child: Text('Confirm Reservation'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _calculateFee() {
    final duration = _endDate!.difference(_startDate!);
    final hours = duration.inHours.toDouble();
    _fee = hours * widget.parkingArea['price'];
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Reservation'),
          content: Text(
            'You are about to reserve a parking spot from ${DateFormat('yyyy-MM-dd HH:mm a').format(_startDate!)} to ${DateFormat('yyyy-MM-dd HH:mm a').format(_endDate!)} for a fee of $_fee EG. Proceed?',
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
                _submitReservation();
                Navigator.of(context).pop();
              },
              child: Text('Proceed'),
            ),
          ],
        );
      },
    );
  }

    void _submitReservation() async {
      final reservation = {
        'userid': _auth.currentUser!.email,
        'startDate': _startDate!.toIso8601String(),
        'endDate': _endDate!.toIso8601String(),
        'fee': _fee,
        'paymentMethod': _paymentMethod,
      };
      await FirebaseFirestore.instance
          .collection('Reservations')
          .add(reservation);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reservation successfully created!'),
        ),
      );
      Navigator.of(context).pop();
    }
  }*/





import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/screens/homepage.dart'; // Replace with your Homepage import
import 'package:hatgeback/widgets/base_screen.dart';
import 'package:hatgeback/payment/payscreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../paymobmanger/paymobmanager.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _cardNumberController = TextEditingController();
  final _cardholderNameController = TextEditingController();
  final _expiryDateControllerYear = TextEditingController();
  final _expiryDateControllerMonth = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      pageTitle: 'Reservation Screen',
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
                    if (value == null) {
                      return 'Required';
                    }
                    if (!_isTimeWithinAvailableHours(value, _endTime)) {
                      return 'Invalid start time';
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
                    if (value == null) {
                      return 'Required';
                    }
                    if (!_isTimeWithinAvailableHours(_startTime, value)) {
                      return 'Invalid end time';
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
                      _calculateFee();
                      _showConfirmationDialog();
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
                ),
              ],
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
                final startTimeInMinutes = _startTime!.hour * 60 + _startTime!.minute;
                final selectedTimeInMinutes = time!.hour * 60 + time.minute;
                if (selectedTimeInMinutes <= startTimeInMinutes + 60) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('End time must be at least 1 hour after start time.'),
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
                  PaymobManager().getPaymentKey(
                      10,"EGP"
                  ).then((String paymentKey) {
                    launchUrl(
                      Uri.parse("https://accept.paymob.com/api/acceptance/iframes/852900?payment_token=$paymentKey"),
                    );
                  });             }
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
                              builder: (context) => homepage(), // Replace with your Homepage widget
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
        .where('expiryDateMonth', isEqualTo: expiryMonth)
        .where('expiryDateYear', isEqualTo: expiryYear)
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

  bool _isTimeWithinAvailableHours(TimeOfDay? startTime, TimeOfDay? endTime) {
    if (startTime == null || endTime == null) {
      return false;
    }

    // Implement your own logic here to check if the selected time is within available hours
    // Example logic: Ensure the parking area is open during these hours
    // This is a placeholder and should be replaced with your actual logic
    // Example:
    // final startHour = startTime.hour;
    // final endHour = endTime.hour;
    // if (startHour < 8 || endHour >= 20) {
    //   return false;
    // }

    return true; // Placeholder return value
  }
}


// trial for time validation
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:hatgeback/widgets/base_screen.dart';
//
// class ReservationScreen extends StatefulWidget {
//   final Map<String, dynamic> parkingArea;
//
//   ReservationScreen({required this.parkingArea});
//
//   @override
//   _ReservationScreenState createState() => _ReservationScreenState();
// }
//
// class _ReservationScreenState extends State<ReservationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   TimeOfDay? _startTime;
//   TimeOfDay? _endTime;
//   String? _paymentMethod;
//   double _fee = 0.0;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isSubmitting = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseScreen(
//       pageTitle: 'Reservation Screen',
//       showBackButton: true,
//       onBackButtonPressed: () {
//         Navigator.of(context).pop();
//       },
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text(
//                   'Parking Area: ${widget.parkingArea['Name']}',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 20),
//                 _buildTimeField(
//                   labelText: 'Start Time',
//                   hintText: 'Choose Start Time',
//                   onChanged: (value) {
//                     setState(() {
//                       _startTime = value;
//                     });
//                   },
//                   validator: (value) {
//                     if (value == null) {
//                       return 'Required';
//                     }
//                     if (value.hour < widget.parkingArea['startDate'] ||
//                         value.hour > widget.parkingArea['endDate']) {
//                       return 'Start time must be within parking area hours';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 _buildTimeField(
//                   labelText: 'End Time',
//                   hintText: 'Choose End Time',
//                   onChanged: (value) {
//                     setState(() {
//                       _endTime = value;
//                     });
//                   },
//                   validator: (value) {
//                     if (value == null) {
//                       return 'Required';
//                     }
//                     if (value.hour < widget.parkingArea['startDate'] ||
//                         value.hour > widget.parkingArea['endDate']) {
//                       return 'End time must be within parking area hours';
//                     }
//                     if (_startTime != null && value.hour < _startTime!.hour) {
//                       return 'End time must be after start time';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 _buildPaymentMethodDropdown(),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _isSubmitting
//                       ? null
//                       : () {
//                     if (_formKey.currentState!.validate()) {
//                       _showConfirmationDialog();
//                       _calculateFee();
//                     }
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 15.0),
//                     child: Text(
//                       'Confirm Reservation',
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                     backgroundColor: Color(0xFF33AD60), // Button text color
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTimeField({
//     required String labelText,
//     required String hintText,
//     required ValueChanged<TimeOfDay?> onChanged,
//     required FormFieldValidator<TimeOfDay?> validator,
//   }) {
//     return FormField<TimeOfDay>(
//       validator: validator,
//       builder: (state) {
//         return InputDecorator(
//           decoration: InputDecoration(
//             labelText: labelText,
//             hintText: hintText,
//             contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             errorText: state.errorText,
//             hintStyle: TextStyle(color: Colors.grey), // Placeholder text style
//           ),
//           child: InkWell(
//             onTap: () async {
//               final time = await showTimePicker(
//                 context: context,
//                 initialTime: TimeOfDay.now(),
//               );
//               state.didChange(time);
//               onChanged(time);
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 15.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     state.value?.format(context) ?? hintText,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: state.value == null
//                           ? Theme.of(context).hintColor
//                           : Colors.black,
//                     ),
//                   ),
//                   Icon(Icons.access_time, color: Colors.black),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildPaymentMethodDropdown() {
//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         labelText: 'Payment Method',
//         hintText: 'Choose Payment Method',
//         contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//       ),
//       value: _paymentMethod,
//       onChanged: (value) {
//         setState(() {
//           _paymentMethod = value;
//         });
//       },
//       items: [
//         'Bank Card',
//         'Instapay',
//         'E Wallet',
//       ].map((e) {
//         return DropdownMenuItem<String>(
//           value: e,
//           child: Text(e),
//         );
//       }).toList(),
//       validator: (value) {
//         if (value == null) {
//           return 'Required';
//         }
//         return null;
//       },
//     );
//   }
//
//   void _calculateFee() {
//     final startTimeInMinutes = _startTime!.hour * 60 + _startTime!.minute;
//     final endTimeInMinutes = _endTime!.hour * 60 + _endTime!.minute;
//     final durationInMinutes = endTimeInMinutes - startTimeInMinutes;
//     final hours = durationInMinutes / 60.0;
//     _fee = hours * widget.parkingArea['price'];
//   }
//
//   void _showConfirmationDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Confirm Reservation'),
//           content: Text(
//             'You are about to reserve a parking spot from ${_startTime!.format(context)} to ${_endTime!.format(context)} for a fee of $_fee EG. Proceed?',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 setState(() {
//                   _isSubmitting = true;
//                 });
//                 try {
//                   await _submitReservation();
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Error: $e'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 } finally {
//                   setState(() {
//                     _isSubmitting = false;
//                   });
//                 }
//                 Navigator.of(context).pop();
//               },
//               child: Text('Proceed'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _submitReservation() async {
//     final startDateTime = DateTime(
//       DateTime.now().year,
//       DateTime.now().month,
//       DateTime.now().day,
//       _startTime!.hour,
//       _startTime!.minute,
//     );
//     final endDateTime = DateTime(
//       DateTime.now().year,
//       DateTime.now().month,
//       DateTime.now().day,
//       _endTime!.hour,
//       _endTime!.minute,
//     );
//
//     final reservation = {
//       'userid': _auth.currentUser!.email,
//       'tartDate': startDateTime.toIso8601String(),
//       'endDate': endDateTime.toIso8601String(),
//       'fee': _fee,
//       'paymentMethod': _paymentMethod,
//     };
//
//     await FirebaseFirestore.instance.collection('Reservations').add(reservation);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Reservation successfully created!'),
//         backgroundColor: Color(0xFF33AD60),
//       ),
//     );
//   }
//