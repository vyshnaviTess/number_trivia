import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/domain/use_cases/use_case.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/gateways/number_trivia_repository.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParameters> {
  final NumberTriviaGateway gateway;

  GetRandomNumberTrivia({
    required this.gateway,
  });

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParameters parameters) async {
    return await gateway.getRandomNumberTrivia();
  }
}
