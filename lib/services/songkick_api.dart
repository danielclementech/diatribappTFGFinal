import 'dart:convert';

import 'package:diatribapp/services/api_path.dart';
import 'package:http/http.dart';

import '../models/Event.dart';

typedef NestedApiPathBuilder<T> = String Function(T listItem);

class PremiumRequiredException implements Exception {}

class NoActiveDeviceFoundException implements Exception {}

class SongkickApi {
  static Client client = Client();

  Future<String?> getArtistId(String artist) async {
    artist = artist.toLowerCase();
    final response = await client.get(
      Uri.parse(APIPath.getArtistIdSongkick(artist)),
    );
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      if (map['resultsPage']['results']['artist'] != null) {
        return map['resultsPage']['results']['artist'][0]['id'].toString();
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to get user with status code ${response.statusCode}');
    }
  }

  Future<List<Event>?> getShows(String artistId) async {
    final response = await client.get(
      Uri.parse(APIPath.getArtistShows(artistId)),
    );
    if (response.statusCode == 200) {
      List? items = json.decode(response.body)['resultsPage']['results']['event'];
      if (items == null) {
        return null;
      }
      return items.map((item) => Event.fromJson(item)).toList();
    } else {
      throw Exception('Failed to get user with status code ${response.statusCode}');
    }
  }

  Future<Event> getEvent(String eventId) async {
    final response = await client.get(
      Uri.parse(APIPath.getEvent(eventId)),
    );
    if (response.statusCode == 200) {
      final item = json.decode(response.body)['resultsPage']['results']['event'];
      return Event.fromJson(item);
    } else {
      throw Exception('Failed to get user with status code ${response.statusCode}');
    }
  }
}
