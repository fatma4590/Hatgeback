import 'package:flutter/material.dart';

class parkingwidget extends StatelessWidget {
  final String Location;
  final String Name;
  final String Price;
  final String startDate;
  final String endDate;


  const parkingwidget(
      {super.key,
        required this.Location,
        required this.Name,
        required this.Price,
        required this.startDate,
        required this.endDate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            height: 120,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Location,
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(
                Name,
                style:
                TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              Text(
                Price,
                style:
                TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              Text(
                startDate,
                style:
                TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              Text(
                startDate,
                style:
                TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Spacer(),
          Icon(Icons.edit),
        ],
      ),
    );
  }
}