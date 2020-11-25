import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reso_tdd/core/error/failures.dart';
import 'package:reso_tdd/core/usecase/usecase.dart';
import 'package:reso_tdd/core/util/input_converter.dart';
import 'package:reso_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:reso_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:reso_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:reso_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  blocTest(
    'initialState should be Empty',
    build: () => bloc,

    verify: (bloc) {
      expect(bloc.state, Empty());
    }
  );

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Right(tNumberParsed));
    }

    blocTest(
        'should call the InputConverter to validate and convert to an unsigned integer',
        build: () {
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
          return bloc;
        },
        act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
        verify: (_) {
          verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
        },
    );

    blocTest(
      'should emit [Error] when the input is invalid',
      build: () {
        when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Left(InvalidInputFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: [
        Empty(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ],
    );

    blocTest(
      'should get data from the concrete use case',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      verify: (_) async {
          await untilCalled(mockGetConcreteNumberTrivia(any));
          verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      }
    );

    blocTest(
        'should emit [Loading, Loaded] when data has gotten successful',
        build: () {
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
          return bloc;
        },
        act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
        expect: [
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ],
    );

    blocTest(
      'should emit [Loading, Error] when data has gotten unsuccessful',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: [
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest(
      'should emit [Loading, Error] with proper message for the cache failure',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: [
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    blocTest(
        'should get data from the random use case',
        build: () {
          when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
          return bloc;
        },
        act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
        verify: (_) async {
          await untilCalled(mockGetRandomNumberTrivia(any));
          verify(mockGetRandomNumberTrivia(NoParams()));
        }
    );

    blocTest(
      'should emit [Loading, Loaded] when data has gotten successful',
      build: () {
        when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: [
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when data has gotten unsuccessful',
      build: () {
        when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: [
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest(
      'should emit [Loading, Error] with proper message for the cache failure',
      build: () {
        when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: [
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });
}
