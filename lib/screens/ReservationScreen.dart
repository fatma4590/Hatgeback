//
//
// import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
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
//
//   final _formKey = GlobalKey<FormState>();
//   DateTime? _startDate;
//   DateTime? _endDate;
//   String? _paymentMethod;
//   double _fee = 0.0;
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reservation'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Text(
//                 'Parking Area: ${widget.parkingArea['Name']}',
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(height: 20),
//               DateTimeField(
//                 format: DateFormat('yyyy-MM-dd HH:mm a'),
//                 decoration: InputDecoration(hintText: 'Choose Start Date & Time'),
//                 onShowPicker: (context, currentValue) async {
//                   final date = await showDatePicker(
//                       context: context,
//                       initialDate: currentValue ?? DateTime.now(),
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime(2100));
//
//                   if (date != null) {
//                     final time = await showTimePicker(
//                         context: context,
//                         initialTime: TimeOfDay.fromDateTime(
//                             currentValue ?? DateTime.now()));
//                     return DateTimeField.combine(date, time);
//                   } else {
//                     return currentValue;
//                   }
//                 },
//                 onChanged: (value) {
//                   setState(() {
//                     _startDate = value ?? DateTime.now();
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null) {
//                     return 'Required';
//                   }
//                   if (value.isBefore(widget.parkingArea['startDate'].toDate())) {
//                     return 'Start date cannot be before available start time';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               DateTimeField(
//                 format: DateFormat('yyyy-MM-dd HH:mm a'),
//                 decoration: InputDecoration(hintText: 'Choose End Date & Time'),
//                 onShowPicker: (context, currentValue) async {
//                   final date = await showDatePicker(
//                       context: context,
//                       initialDate: currentValue ?? DateTime.now(),
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime(2100));
//
//                   if (date != null) {
//                     final time = await showTimePicker(
//                         context: context,
//                         initialTime: TimeOfDay.fromDateTime(
//                             currentValue ?? DateTime.now()));
//                     return DateTimeField.combine(date, time);
//                   } else {
//                     return currentValue;
//                   }
//                 },
//                 onChanged: (value) {
//                   setState(() {
//                     _endDate = value ?? DateTime.now();
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null) {
//                     return 'Required';
//                   }
//                   if (value.isAfter(widget.parkingArea['endDate'].toDate())) {
//                     return 'End date cannot be after available end time';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(hintText: 'Payment Method'),
//                 value: _paymentMethod,
//                 onChanged: (value) {
//                   setState(() {
//                     _paymentMethod = value;
//                   });
//                 },
//                 items: [
//                   'Bank Card',
//                   'Instapay',
//                   'E Wallet',
//                 ].map((e) {
//                   return DropdownMenuItem<String>(
//                     value: e,
//                     child: Text(e),
//                   );
//                 }).toList(),
//                 validator: (value) {
//                   if (value == null) {
//                     return 'Required';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//
//                     _showConfirmationDialog();
//                     _calculateFee();
//                   }
//                 },
//                 child: Text('Confirm Reservation'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _calculateFee() {
//     final duration = _endDate!.difference(_startDate!);
//     final hours = duration.inHours.toDouble();
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
//             'You are about to reserve a parking spot from ${DateFormat('yyyy-MM-dd HH:mm a').format(_startDate!)} to ${DateFormat('yyyy-MM-dd HH:mm a').format(_endDate!)} for a fee of $_fee AED. Proceed?',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 _submitReservation();
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
//   void _submitReservation() async {
//     final response = await http.post(
//       Uri.parse('https://epark.zimly.xyz/reservations'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${widget.parkingArea['accessToken']}',
//       },
//       body: jsonEncode({
//         'parkingAreaId': widget.parkingArea['_id'],
//         //'userId': widget.user['_id'],
//         'startDate': _startDate!.toIso8601String(),
//         'endDate': _endDate!.toIso8601String(),
//         'fee': _fee,
//         'paymentMethod': _paymentMethod,
//       }),
//     );
//
//     if (response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Reservation successfully created!'),
//         ),
//       );
//       Navigator.of(context).pop();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to create reservation.'),
//         ),
//       );
//     }
//   }
// }








import 'package:cloud_firestore/cloud_firestore.dart';
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
  TimeOfDay? _startHour;
  TimeOfDay? _endHour;
  String? _paymentMethod;
  double _fee = 0.0;

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
              _buildTimePicker(
                label: 'Choose Start Hour',
                selectedTime: _startHour,
                onTimeChanged: (time) {
                  setState(() {
                    _startHour = time;
                  });
                },
              ),
              SizedBox(height: 20),
              _buildTimePicker(
                label: 'Choose End Hour',
                selectedTime: _endHour,
                onTimeChanged: (time) {
                  setState(() {
                    _endHour = time;
                  });
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
                items: ['Bank Card', 'Instapay', 'E Wallet'].map((e) {
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
                    _calculateFee();
                    _showConfirmationDialog();
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

  Widget _buildTimePicker({required String label, required TimeOfDay? selectedTime, required ValueChanged<TimeOfDay?> onTimeChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        TextButton(
          onPressed: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: selectedTime ?? TimeOfDay.now(),
            );
            if (time != null) {
              onTimeChanged(time);
            }
          },
          child: Text(
            selectedTime != null ? selectedTime.format(context) : 'Select Time',
          ),
        ),
      ],
    );
  }

  void _calculateFee() {
    final startMinutes = _startHour!.hour * 60 + _startHour!.minute;
    final endMinutes = _endHour!.hour * 60 + _endHour!.minute;
    final duration = (endMinutes - startMinutes) / 60;
    _fee = duration * widget.parkingArea['price'];
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Reservation'),
          content: Text(
            'You are about to reserve a parking spot from ${_startHour!.format(context)} to ${_endHour!.format(context)} for a fee of $_fee AED. Proceed?',
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
      'parkingAreaId': widget.parkingArea['id'],
      'startHour': _startHour!.format(context),
      'endHour': _endHour!.format(context),
      'fee': _fee,
      'paymentMethod': _paymentMethod,
    };

    await FirebaseFirestore.instance.collection('reservations').add(reservation);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reservation successfully created!'),
      ),
    );

    Navigator.of(context).pop();
  }
}
