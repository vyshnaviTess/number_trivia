import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/domain/use_cases/use_case.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/util/presentation/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/use_cases/get_concrete_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const notFoundMessage = 'Trivia not found';
const serverFailureMessage = 'Server Failure';
const cacheFailureMessage = 'Cache Failure';
const invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  late UseCase<NumberTrivia, Parameters> getConcreteNumberTrivia;
  late UseCase<NumberTrivia, NoParameters> getRandomNumberTrivia;
  late InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(NumberTriviaInitial()) {
    _initEvents();
  }

  void _initEvents() {
    //! GetConcreteNumberTriviaEvent
    on<GetConcreteNumberTriviaEvent>((event, emit) async =>
        await _handleGetConcreteNumberTriviaEvent(event, emit));

    //! GetRandomNumberTriviaEvent
    on<GetRandomNumberTriviaEvent>((event, emit) async =>
        await _handleGetRandomNumberTriviaEvent(event, emit));
  }

  Future<void> _handleGetConcreteNumberTriviaEvent(
    GetConcreteNumberTriviaEvent event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(NumberTriviaLoading());
    final integer = inputConverter
        .stringToUnsignedInteger(event.number)
        .getOrElse(() => -1);
    if (integer.isNegative) {
      emit(const NumberTriviaError(message: invalidInputFailureMessage));
    } else {
      final failureOrTrivia =
          await getConcreteNumberTrivia(Parameters(number: integer));
      failureOrTrivia.fold(
        (failure) {
          emit(
            NumberTriviaError(message: _mapFailureToMessage(failure)),
          );
        },
        (trivia) {
          emit(NumberTriviaLoaded(trivia: trivia));
        },
      );
    }
  }

  Future<void> _handleGetRandomNumberTriviaEvent(
    GetRandomNumberTriviaEvent event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(NumberTriviaLoading());
    final failureOrTrivia = await getRandomNumberTrivia(NoParameters());
    failureOrTrivia.fold(
      (failure) {
        emit(NumberTriviaError(message: _mapFailureToMessage(failure)));
      },
      (trivia) => emit(NumberTriviaLoaded(trivia: trivia)),
    );
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return serverFailureMessage;
    case CacheFailure:
      return cacheFailureMessage;
    default:
      return 'Unexpected Error';
  }
}
