import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../core/domain/use_cases/use_case.dart';
import '../gateways/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Parameters> {
  final NumberTriviaGateway gateway;

  GetConcreteNumberTrivia({
    required this.gateway,
  });

  @override
  Future<Either<Failure, NumberTrivia>> call(
    Parameters parameters,
  ) async {
    return await gateway.getConcreteNumberTrivia(parameters.number);
  }
}

class Parameters extends Equatable {
  final int number;

  const Parameters({
    required this.number,
  });

  @override
  List<Object?> get props => [number];
}
