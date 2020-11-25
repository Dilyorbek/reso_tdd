import 'package:flutter/material.dart';
import 'package:reso_tdd/features/number_trivia/domain/entities/number_trivia.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const TriviaDisplay({Key key, this.numberTrivia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(
            numberTrivia.number.toString(),
            key: Key('trivia_number'),
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                child: Text(
                  numberTrivia.text,
                  key: Key('trivia_text'),
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
