import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Toilet.dart';

class API {
  static http.Client _client;
  static final _url = "https://budipest-api.herokuapp.com/api/v1";
  static final _defaultHeaders = {
    "Accept": "application/json",
    "Content-type": "application/json"
  };

  static void init() {
    _client = http.Client();
  }

  static Future<List<Toilet>> getToilets() async {
    final response = await _client.get('$_url/toilets');
    final body = json.decode(response.body)["data"];

    return body
        .map<Toilet>((toiletRaw) => Toilet.fromMap(Map.from(toiletRaw)))
        .toList();
  }

  static Future<Toilet> getToilet(String id) async {
    final response = await _client.get('$_url/toilets/$id');
    final body = json.decode(response.body);

    return Toilet.fromMap(body);
  }

  static Future<Toilet> addToilet(Toilet toilet) async {
    final response = await _client.post(
      '$_url/toilets',
      headers: _defaultHeaders,
      body: utf8.encode(json.encode(toilet.toJson())),
    );

    final body = json.decode(response.body)["toilet"];

    return Toilet.fromMap(body);
  }

  static Future<Toilet> voteToilet(
    String toiletId,
    String userId,
    int vote,
  ) async {
    final response = await _client.post(
      '$_url/toilets/$toiletId/votes/$userId',
      headers: _defaultHeaders,
      body: utf8.encode(json.encode({"vote": vote})),
    );

    final body = json.decode(response.body)["toilet"];

    return Toilet.fromMap(body);
  }

  static Future<Toilet> addNote(
    String toiletId,
    String userId,
    String note,
  ) async {
    final response = await _client.post(
      '$_url/toilets/$toiletId/notes/$userId',
      headers: _defaultHeaders,
      body: utf8.encode(json.encode({"note": note})),
    );

    final body = json.decode(response.body)["toilet"];

    return Toilet.fromMap(body);
  }

  static Future<Toilet> removeNote(String toiletId, String userId) async {
    final response = await _client.delete(
      '$_url/toilets/$toiletId/notes/$userId',
      headers: _defaultHeaders,
    );

    final body = json.decode(response.body)["toilet"];

    return Toilet.fromMap(body);
  }
}
