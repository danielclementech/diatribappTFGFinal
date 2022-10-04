import 'package:diatribapp/services/spotify_api.dart';

import '../models/Album.dart';
import '../models/Artist.dart';
import '../models/Song.dart';
import '../models/user.dart';

class SpotifyRepository {
  final _spotifyApi = SpotifyApi();

  Future<User> getCurrentUser() => _spotifyApi.getCurrentUser();

  Future<User> getUserById(String id) => _spotifyApi.getUserById(id);

  Future<List<Artist>> getTopArtists(String time_range, {int limit = 30, int offset = 0}) =>
      _spotifyApi.getTopArtists(time_range, limit: limit, offset: offset);

  Future<List<Song>> getTopSongs(String time_range, {int limit = 30, int offset = 0}) =>
      _spotifyApi.getTopSongs(time_range, limit: limit, offset: offset);

  Future<List<Song>?> searchSong(String word, {int limit = 20, int offset = 0}) =>
      _spotifyApi.searchSong(word, limit: limit, offset: offset);

  Future<Song> getSong(String songId) => _spotifyApi.getSong(songId);

  Future<Artist> getArtist(String artistId) => _spotifyApi.getArtist(artistId);
  Future<List<Artist>?> getSeveralArtists(String artists) => _spotifyApi.getSeveralArtists(artists);

  Future<List<Artist>?> searchArtist(String word, {int limit = 20, int offset = 0}) =>
      _spotifyApi.searchArtist(word, limit: limit, offset: offset);

  Future<List<Album>?> getAlbumsOfArtist(String artistId, {int limit = 20, int offset = 0}) =>
      _spotifyApi.getAlbumsOfArtist(artistId, limit: limit, offset: offset);

  Future<List<Song>?> getRecommendations({int limit = 20, int offset = 0}) =>
      _spotifyApi.getRecommendations(limit: limit, offset: offset);
}
