import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/domain/use_cases/use_case.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/util/presentation/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late MockGetConcreteNumberTrivia mockConcrete;
  late MockGetRandomNumberTrivia mockRandom;
  late MockInputConverter mockConverter;
  late NumberTriviaBloc sut;

  setUp(() {
    mockConcrete = MockGetConcreteNumberTrivia();
    mockRandom = MockGetRandomNumberTrivia();
    mockConverter = MockInputConverter();
    sut = NumberTriviaBloc(
      getConcreteNumberTrivia: mockConcrete,
      getRandomNumberTrivia: mockRandom,
      inputConverter: mockConverter,
    );
  });

  test('Initial state should be NumberTriviaInitial', () async {
    expect(sut.state, NumberTriviaInitial());
  });

  group(
    'GetTriviaForConcreteNumber',
    () {
      const tNumberParsed = 1;
      const tNumberString = '1';
      const tNumberTrivia = NumberTrivia(number: 1, text: 'Text trivia');

      blocTest(
        'should emit [NumberTriviaError] when the input in invalid',
        build: () {
          when(() => mockConverter.stringToUnsignedInteger(any()))
              .thenReturn(Left(InvalidInputFailure()));
          return sut;
        },
        act: (NumberTriviaBloc bloc) {
          bloc.add(const GetConcreteNumberTriviaEvent(tNumberString));
        },
        expect: () => [
          NumberTriviaLoading(),
          const NumberTriviaError(message: invalidInputFailureMessage),
        ],
        verify: (_) {
          verifyNever(
            () => mockConcrete(const Parameters(number: tNumberParsed)),
          );
        },
      );

      blocTest(
        'should emit number trivia when the input is valid',
        build: () {
          when(() => mockConverter.stringToUnsignedInteger(any()))
              .thenReturn(const Right(tNumberParsed));
          when(() => mockConcrete(const Parameters(number: tNumberParsed)))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          return sut;
        },
        act: (NumberTriviaBloc bloc) async {
          bloc.add(const GetConcreteNumberTriviaEvent(tNumberString));
        },
        verify: (NumberTriviaBloc bloc) async {
          verify(() => mockConverter.stringToUnsignedInteger(tNumberString));
          verify(() => mockConcrete(const Parameters(number: tNumberParsed)));
        },
        expect: () => [
          NumberTriviaLoading(),
          const NumberTriviaLoaded(trivia: tNumberTrivia),
        ],
      );

      blocTest(
        '''
        should emit [NumberTriviaError] with serverFailureMessage when 
      [GetTriviaForConcreteNumber] responds with a [ServerFailure]''',
        build: () {
          when(() => mockConverter.stringToUnsignedInteger(any()))
              .thenReturn(const Right(tNumberParsed));
          when(() => mockConcrete(const Parameters(number: tNumberParsed)))
              .thenAnswer((_) async => Left(ServerFailure()));
          return sut;
        },
        act: (NumberTriviaBloc bloc) {
          bloc.add(const GetConcreteNumberTriviaEvent(tNumberString));
        },
        expect: () => [
          NumberTriviaLoading(),
          const NumberTriviaError(message: serverFailureMessage),
        ],
      );

      blocTest(
        '''should emit [NumberTriviaError] with cacheFailureMessage when 
      [GetTriviaForConcreteNumber] responds with a [CacheFailure]''',
        build: () {
          when(() => mockConverter.stringToUnsignedInteger(any()))
              .thenReturn(const Right(tNumberParsed));
          when(() => mockConcrete(const Parameters(number: tNumberParsed)))
              .thenAnswer((_) async => Left(CacheFailure()));
          return sut;
        },
        act: (NumberTriviaBloc bloc) {
          bloc.add(const GetConcreteNumberTriviaEvent(tNumberString));
        },
        expect: () => [
          NumberTriviaLoading(),
          const NumberTriviaError(message: cacheFailureMessage),
        ],
      );
    },
  );

  group(
    'GetTriviaForRandomNumber',
    () {
      const tNumberTrivia = NumberTrivia(number: 1, text: 'Text trivia');

      blocTest(
        'should not use [InputConverter]',
        setUp: () {
          reset(mockConverter);
        },
        build: () {
          when(() => mockRandom(NoParameters()))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          return sut;
        },
        act: (NumberTriviaBloc bloc) async {
          bloc.add(GetRandomNumberTriviaEvent());
        },
        verify: (NumberTriviaBloc bloc) async {
          verifyZeroInteractions(mockConverter);
        },
      );

      blocTest(
        'should emit [NumberTriviaLoaded] when the [GetTriviaForRandomNumber] return a [NumberTrivia]',
        build: () {
          when(() => mockRandom(NoParameters()))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          return sut;
        },
        act: (NumberTriviaBloc bloc) async {
          bloc.add(GetRandomNumberTriviaEvent());
        },
        verify: (NumberTriviaBloc bloc) async {
          verify(() => mockRandom(NoParameters()));
        },
        expect: () => [
          NumberTriviaLoading(),
          const NumberTriviaLoaded(trivia: tNumberTrivia),
        ],
      );

      blocTest(
        '''should emit [NumberTriviaError] with serverFailureMessage when 
      [GetTriviaForRandomNumber] responds with a [ServerFailure]''',
        build: () {
          when(() => mockRandom(NoParameters()))
              .thenAnswer((_) async => Left(ServerFailure()));
          return sut;
        },
        act: (NumberTriviaBloc bloc) {
          bloc.add(GetRandomNumberTriviaEvent());
        },
        expect: () => [
          NumberTriviaLoading(),
          const NumberTriviaError(message: serverFailureMessage),
        ],
      );

      blocTest(
        '''should emit [NumberTriviaError] with cacheFailureMessage when 
      [GetTriviaForRandomNumber] responds with a [CacheFailure]''',
        build: () {
          when(() => mockRandom(NoParameters()))
              .thenAnswer((_) async => Left(CacheFailure()));
          return sut;
        },
        act: (NumberTriviaBloc bloc) {
          bloc.add(GetRandomNumberTriviaEvent());
        },
        expect: () => [
          NumberTriviaLoading(),
          const NumberTriviaError(message: cacheFailureMessage),
        ],
      );
    },
  );
}
