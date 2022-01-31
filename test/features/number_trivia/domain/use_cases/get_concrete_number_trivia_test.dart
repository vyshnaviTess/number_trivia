import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/gateways/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NumberTriviaGateway>(as: #MockNumberTriviaRepository)
])
void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository repository;

  const int tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  setUp(() {
    repository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(gateway: repository);
  });

  test(
    'should get trivia for the number from the repository',
    () async {
      // Arrange
      when(repository.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // Act
      final result = await usecase(const Parameters(number: tNumber));
      // Assert
      expect(result, const Right(tNumberTrivia));
      verify(repository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(repository);
    },
  );
}
