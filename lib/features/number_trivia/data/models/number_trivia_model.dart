
import 'package:flutter/foundation.dart';
import 'package:reso_tdd/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({@required int number, @required String text}): super(number: number, text: text);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(number: (json['number']  as num).toInt(), text: json['text']);
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'text': text,
    };
  }
}