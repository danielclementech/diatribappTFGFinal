import 'dart:convert';

import 'package:diatribapp/models/Artist.dart';
import 'package:diatribapp/services/api_path.dart';
import 'package:diatribapp/services/spotify_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../models/Album.dart';
import '../models/Playlist.dart';
import '../models/Song.dart';
import '../models/user.dart';
import '../util.dart';

typedef NestedApiPathBuilder<T> = String Function(T listItem);

class PremiumRequiredException implements Exception {}

class NoActiveDeviceFoundException implements Exception {}

class SpotifyApi {
  static Client client = InterceptedClient.build(interceptors: [
    SpotifyInterceptor(),
  ], retryPolicy: ExpiredTokenRetryPolicy());

  Future<User> getCurrentUser() async {
    final response = await client.get(
      Uri.parse(APIPath.getCurrentUser),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get user with status code ${response.statusCode}');
    }
  }

  Future<User> getUserById(String id) async {
    final response = await client.get(
      Uri.parse(APIPath.getUserById(id)),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get user with status code ${response.statusCode}');
    }
  }

  Future<List<Playlist>> getMyPlaylitsts({int limit = 20, int offset = 0}) async {
    final response = await client.get(
      Uri.parse(APIPath.getListOfMyPlaylists(offset, limit)),
    );

    if (response.statusCode == 200) {
      List items = json.decode(response.body)['items'];

      return items.map((item) => Playlist.fromJson(item)).toList();
    } else {
      throw Exception('Failed to get user with status code ${response.statusCode}');
    }
  }

  Future<List<Artist>> getTopArtists(String time_range, {int limit = 30, int offset = 0}) async {
    final response = await client.get(
      Uri.parse(APIPath.getTopArtists(offset, limit, time_range)),
    );

    if (response.statusCode == 200) {
      List items = json.decode(response.body)['items'];

      return items.map((item) => Artist.fromJson(item)).toList();
    } else {
      throw Exception('Failed to get user with status code ${response.statusCode}');
    }
  }

  Future<List<Song>> getTopSongs(String time_range, {int limit = 20, int offset = 0}) async {
    final response = await client.get(
      Uri.parse(APIPath.getTopSongs(offset, limit, time_range)),
    );

    if (response.statusCode == 200) {
      List items = json.decode(response.body)['items'];

      return items.map((item) => Song.fromJson(item)).toList();
    } else {
      throw Exception('Failed to get user with status code ${response.statusCode}');
    }
  }

  Future<List<Song>?> searchSong(String word, {int limit = 20, int offset = 0}) async {
    final response = await client.get(
      Uri.parse(APIPath.searchSong(offset, limit, word)),
    );

    if (response.statusCode == 200) {
      List items = json.decode(response.body)['tracks']['items'];
      if (items.isNotEmpty) {
        return items.map((item) => Song.fromJson(item)).toList();
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to get user with status code ${response.statusCode}');
    }
  }

  Future<Song> getSong(String songId) async {
    final response = await client.get(
      Uri.parse(APIPath.getSong(songId)),
    );
    if (response.statusCode == 200) {
      return Song.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to get user with status code ${response.statusCode}, ${response.body}');
    }
  }

  Future<Artist> getArtist(String artistId) async {
    final response = await client.get(
      Uri.parse(APIPath.getArtist(artistId)),
    );
    if (response.statusCode == 200) {
      return Artist.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get user with status code ${response.statusCode}');
    }
  }

  Future<List<Artist>?> getSeveralArtists(String artists) async {
    final response = await client.get(
      Uri.parse(APIPath.getSeveralArtists(artists)),
    );
    if (response.statusCode == 200) {
      List items = json.decode(response.body)['artists'];
      if (items.isNotEmpty) {
        return items.map((item) => Artist.fromJson(item)).toList();
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to get user with status code ${response.statusCode}');
    }
  }

  Future<List<Artist>?> searchArtist(String word, {int limit = 20, int offset = 0}) async {
    final response = await client.get(
      Uri.parse(APIPath.searchArtist(offset, limit, word)),
    );

    if (response.statusCode == 200) {
      List items = json.decode(response.body)['artists']['items'];
      if (items.isNotEmpty) {
        return items.map((item) => Artist.fromJson(item)).toList();
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to get user with status code ${response.statusCode}');
    }
  }

  Future<List<Album>?> getAlbumsOfArtist(String artistId, {int limit = 20, int offset = 0}) async {
    final response = await client.get(
      Uri.parse(APIPath.getAlbumsOfArtist(offset, limit, artistId)),
    );

    if (response.statusCode == 200) {
      List items = json.decode(response.body)['items'];
      if (items.isNotEmpty) {
        return items.map((item) => Album.fromJson(item)).toList();
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to get user with status code ${response.statusCode}');
    }
  }

  Future<List<Song>?> getRecommendations({int limit = 20, int offset = 0}) async {
    final artists = currentUserDocument!.topArtists!.toList().sublist(0, 1);
    var artistsString = artists.toString();
    artistsString = artistsString.replaceAll('[', '');
    artistsString = artistsString.replaceAll(']', '');
    artistsString = artistsString.replaceAll(' ', '');
    final songs = currentUserDocument!.topSongs!.toList().sublist(0, 1);
    var songsString = songs.toString();
    songsString = songsString.replaceAll('[', '');
    songsString = songsString.replaceAll(']', '');
    songsString = songsString.replaceAll(' ', '');
    final genres = await getGenres();
    var genresString = genres!.sublist(0, 0).toString();
    genresString = genresString.replaceAll('[', '');
    genresString = genresString.replaceAll(']', '');
    genresString = genresString.replaceAll(' ', '');
    final response = await client.get(
      Uri.parse(
          APIPath.getRecommendations(offset, limit, artistsString, songsString, genresString)),
    );

    if (response.statusCode == 200) {
      List items = json.decode(response.body)['tracks'];
      if (items.isNotEmpty) {
        return items.map((item) => Song.fromJson(item)).toList();
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to get user with status code ${response.statusCode}');
    }
  }

  Future<List<String>?> getGenres() async {
    final response = await client.get(
      Uri.parse(APIPath.getGenreSeed()),
    );

    if (response.statusCode == 200) {
      List items = json.decode(response.body)['genres'];
      if (items.isNotEmpty) {
        return items.map((item) => item.toString()).toList();
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to get user with status code ${response.statusCode}');
    }
  }

  Future<List<Album>?> getNewReleases({int limit = 20, int offset = 0}) async {
    final response = await client.get(
      Uri.parse(APIPath.getNewReleases(offset, limit, 'ES')),
    );

    if (response.statusCode == 200) {
      List items = json.decode(response.body)['albums']['items'];
      if (items.isNotEmpty) {
        return items.map((item) => Album.fromJson(item)).toList();
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to get user with status code ${response.statusCode}');
    }
  }
}
