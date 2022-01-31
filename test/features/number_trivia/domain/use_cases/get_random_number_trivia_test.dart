import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/domain/use_cases/use_case.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository repository;

  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  setUp(() {
    repository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(gateway: repository);
  });

  test(
    'should get trivia from the repository',
    () async {
      // Arrange
      when(repository.getRandomNumberTrivia())
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // Act
      final result = await usecase(NoParameters());
      // Assert
      expect(result, const Right(tNumberTrivia));
      verify(repository.getRandomNumberTrivia());
      verifyNoMoreInteractions(repository);
    },
  );
}
