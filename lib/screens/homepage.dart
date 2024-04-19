import 'package:flutter/material.dart';


class homepage extends StatelessWidget {
  const homepage({Key? key}) : super(key: key);
  static String id = 'homepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Homepage")],
        ),
        centerTitle: true,
      ),

    );
  }
}
