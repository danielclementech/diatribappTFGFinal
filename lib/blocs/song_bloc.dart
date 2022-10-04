import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diatribapp/repositories/posts_repository.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '../models/Artist.dart';
import '../models/Event.dart';
import '../models/Song.dart';
import '../repositories/songkick_repository.dart';
import '../repositories/spotify_repository.dart';

class SongBloc implements Bloc {
  final _spotify_repository = SpotifyRepository();
  final _posts_repository = PostsRepository();
  final _events_repository = EventsRepository();

  Future<Song> getSong(String songId) => _spotify_repository.getSong(songId);

  Future<String?> getArtistId(String artist) => _events_repository.getArtistId(artist);

  Future<List<Artist>?> searchArtist(String word, {int limit = 20, int offset = 0}) =>
      _spotify_repository.searchArtist(word, limit: limit, offset: offset);

  Future<Event> getEvent(String eventId) => _events_repository.getEvent(eventId);

  //
  void likeASongPost(DocumentReference post) => _posts_repository.likeASongPost(post);
  void unlikeASongPost(DocumentReference post) => _posts_repository.unlikeASongPost(post);

  @override
  void dispose() {}
}
