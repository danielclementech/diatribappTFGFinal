import 'package:diatribapp/utils/lat_lng.dart';

enum typeOfEvent { Concert, Festival }

class Event {
  final int id;
  final String name;
  final DateTime time;
  final String location;
  final LatLng? locationLngLat;
  final String externalUrl;
  final typeOfEvent type;
  final List<String> lineUp;

  Event(
      {required this.id,
      required this.name,
      required this.time,
      required this.location,
      this.locationLngLat,
      required this.externalUrl,
      required this.type,
      required this.lineUp});

  factory Event.fromJson(Map<String, dynamic> json) {
    final name = json['displayName'];
    final id = json['id'];
    DateTime time;
    String? timeString = json['start']['datetime'];
    if (timeString != null) {
      List<String> times = timeString.split('T');
      String day = times[0];
      String hour = '';
      List<String> hours = [];
      List<String> days = day.split('-');
      if (times.length > 1) {
        hour = times[1];
        hours = hour.split(':');
        time = DateTime(int.parse(days[0]), int.parse(days[1]), int.parse(days[2]),
            int.parse(hours[0]), int.parse(hours[1]));
      } else {
        time = DateTime(int.parse(days[0]), int.parse(days[1]), int.parse(days[2]));
      }
    } else {
      timeString = json['start']['date'];
      List<String> days = timeString!.split('-');
      time = DateTime(int.parse(days[0]), int.parse(days[1]), int.parse(days[2]));
    }

    final location = json['location']['city'];
    LatLng? locationLngLat;
    if (json['location']['lat'] != null && json['location']['lng'] != null) {
      locationLngLat = LatLng(json['location']['lat'], json['location']['lng']);
    }
    final externalUrl = json['uri'];
    final type = json['type'] == 'Festival' ? typeOfEvent.Festival : typeOfEvent.Concert;
    final artists = json['performance'];
    List<String> lineUp = [];
    for (var artist in artists) {
      lineUp.add(artist['displayName']);
    }
    return Event(
        name: name,
        id: id,
        time: time,
        location: location,
        locationLngLat: locationLngLat,
        externalUrl: externalUrl,
        type: type,
        lineUp: lineUp);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'time': time,
        'external_url': externalUrl,
        'location': location,
        'locationLngLat': locationLngLat,
        'type': type,
        'lineUp': lineUp
      };
}
