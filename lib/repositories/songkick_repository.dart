import 'package:diatribapp/models/Event.dart';
import 'package:diatribapp/services/songkick_api.dart';

class EventsRepository {
  final _songkickApi = SongkickApi();

  Future<String?> getArtistId(String artist) => _songkickApi.getArtistId(artist);

  Future<List<Event>?> getShows(String artistId) => _songkickApi.getShows(artistId);

  Future<Event> getEvent(String eventId) => _songkickApi.getEvent(eventId);
}
