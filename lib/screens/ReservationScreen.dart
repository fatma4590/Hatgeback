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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hatgeback/widgets/base_screen.dart';

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
  final db = FirebaseFirestore.instance;

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
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _buildPaymentMethodDropdown(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _showConfirmationDialog();
                      _calculateFee();
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
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF33AD60), // Button text color
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
            hintStyle: TextStyle(color: Colors.grey), // Placeholder text style
          ),
          child: InkWell(
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
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
    final startDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      _startTime!.hour,
      _startTime!.minute,
    );
    final endDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      _endTime!.hour,
      _endTime!.minute,
    );

    final reservation = {
      'userid': _auth.currentUser!.email,
      'startDate': startDateTime.toIso8601String(),
      'endDate': endDateTime.toIso8601String(),
      'fee': _fee,
      'paymentMethod': _paymentMethod,
      'parkingid': widget.parkingArea['parkingid'],
    };

    await FirebaseFirestore.instance
        .collection('Reservations')
        .add(reservation);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reservation successfully created!'),
        backgroundColor: Color(0xFF33AD60),
      ),
    );

    Navigator.of(context).pop();
  }
}
