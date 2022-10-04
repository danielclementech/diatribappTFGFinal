import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diatribapp/models/user.dart';
import 'package:diatribapp/models/user_record.dart';
import 'package:diatribapp/repositories/posts_repository.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '../models/Artist.dart';
import '../models/Song.dart';
import '../repositories/songkick_repository.dart';
import '../repositories/spotify_repository.dart';
import '../services/auth_repository.dart';

class UserBloc implements Bloc {
  final _auth_repository = AuthRepository();
  final _spotify_repository = SpotifyRepository();
  final _posts_repository = PostsRepository();
  final _events_repository = EventsRepository();

  Future<UserRecord?>? get user => _auth_repository.getUser();

  //Iniciar sesiçon
  authenticate() => _auth_repository.authenticate();
  Future<void> signInFromSavedTokens() => _auth_repository.signInFromSavedTokens();

  //Tops

  Future<List<Song>> getTopSongsShort() async =>
      await _spotify_repository.getTopSongs('short_term');
  void newSongPost(String song, String comment) => _posts_repository.newSongPost(song, comment);

  //Users
  Future<User> getUserById(String id) => _spotify_repository.getUserById(id);
  Future<User> getCurrentUser() => _spotify_repository.getCurrentUser();

  //Songs
  Future<List<Song>?> searchSong(String word, {int limit = 20, int offset = 0}) =>
      _spotify_repository.searchSong(word, limit: limit, offset: offset);
  Future<Song> getSong(String songId) => _spotify_repository.getSong(songId);

  Future<String?> getArtistId(String artist) => _events_repository.getArtistId(artist);

  Future<List<Artist>?> searchArtist(String word, {int limit = 20, int offset = 0}) =>
      _spotify_repository.searchArtist(word, limit: limit, offset: offset);

  //
  void likeASongPost(DocumentReference post) => _posts_repository.likeASongPost(post);
  void unlikeASongPost(DocumentReference post) => _posts_repository.unlikeASongPost(post);

  @override
  void dispose() {}
}
