import 'package:adviser/0_data/datasources/advice_remote_datasource.dart';
import 'package:adviser/0_data/exceptions/exceptions.dart';
import 'package:adviser/0_data/models/advice_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import 'advice_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  group('AdviceRemoteDatasource', () {
    var apiUri = 'https://api.flutter-community.com/api/v1/advice';
    final mockClient = MockClient();
    final adviceRemoteDataSourceUnderTest =
        AdviceRemoteDataSourceImpl(client: mockClient);

    group(
      'should return AdviceModel',
      () {
        test('when Client response was 200 and has valid data', () async {
          // GIVEN
          const inputAdvice = 'test advice';
          const inputAdviceId = 1;
          const inputResponseBody =
              '{"advice": "$inputAdvice", "advice_id": $inputAdviceId}';
          const inputStatusCode = 200;

          when(mockClient.get(
            Uri.parse(apiUri),
            headers: {'content-type': 'application/json'},
          )).thenAnswer((_) {
            return Future.value(
                http.Response(inputResponseBody, inputStatusCode));
          });

          // WHEN
          final result =
              await adviceRemoteDataSourceUnderTest.getRandomAdviceFromApi();

          // THEN
          const expected = AdviceModel(advice: inputAdvice, id: inputAdviceId);
          expect(result, expected);
        });
      },
    );

    group('should throw', () {
      test('a ServerException client response is not 200', () {
        // GIVEN
        const inputResponseBody = '';
        const inputStatusCode = 201;

        when(mockClient.get(
          Uri.parse(apiUri),
          headers: {'content-type': 'application/json'},
        )).thenAnswer((_) {
          return Future.value(
              http.Response(inputResponseBody, inputStatusCode));
        });

        // WHEN - THEN
        expect(() => adviceRemoteDataSourceUnderTest.getRandomAdviceFromApi(),
            throwsA(isA<ServerException>()));
      });

      test('a TypeError when client response is 200 but has no valid data', () {
        // GIVEN
        const inputResponseBody = '{"advice": "test"}';
        const inputStatusCode = 200;

        when(mockClient.get(
          Uri.parse(apiUri),
          headers: {'content-type': 'application/json'},
        )).thenAnswer((_) {
          return Future.value(
              http.Response(inputResponseBody, inputStatusCode));
        });

        // WHEN - THEN
        expect(() => adviceRemoteDataSourceUnderTest.getRandomAdviceFromApi(),
            throwsA(isA<TypeError>()));
      });
    });
  });
}
