import 'Artist.dart';

class Song {
  final String id;
  final String name;
  final List<Artist> artists;
  final String albumImage;
  final int duration;
  final String? previewUrl;
  final String? spotifyUrl;

  Song(
      {required this.id,
      required this.name,
      required this.artists,
      required this.albumImage,
      required this.duration,
      required this.previewUrl,
      required this.spotifyUrl});

  factory Song.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final List<Artist> artists =
        (json['artists'] as List).map((artist) => Artist.fromJson(artist)).toList();
    final id = json['id'];
    final images = json['album']['images'];
    final albumImage = images.length > 1
        ? images[1]['url']
        : images.length > 0
            ? images[0]['url']
            : null;
    final duration = json['duration_ms'];
    final previewUrl = json['preview_url'];
    final spotifyUrl = json['external_urls']['spotify'];

    return Song(
        name: name,
        id: id,
        artists: artists,
        albumImage: albumImage,
        duration: duration,
        previewUrl: previewUrl,
        spotifyUrl: spotifyUrl);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'artists': artists,
        'albumImage': albumImage,
        'duration': duration,
        'preview_url': previewUrl,
      };

}
