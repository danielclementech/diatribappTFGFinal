class Playlist {
  final String id;
  final String name;
  final String playlistImage;
  final String externalUrl;
  final String ownerId;
  final bool isPublic;
  final int numOfTracks;

  Playlist({
    required this.id,
    required this.name,
    required this.playlistImage,
    required this.externalUrl,
    required this.ownerId,
    required this.isPublic,
    required this.numOfTracks,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final playlistImage = json['images'].length != 0 ? json['images'][0]['url'] : null;
    final id = json['id'];
    final externalUrl = json['external_urls']['spotify'];
    final isPublic = json['public'];
    final numOfTracks = json['tracks']['total'];
    final ownerId = json['owner']['id'];

    return Playlist(
      name: name,
      id: id,
      playlistImage: playlistImage,
      externalUrl: externalUrl,
      ownerId: ownerId,
      isPublic: isPublic,
      numOfTracks: numOfTracks,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'playlist_image_url': playlistImage,
        'external_url': externalUrl,
        'is_public': isPublic,
        'num_of_tracks': numOfTracks,
        'owner': ownerId,
      };

}
