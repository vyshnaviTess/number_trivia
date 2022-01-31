import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/util/presentation/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInteger', () {
    test(
      'should return an integer when the string represents an unsigned integer',
      () async {
        // Arrange
        const str = '123';
        // Act
        final result = inputConverter.stringToUnsignedInteger(str);
        // Assert
        expect(result, equals(const Right(123)));
      },
    );

    test(
      'should return an InvalidInputFailure when the string does not represents an unsigned integer',
      () async {
        // Arrange
        const str = '2eee';
        // Act
        final result = inputConverter.stringToUnsignedInteger(str);
        // Assert
        expect(result, equals(Left(InvalidInputFailure())));
      },
    );
  });
}
