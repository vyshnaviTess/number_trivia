import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {
  @override
  String? getString(String? key) =>
      (super.noSuchMethod(Invocation.method(#getString, [key])) as String?);

  @override
  Future<bool> setString(String? key, String? value) => (super.noSuchMethod(
        Invocation.method(#setString, [key, value]),
        returnValue: Future<bool>.value(false),
        returnValueForMissingStub: Future<bool>.value(false),
      ));
}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  final cachedNumberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

  group('getLastNumberTrivia', () {
    test(
      'should return Number trivia from SharedPreferences when there is one in the cache',
      () async {
        // Arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));
        // Act
        final result = await dataSource.getLastNumberTrivia();
        // Assert
        verify(mockSharedPreferences.getString(NumberTriviaModel.storeKey));
        expect(result, cachedNumberTriviaModel);
      },
    );

    test(
      'should throw CacheException when there is no cache data',
      () async {
        // Arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // Act
        final call = dataSource.getLastNumberTrivia;
        // Assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    final numberTriviaToCache = cachedNumberTriviaModel;
    test(
      'should call shared preferences to save the data when cacheNumberTrivia is called',
      () async {
        // Act
        dataSource.cacheNumberTrivia(numberTriviaToCache);
        // Assert
        final expectedJsonString = json.encode(numberTriviaToCache.toJson());
        verify(mockSharedPreferences.setString(
            NumberTriviaModel.storeKey, expectedJsonString));
      },
    );
  });
}
