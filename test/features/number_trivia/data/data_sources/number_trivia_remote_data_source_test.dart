import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockHttpClient;
  late NumberTriviaRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setupMockHttpCallWithSuccess200() {
    final response = http.Response(fixture('trivia.json'), 200);
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Future.value(response));
  }

  void setupMockHttpResponseWith404MissingResource() {
    final response = http.Response('something went wrong', 404);
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Future.value(response));
  }

  group('getConcreteNumberTrivia', () {
    const int tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
      'should set number as end-point and application/json and content-type',
      () async {
        // Arrange
        setupMockHttpCallWithSuccess200();
        // Act
        await dataSource.getConcreteNumberTrivia(tNumber);
        // Assert
        final url = Uri.parse('http://numbersapi.com/$tNumber');
        verify(mockHttpClient.get(
          url,
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );

    test(
      'should return NumberTriviaModel when the response code is 200',
      () async {
        // Arrange
        setupMockHttpCallWithSuccess200();
        // Act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        // Assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw ServerException when there is a 404',
      () async {
        // Arrange
        setupMockHttpResponseWith404MissingResource();
        // Act
        final call = dataSource.getConcreteNumberTrivia;
        // Assert
        expect(
          () => call(tNumber),
          throwsA(const TypeMatcher<ServerException>()),
        );
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
      'should set application/json and content-type',
      () async {
        // Arrange
        setupMockHttpCallWithSuccess200();
        // Act
        await dataSource.getRandomNumberTrivia();
        // Assert
        final url = Uri.parse('http://numbersapi.com/random');
        verify(mockHttpClient.get(
          url,
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );

    test(
      'should return NumberTriviaModel when the response code is 200',
      () async {
        // Arrange
        setupMockHttpCallWithSuccess200();
        // Act
        final result = await dataSource.getRandomNumberTrivia();
        // Assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw ServerException when there is a 404',
      () async {
        // Arrange
        setupMockHttpResponseWith404MissingResource();
        // Act
        final call = dataSource.getRandomNumberTrivia;
        // Assert
        expect(
          () => call(),
          throwsA(const TypeMatcher<ServerException>()),
        );
      },
    );
  });
}
