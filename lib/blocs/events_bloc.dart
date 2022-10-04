import 'dart:io';

import 'package:diatribapp/repositories/songkick_repository.dart';
import 'package:diatribapp/repositories/spotify_repository.dart';
import 'package:diatribapp/repositories/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:path_provider/path_provider.dart';

import '../models/Artist.dart';
import '../models/Event.dart';
import '../models/user_record.dart';
import '../util.dart';

class EventsBloc implements Bloc {
  final _events_repository = EventsRepository();
  final _spotify_repository = SpotifyRepository();
  final _user_repository = UserRepository();

  Future<String?> getArtistId(String artist) => _events_repository.getArtistId(artist);
  Future<List<Artist>?> searchArtist(String word) => _spotify_repository.searchArtist(word);

  Future<List<Event>?> getShows(String artistId) => _events_repository.getShows(artistId);

  Future<Event> getEvent(String eventId) => _events_repository.getEvent(eventId);

  Future<String> uploadFile(String path, File file) => _user_repository.uploadFile(path, file);
  void addTicketToShow(String showId, String? downloadUrl) =>
      _user_repository.addTicketToShow(showId, downloadUrl);

  Future<File> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    final response = await Dio().get(url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ));

    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return file;
  }

  Future<List<Map<String, dynamic>>> getMyShowsList() async {
    List<Map<String, dynamic>> result = [];
    currentUserDocument = await UserRecord.getDocumentOnce(currentUserReference!);
    if (currentUserDocument!.showsList != null) {
      final showsIds = currentUserDocument?.showsList?.toList();
      if (showsIds != null) {
        for (var i in showsIds) {
          Event show = await getEvent(i.id!);
          var showMap = {'show': show, 'ticket': i.ticket};
          result.add(showMap);
        }
      }
    }
    return result;
  }

  Future<List<Event>> getMyShowsWishlist() async {
    List<Event> result = [];
    currentUserDocument = await UserRecord.getDocumentOnce(currentUserReference!);
    if (currentUserDocument!.showsWishlist != null) {
      final showsIds = currentUserDocument?.showsWishlist?.toList();
      if (showsIds != null) {
        for (var id in showsIds) {
          Event show = await getEvent(id);
          result.add(show);
        }
      }
    }
    return result;
  }

  @override
  void dispose() {}
}
