import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reso_tdd/core/error/exceptions.dart';
import 'package:reso_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:reso_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:matcher/matcher.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl datasource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientStatus200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response('Not Found', 404),
    );
  }

  group(
    'geConcreteNumberTrivia',
    () {
      final tNumber = 1;
      final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

      test('''should perform a GET request on a URL with number 
      being the endpoint with application/json header''', () async {
        setUpMockHttpClientStatus200();


        datasource.getConcreteNumberTrivia(tNumber);

        verify(
          mockHttpClient.get(
            '$BASE_URL$tNumber',
            headers: {'Content-Type': 'application/json'},
          ),
        );
      });

      test('should return NumberTrivia when response code is 200', () async {
        setUpMockHttpClientStatus200();

        final result = await datasource.getConcreteNumberTrivia(tNumber);

        expect(result, equals(tNumberTriviaModel));
      });

      test('should throw ServerException when response code is 404 or other', () async {
        setUpMockHttpClientFailure404();

        final call = datasource.getConcreteNumberTrivia;

        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      });
    },
  );

  group(
    'geRandomNumberTrivia',
        () {
      final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

      test('''should perform a GET request on a URL with number 
      being the endpoint with application/json header''', () async {
        setUpMockHttpClientStatus200();


        datasource.getRandomNumberTrivia();

        verify(
          mockHttpClient.get(
            '${BASE_URL}random',
            headers: {'Content-Type': 'application/json'},
          ),
        );
      });

      test('should return NumberTrivia when response code is 200', () async {
        setUpMockHttpClientStatus200();

        final result = await datasource.getRandomNumberTrivia();

        expect(result, equals(tNumberTriviaModel));
      });

      test('should throw ServerException when response code is 404 or other', () async {
        setUpMockHttpClientFailure404();

        final call = datasource.getRandomNumberTrivia;

        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      });
    },
  );
}
