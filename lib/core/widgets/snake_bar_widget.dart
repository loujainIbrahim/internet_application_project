import 'package:flutter/material.dart';

class ErrorSnackBar {
  static void show(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          child: Row(
            children: [
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}