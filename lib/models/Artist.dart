class Artist {
  final String id;
  final String name;
  final String? image;
  final String externalUrl;
  final int? followers;

  Artist({
    required this.id,
    required this.name,
    this.image,
    required this.externalUrl,
    this.followers,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final image =
        (json['images'] != null && json['images'].length != 0) ? json['images'][0]['url'] : null;
    final id = json['id'];
    final externalUrl = json['external_urls']['spotify'];
    final followers = json['followers'] != null ? json['followers']['total'] : null;

    return Artist(
      name: name,
      id: id,
      image: image,
      externalUrl: externalUrl,
      followers: followers,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'image': image,
        'external_url': externalUrl,
        'followers': followers,
      };

}
