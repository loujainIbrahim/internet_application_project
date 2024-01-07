import 'package:flutter/material.dart';


Widget defaultbutton({
  required Color backround,
  double width = 300.0,
  double height = 48,
  double radius = 25.0,
  Color? textColor,
  double fontSizeText = 18,
  required String text,
  required Function() function,
}) {
  return Container(
    width: width,
    height: height,

    child: MaterialButton(
      onPressed: function,
      child: Text(
        text,
        style: TextStyle(fontSize: fontSizeText, color: textColor),
      ),
    ),
    decoration: BoxDecoration(
      border: Border.all(
          color: Colors.grey
      ),
      borderRadius: BorderRadius.circular(radius),
      color: backround,
    ),
  );
}