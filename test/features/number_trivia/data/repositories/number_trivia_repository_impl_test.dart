import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reso_tdd/core/error/exceptions.dart';
import 'package:reso_tdd/core/error/failures.dart';
import 'package:reso_tdd/core/platform/network_info.dart';
import 'package:reso_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:reso_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:reso_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:reso_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:reso_tdd/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group("getConcreteNumberTrivia", () {
    final tNumber = 1;
    final tNumberTriviModel = NumberTriviaModel(number: tNumber, text: "test trivia");
    final NumberTrivia tNumberTrivia = tNumberTriviModel;
    test(
      "should check if the device online",
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        repository.getConcreteNumberTrivia(tNumber);

        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestOnline(() {
      test(
        'should return remote data when the call remote data source is successful',
        () async {
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async => tNumberTriviModel);

          final result = await repository.getConcreteNumberTrivia(tNumber);

          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));

          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache  data locally when the call remote data source is success',
        () async {
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async => tNumberTriviModel);

          await repository.getConcreteNumberTrivia(tNumber);

          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviModel));
        },
      );

      test(
        'should return server failure  when the call remote data source is unsuccessful',
        () async {
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenThrow(ServerException());

          final result = await repository.getConcreteNumberTrivia(tNumber);

          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyNoMoreInteractions(mockLocalDataSource);

          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviModel);

          final result = await repository.getConcreteNumberTrivia(tNumber);

          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should return CachedFailure when the there is noo cached data is present',
        () async {
          when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());

          final result = await repository.getConcreteNumberTrivia(tNumber);

          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group("getRandomNumberTrivia", () {
    final tNumberTriviModel = NumberTriviaModel(number: 123, text: "test trivia");
    final NumberTrivia tNumberTrivia = tNumberTriviModel;
    test(
      "should check if the device online",
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        repository.getRandomNumberTrivia();

        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestOnline(() {
      test(
        'should return remote data when the call remote data source is successful',
        () async {
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviModel);

          final result = await repository.getRandomNumberTrivia();

          verify(mockRemoteDataSource.getRandomNumberTrivia());

          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache  data locally when the call remote data source is success',
        () async {
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviModel);

          await repository.getRandomNumberTrivia();

          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviModel));
        },
      );

      test(
        'should return server failure  when the call remote data source is unsuccessful',
        () async {
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());

          final result = await repository.getRandomNumberTrivia();

          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyNoMoreInteractions(mockLocalDataSource);

          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviModel);

          final result = await repository.getRandomNumberTrivia();

          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should return CachedFailure when the there is noo cached data is present',
        () async {
          when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());

          final result = await repository.getRandomNumberTrivia();

          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
