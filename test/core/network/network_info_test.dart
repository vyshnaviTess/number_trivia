import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/network/network_info.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks(
  [InternetConnectionChecker],
)
void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('isConnected', () {
    test(
      'should forward the call to InternetConnectionChecker.hasConnection',
      () async {
        // Arrange
        when(mockInternetConnectionChecker.hasConnection)
            .thenAnswer((realInvocation) => Future.value(true));
        // Act
        await networkInfoImpl.isConnected;
        // Assert
        verify(mockInternetConnectionChecker.hasConnection);
        verifyNoMoreInteractions(mockInternetConnectionChecker);
      },
    );
  });
}
