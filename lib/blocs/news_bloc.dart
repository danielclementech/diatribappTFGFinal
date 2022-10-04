import 'package:diatribapp/repositories/songkick_repository.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/Album.dart';
import '../models/Artist.dart';
import '../models/Event.dart';
import '../repositories/spotify_repository.dart';
import '../util.dart';
import '../utils/lat_lng.dart';

class NewsBloc implements Bloc {
  final _spotify_repository = SpotifyRepository();
  final _events_repository = EventsRepository();

  Future<List<Event>> getMyShows(int distance) async {
    final artists = currentUserDocument!.topArtists;
    List<Event> shows = [];
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (artists != null) {
      final artists20 = artists.sublist(0, 19);
      String artistsString = '';
      for (var artId in artists20) {
        artistsString += artId;
        artistsString += ',';
      }
      artistsString = artistsString.substring(0, artistsString.length - 1);
      final artistsSpotify = await _spotify_repository.getSeveralArtists(artistsString);
      for (var artist in artistsSpotify!) {
        final id = await _events_repository.getArtistId(artist.name);
        if (id != null) {
          List<Event>? showsOfArtist = await _events_repository.getShows(id);
          if (showsOfArtist != null) {
            for (var showOfArtist in showsOfArtist) {
              shows.removeWhere((e) => e.name == showOfArtist.name);
              shows.add(showOfArtist);
            }
          }
        }
      }
    }
    final location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Event> result = [];
    for (var show in shows) {
      if (show.locationLngLat != null) {
        final distance2 =
            getDistance(LatLng(location.latitude, location.longitude), show.locationLngLat!);
        if (distance2 < distance * 1000) {
          result.add(show);
        }
      }
    }
    result.sort((a, b) => a.time.compareTo(b.time));
    return result;
  }

  Future<String> getMyCity() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    if (placemarks[0].locality != null && placemarks[0].country != null) {
      return placemarks[0].locality! + ', ' + placemarks[0].country!;
    } else {
      return '';
    }
  }

  double getDistance(LatLng myPosition, LatLng concertPosition) {
    final dist = Geolocator.distanceBetween(myPosition.latitude, myPosition.longitude,
        concertPosition.latitude, concertPosition.longitude);
    return dist;
  }

  Future<List<Album>> getMyNewReleases() async {
    final artists = currentUserDocument!.topArtists;
    List<Album> newAlbums = [];
    if (artists != null) {
      final artists20 = artists.sublist(0, 19);
      for (var artistId in artists20) {
        List<Album>? albums = await _spotify_repository.getAlbumsOfArtist(artistId);
        if (albums != null) {
          for (var album in albums) {
            if (album.releaseDate.isAfter(DateTime.now().subtract(Duration(days: 30)))) {
              newAlbums.add(album);
            }
          }
        }
      }
    }
    newAlbums.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
    return newAlbums;
  }

  //Artists
  Future<List<Artist>?> searchArtist(String word) => _spotify_repository.searchArtist(word);
  Future<String?> getArtistId(String artist) => _events_repository.getArtistId(artist);

  @override
  void dispose() {}
}
