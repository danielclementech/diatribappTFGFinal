import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '../models/Album.dart';
import '../models/Artist.dart';
import '../models/Event.dart';
import '../repositories/songkick_repository.dart';
import '../repositories/spotify_repository.dart';

class ArtistBloc implements Bloc {
  final _spotify_repository = SpotifyRepository();
  final _events_repository = EventsRepository();

  //Artists
  Future<Artist> getArtist(String artistId) => _spotify_repository.getArtist(artistId);
  Future<List<Artist>?> searchArtist(String word, {int limit = 20, int offset = 0}) =>
      _spotify_repository.searchArtist(word, limit: limit, offset: offset);

  Future<List<Album>?> getMyNewReleases(String artistId) async {
    final albumsNow = await _spotify_repository.getAlbumsOfArtist(artistId);
    List<Album> newAlbums = [];
    if (albumsNow != null) {
      for (var album in albumsNow) {
        newAlbums.add(album);
      }
    }
    newAlbums.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
    return newAlbums;
  }

  Future<String?> getArtistId(String artist) => _events_repository.getArtistId(artist);

  //Shows
  Future<List<Event>?> getShows(String artistId) => _events_repository.getShows(artistId);

  @override
  void dispose() {}
}
