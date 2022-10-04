import 'package:diatribapp/services/keys.dart';

class APIPath {
  static final List<String> _scopes = [
    'user-read-private',
    'user-read-email',
    'playlist-read-private',
    'user-top-read',
    'user-follow-read'
  ];

  static String requestAuthorization(String clientId, String redirectUri, String state) =>
      'https://accounts.spotify.com/authorize?client_id=$clientId&response_type=code&redirect_uri=$redirectUri&state=$state&scope=${_scopes.join('%20')}';

  static String requestToken = 'https://accounts.spotify.com/api/token';
  static String getCurrentUser = 'https://api.spotify.com/v1/me';

  static String getUserById(String userId) => 'https://api.spotify.com/v1/users/$userId';

  static String getListOfMyPlaylists(int offset, int limit) =>
      'https://api.spotify.com/v1/me/playlists?limit=$limit&offset=$offset';

  static String getListOfPlaylists(String userId, int offset, int limit) =>
      'https://api.spotify.com/v1/users/$userId/playlists?limit=$limit&offset=$offset';

  static String getTopArtists(int offset, int limit, String time_range) =>
      'https://api.spotify.com/v1/me/top/artists?limit=$limit&offset=$offset&time_range=$time_range';

  static String getTopSongs(int offset, int limit, String time_range) =>
      'https://api.spotify.com/v1/me/top/tracks?limit=$limit&offset=$offset&time_range=$time_range';

  static String searchSong(int offset, int limit, String word) =>
      'https://api.spotify.com/v1/search?q=$word&type=track&limit=$limit&offset=$offset';

  static String getSong(String songId) => 'https://api.spotify.com/v1/tracks/$songId';

  static String getArtist(String artistId) => 'https://api.spotify.com/v1/artists/$artistId';

  static String getSeveralArtists(String artists) =>
      'https://api.spotify.com/v1/artists?ids=$artists';

  static String searchArtist(int offset, int limit, String word) =>
      'https://api.spotify.com/v1/search?q=$word&type=artist&limit=$limit&offset=$offset';

  static String getNewReleases(int offset, int limit, String country) =>
      'https://api.spotify.com/v1/browse/new-releases?country=$country&limit=$limit&offset=$offset';

  static String getAlbumsOfArtist(int offset, int limit, String artistId) =>
      'https://api.spotify.com/v1/artists/$artistId/albums?include_groups=album,single&limit=$limit&offset=$offset';

  static String getRecommendations(
          int offset, int limit, String artists, String songs, String genres) =>
      'https://api.spotify.com/v1/recommendations?seed_artists=$artists&seed_tracks=$songs&seed_genres=$genres';

  static String getGenreSeed() =>
      'https://api.spotify.com/v1/recommendations/available-genre-seeds';

  //SONGKICK

  static String getArtistIdSongkick(String artist) =>
      'https://api.songkick.com/api/3.0/search/artists.json?apikey=$songkickApiKey&query=$artist';

  static String getArtistShows(String artistId) =>
      'https://api.songkick.com/api/3.0/artists/$artistId/calendar.json?apikey=$songkickApiKey';

  static String getEvent(String eventId) =>
      'https://api.songkick.com/api/3.0/events/$eventId.json?apikey=$songkickApiKey';
}
