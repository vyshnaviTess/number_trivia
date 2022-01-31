import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:number_trivia/core/error/exceptions.dart';

import '../../data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  // http://numbersapi.com/42?json
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  // http://numbersapi.com/random
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl('http://numbersapi.com/$number');
  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final jsonString = json.decode(response.body);
      return NumberTriviaModel.fromJson(jsonString);
    }
    throw ServerException();
  }
}
