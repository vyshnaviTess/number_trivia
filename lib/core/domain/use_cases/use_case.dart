import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../error/failure.dart';

abstract class UseCase<Type, Parameters> {
  Future<Either<Failure, Type>> call(Parameters parameters);
}

class NoParameters extends Equatable {
  @override
  List<Object?> get props => [];
}
