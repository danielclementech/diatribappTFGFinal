import 'Artist.dart';
import 'Song.dart';

enum type { album, single, compilation }

class Album {
  final String id;
  final String name;
  final List<Artist> artists;
  final String albumImage;
  final int totalTracks;
  final List<Song> songs;
  final DateTime releaseDate;
  final String? spotifyUrl;

  Album(
      {required this.id,
      required this.name,
      required this.artists,
      required this.albumImage,
      required this.totalTracks,
      required this.songs,
      required this.releaseDate,
      this.spotifyUrl});

  factory Album.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final List<Artist> artists =
        (json['artists'] as List).map((artist) => Artist.fromJson(artist)).toList();
    final id = json['id'];
    final images = json['images'];
    final albumImage = images.length > 1
        ? images[1]['url']
        : images.length > 0
            ? images[0]['url']
            : null;
    final totalTracks = json['total_tracks'];
    List<Song> songs = [];
    if (json['tracks'] != null) {
      songs = json['tracks']['items'];
    }
    String date = json['release_date'];
    List<String> dates = date.split('-');
    DateTime releaseDate;
    if (dates.length == 1) {
      releaseDate = DateTime(int.parse(dates[0]));
    } else if (dates.length == 2) {
      releaseDate = DateTime(int.parse(dates[0]), int.parse(dates[1]));
    } else {
      releaseDate = DateTime(int.parse(dates[0]), int.parse(dates[1]), int.parse(dates[2]));
    }
    final spotifyUrl = json['external_urls']['spotify'];

    return Album(
        name: name,
        id: id,
        artists: artists,
        albumImage: albumImage,
        totalTracks: totalTracks,
        songs: songs,
        releaseDate: releaseDate,
        spotifyUrl: spotifyUrl);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'artists': artists,
        'albumImage': albumImage,
        'totalTracks': totalTracks,
        'songs': songs,
        'release_date': releaseDate
      };

}
