import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reso_tdd/core/error/exceptions.dart';
import 'package:reso_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:reso_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl datasource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasource = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached.json')));
    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
      () async {
        when(mockSharedPreferences.getString(any)).thenReturn(fixture('trivia_cached.json'));

        final result = await datasource.getLastNumberTrivia();

        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw CacheException when there is no cached value',
          () async {
        when(mockSharedPreferences.getString(any)).thenReturn(null);

        final call = datasource.getLastNumberTrivia;

        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "test trivia");
    test(
      'should call SharedPreferences to cache the data',
          () async {
        when(mockSharedPreferences.getString(any)).thenReturn(fixture('trivia_cached.json'));

        await datasource.cacheNumberTrivia(tNumberTriviaModel);

        verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonEncode(tNumberTriviaModel.toJson())));

      },
    );
  });
}
