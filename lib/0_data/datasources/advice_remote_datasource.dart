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

  Future<List<AdviceModel>> getFavoritesFromDataSource();
}

const apiUri = 'https://api.flutter-community.com/api/v1/advice';
const advicesCollection = 'advices';
const favoritesDocument = 'favorites';
// TODO: add in README (just for info) the Firestore structure of the collection (if it isn't defined, the first call of updateFavoritesInDatabase will create the collection ; if we ask to retrieve the favorites when the collection doesn't exist, an empty list is simply returned when calling getFavoritesFromDataSource)

class AdviceRemoteDataSourceImpl implements AdviceRemoteDataSource {
  final http.Client _client;
  final FirebaseFirestore _db;

  AdviceRemoteDataSourceImpl(
      {required http.Client client, required FirebaseFirestore firestore})
      : _client = client,
        _db = firestore;

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
    return await _db
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

  @override
  Future<List<AdviceModel>> getFavoritesFromDataSource() async {
    return await _db
        .collection(advicesCollection)
        .doc(favoritesDocument)
        .get()
        .then((doc) {
      final data = doc.data();

      if (data == null) {
        return []; //TODO: handle case where favoritesList is null (return Failure)
      }

      final dataList = List<Map<String, dynamic>>.from(data['list']);

      final List<AdviceModel> favoritesList = dataList
          .map((element) =>
              AdviceModel(advice: element['advice'], id: element['adviceId']))
          .toList();

      return favoritesList;
    }, onError: (e) {
      return []; //TODO: handle errors (return Failure)
    });
  }
}
