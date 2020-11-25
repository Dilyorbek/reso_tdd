import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({@required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Container(
        child: SingleChildScrollView(
          child: Text(
            message,
            key: Key('message'),
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
