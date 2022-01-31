import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import 'number_trivia_repository_test.mocks.dart';

class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {
  var tNumberTriviaModel =
      const NumberTriviaModel(number: 1, text: 'test trivia');

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number) =>
      (super.noSuchMethod(Invocation.method(#getConcreteNumberTrivia, [number]),
          returnValue: Future.value(tNumberTriviaModel),
          returnValueForMissingStub: Future.value(tNumberTriviaModel)));

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      (super.noSuchMethod(Invocation.method(#getConcreteNumberTrivia, []),
          returnValue: Future.value(tNumberTriviaModel),
          returnValueForMissingStub: Future.value(tNumberTriviaModel)));
}

@GenerateMocks(
  [NumberTriviaLocalDataSource, NetworkInfo],
)
void main() {
  late NumberTriviaRepository repository;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRepository(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  runCodeOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  runCodeOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const int tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'test trivia');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    setUp(() {
      mockRemoteDataSource.tNumberTriviaModel = tNumberTriviaModel;
    });

    test(
      'should check if device is online',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // Act
        repository.getConcreteNumberTrivia(tNumber);
        // Assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runCodeOnline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source is successfully completed',
        () async {
          // Arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // Assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should cache data locally when the call to remote data source is successfully completed',
        () async {
          // Arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // Act
          await repository.getConcreteNumberTrivia(tNumber);
          // Assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server error when the call to remote data source is unsuccessful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // Assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runCodeOffline(() {
      test(
        'should return locally cache data when the cached data is present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // Act
          final trivia = await repository.getConcreteNumberTrivia(tNumber);
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(trivia, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should return CacheFailure when the cached data is not present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // Act
          final trivia = await repository.getConcreteNumberTrivia(tNumber);
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(trivia, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 123, text: 'test trivia');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    setUp(() {
      mockRemoteDataSource.tNumberTriviaModel = tNumberTriviaModel;
    });

    test(
      'should check if device is online',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // Act
        repository.getRandomNumberTrivia();
        // Assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runCodeOnline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source is successfully completed',
        () async {
          // Arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // Act
          final result = await repository.getRandomNumberTrivia();
          // Assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should cache data locally when the call to remote data source is successfully completed',
        () async {
          // Arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // Act
          await repository.getRandomNumberTrivia();
          // Assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server error when the call to remote data source is unsuccessful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // Act
          final result = await repository.getRandomNumberTrivia();
          // Assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runCodeOffline(() {
      test(
        'should return locally cache data when the cached data is present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // Act
          final trivia = await repository.getRandomNumberTrivia();
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(trivia, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should return CacheFailure when the cached data is not present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // Act
          final trivia = await repository.getRandomNumberTrivia();
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(trivia, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
