import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:reso_tdd/core/error/exceptions.dart';
import 'package:reso_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}
const BASE_URL ='http://numbersapi.com/';
class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) => _getTriviaFromUrl('$BASE_URL$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => _getTriviaFromUrl('${BASE_URL}random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    if(response.statusCode == 200) {
      return NumberTriviaModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }
}
