import 'dart:convert';

import 'package:adviser/0_data/exceptions/exceptions.dart';
import 'package:adviser/0_data/models/advice_model.dart';
import 'package:http/http.dart' as http;

abstract class AdviceRemoteDataSource {
  /// Request a random advice from API.
  ///
  /// - Returns [AdviceModel] if succesfull
  /// - Throws a server exception if status code is not 200
  Future<AdviceModel> getRandomAdviceFromApi();
}

const apiUri = 'https://api.flutter-community.com/api/v1/advice';

class AdviceRemoteDataSourceImpl implements AdviceRemoteDataSource {
  final http.Client _client;

  AdviceRemoteDataSourceImpl({required http.Client client}) : _client = client;

  @override
  Future<AdviceModel> getRandomAdviceFromApi() async {
    final response = await _client.get(
      Uri.parse(apiUri),
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return AdviceModel.fromJson(jsonDecode(response.body));
    }
  }
}
