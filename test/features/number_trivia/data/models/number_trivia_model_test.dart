import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test text");

  test('should be a subclass of NumberTrivia', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test(
      'should return a valid model when the json number is an integer',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));
        // Act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // Assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return a valid model when the json number is a double',
      () async {
        // Arrange
        final expectedMap = {"number": 1, "text": "Test text"};
        // Act
        final result = tNumberTriviaModel.toJson();
        // Assert
        expect(result, expectedMap);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON Map containing the proper data',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));
        // Act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // Assert
        expect(result, tNumberTriviaModel);
      },
    );
  });
}