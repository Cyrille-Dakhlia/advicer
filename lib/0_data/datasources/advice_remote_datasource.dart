import 'dart:convert';

import 'package:adviser/0_data/exceptions/exceptions.dart';
import 'package:adviser/0_data/models/advice_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AdviceRemoteDataSource {
  /// Request a random advice from API.
  ///
  /// - Returns [AdviceModel] if succesfull
  /// - Throws a server exception if status code is not 200
  Future<AdviceModel> getRandomAdviceFromApi();

  Future<bool> updateFavoritesInDatabase(List<AdviceModel> updatedList);
}

const apiUri = 'https://api.flutter-community.com/api/v1/advice';
const advicesCollection = 'advices';
const favoritesDocument = 'favorites';

class AdviceRemoteDataSourceImpl implements AdviceRemoteDataSource {
  final http.Client _client;
  final _db = FirebaseFirestore.instance;

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

  @override
  Future<bool> updateFavoritesInDatabase(List<AdviceModel> updatedList) async {
    return _db
        .collection(advicesCollection)
        .doc(favoritesDocument)
        .set({'list': updatedList.map((am) => am.toFirestore()).toList()}).then(
            (value) {
      debugPrint('DocumentSnapshot successfully updated.'); //TODO: remove
      return true;
    }, onError: (e) {
      debugPrint('Error updating document $e'); //TODO: remove
      return false;
    });
  }
}
