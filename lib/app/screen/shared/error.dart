import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String _errorMessage;

  const ErrorScreen({@required String message}) : _errorMessage = message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.error,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 10),
              Text(_errorMessage),
            ],
          ),
        ),
      ),
    );
  }
}
