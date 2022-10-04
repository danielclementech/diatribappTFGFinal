class User {
  final String id;
  final String name;
  final String avatarImage;
  final String spotifyUrl;

  User({required this.id, required this.name, required this.avatarImage, required this.spotifyUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    final name = json['display_name'];
    final avatarImage = json['images'].length != 0 ? json['images'][0]['url'] : null;
    final id = json['id'];
    final spotifyUrl = json['external_urls']['spotify'];
    return User(name: name, avatarImage: avatarImage, id: id, spotifyUrl: spotifyUrl);
  }

  Map<String, dynamic> toJson() => {
        'display_name': name,
        'images': [
          {'url': avatarImage}
        ],
        'id': id,
        'spotifyUrl': spotifyUrl
      };

}
