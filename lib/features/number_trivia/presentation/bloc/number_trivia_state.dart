part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class NumberTriviaInitial extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class NumberTriviaLoading extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class NumberTriviaLoaded extends NumberTriviaState {
  final NumberTrivia trivia;

  const NumberTriviaLoaded({
    required this.trivia,
  });

  @override
  List<Object> get props => [trivia];
}

class NumberTriviaError extends NumberTriviaState {
  final String message;

  const NumberTriviaError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
