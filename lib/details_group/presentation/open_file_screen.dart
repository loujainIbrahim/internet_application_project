import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OpenFileScreen extends StatelessWidget {
  final String text;
  const OpenFileScreen({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
        Text(text)
      ],),
          )),
    );
  }
}
