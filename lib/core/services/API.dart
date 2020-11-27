import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../models/Toilet.dart';

class API {
  static http.Client client;
  static final url = "https://budipest-api.herokuapp.com/api/v1";

  static void init() {
    client = http.Client();
  }

  static Future<List<Toilet>> getToilets(LocationData userLocation) async {
    try {
      final response = await client.get('$url/toilets');
      final body = json.decode(response.body)["data"];
      List<Toilet> data = body.map<Toilet>((toiletRaw) {
        Toilet toilet = Toilet.fromMap(Map.from(toiletRaw));
        toilet.calculateDistance(userLocation.latitude, userLocation.longitude);
        return toilet;
      }).toList();

      data.sort((a, b) => a.distance.compareTo(b.distance));

      return data;
    } catch (error) {
      print(error);
    }
  }

  static Future<Toilet> getToilet(String id) async {
    try {
      final response = await client.get('$url/toilets/$id');
      final body = json.decode(response.body);
      final data = Toilet.fromMap(body);

      return data;
    } catch (error) {
      print(error);
    }
  }

  static Future<Toilet> addToilet(Toilet toilet) async {
    try {
      final response = await client.post(
        '$url/toilets',
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json"
        },
        body: utf8.encode(json.encode(toilet.toJson())),
      );
      final body = json.decode(response.body);

      return body;
    } catch (error) {
      print(error);
    }
  }
}