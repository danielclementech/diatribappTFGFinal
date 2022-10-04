import 'dart:io';

import 'package:diatribapp/models/user_record.dart';
import 'package:diatribapp/repositories/posts_repository.dart';
import 'package:diatribapp/repositories/songkick_repository.dart';
import 'package:diatribapp/repositories/spotify_repository.dart';
import 'package:diatribapp/repositories/user_repository.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '../models/Artist.dart';
import '../models/user.dart';
import '../util.dart';

class EventDetailsBloc implements Bloc {
  final _events_repository = EventsRepository();
  final _spotify_repository = SpotifyRepository();
  final _user_repository = UserRepository();
  final _posts_repository = PostsRepository();

  bool isInWishList = false;
  bool isInList = false;
  Future<String> uploadFile(String path, File file) => _user_repository.uploadFile(path, file);

  void addShowOnWishlist(String showId) => _user_repository.addShowOnWishlist(showId);
  void deleteShowOnWishlist(String showId) => _user_repository.deleteShowOnWishlist(showId);
  void newShowOnlist(String showId, String? downloadUrl) =>
      _user_repository.newShowOnlist(showId, downloadUrl);
  void addTicketToShow(String showId, String? downloadUrl) =>
      _user_repository.addTicketToShow(showId, downloadUrl);

  Future<bool> isInMyWishlist(String id) async {
    final wishlist = currentUserDocument!.showsWishlist?.toList();
    final list = [];
    if (wishlist != null) {
      if (wishlist.contains(id)) {
        isInWishList = true;
        if (list != null) {
          for (var l in list) {
            if (l.id == id) {
              isInList = true;
              return true;
            }
          }
          return false;
        } else {
          return false;
        }
      } else {
        if (list != null) {
          for (var l in list) {
            if (l.id == id) {
              isInList = true;
              return true;
            }
          }
          return false;
        } else {
          return false;
        }
      }
    } else {
      if (list != null) {
        for (var l in list) {
          if (l.id == id) {
            isInList = true;
            return true;
          }
        }
        return false;
      } else {
        return false;
      }
    }
  }

  Future<User> getUserById(String id) => _spotify_repository.getUserById(id);

  Future<String?> getArtistId(String artist) => _events_repository.getArtistId(artist);
  Future<List<Artist>?> searchArtist(String word, {int limit = 20, int offset = 0}) =>
      _spotify_repository.searchArtist(word, limit: limit, offset: offset);

  void newEventPost(String event, bool wishlist) => _posts_repository.newEventPost(event, wishlist);

  Future<List<UserRecord>> friendsWishlist(String eventId) async {
    List<UserRecord> result = [];
    final friendsIds = currentUserDocument!.friends;
    List<UserRecord> friends = [];
    if (friendsIds != null && friendsIds.isNotEmpty) {
      for (var friend in friendsIds) {
        final doc = await UserRecord.getDocumentOnce(friend);
        friends.add(doc);
      }
      for (var user in friends) {
        if (user.showsWishlist != null) {
          if (user.showsWishlist!.contains(eventId)) {
            result.add(user);
          }
        }
      }
    }
    return result;
  }

  @override
  void dispose() {}
}
