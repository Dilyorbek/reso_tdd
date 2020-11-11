import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:reso_tdd/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfo;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(mockDataConnectionChecker);
  });

  void runTestHasConnection({@required bool isConnected}) {
    test(
      'should forward the call to DataConnectionChecker.hasConnection $isConnected',
          () async {
        when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => isConnected);

        final result = await networkInfo.isConnected;

        verify(mockDataConnectionChecker.hasConnection);
        expect(result, isConnected);
      },
    );
  }

  group('isConnected', () {
    runTestHasConnection(isConnected: true);
    runTestHasConnection(isConnected: false);
  });
}
