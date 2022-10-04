import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diatribapp/models/chat_record.dart';
import 'package:diatribapp/models/post_record.dart';
import 'package:diatribapp/models/show_struct.dart';
import 'package:diatribapp/repositories/posts_repository.dart';
import 'package:diatribapp/repositories/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '../models/Artist.dart';
import '../models/Song.dart';
import '../models/friend_request_record.dart';
import '../models/user.dart';
import '../models/user_record.dart';
import '../repositories/spotify_repository.dart';
import '../util.dart';

class ProfileBloc implements Bloc {
  final _spotify_repository = SpotifyRepository();
  final _user_repository = UserRepository();
  final _posts_repository = PostsRepository();

  Future<List<Song>> getTopSongsMix() async {
    final mediumSongs = await _spotify_repository.getTopSongs('medium_term');
    final longSongs = await _spotify_repository.getTopSongs('long_term', limit: 50);
    final shortSongs = await _spotify_repository.getTopSongs('short_term');

    List<String> topSongs = [];
    for (var artist in shortSongs) {
      topSongs.add(artist.id);
    }
    List<String> medium = [];
    for (var artist in mediumSongs) {
      if (topSongs.contains(artist.id)) {
        topSongs.remove(artist.id);
        medium.add(artist.id);
      } else {
        topSongs.add(artist.id);
      }
    }
    topSongs = medium + topSongs;
    List<String> long = [];
    for (var artist in longSongs) {
      if (topSongs.contains(artist.id)) {
        topSongs.remove(artist.id);
        long.add(artist.id);
      } else {
        topSongs.add(artist.id);
      }
    }
    topSongs = long + topSongs;
    topSongs = topSongs.sublist(0, 20);
    List<Song> result = [];
    for (var songId in topSongs) {
      final song = await _spotify_repository.getSong(songId);
      result.add(song);
    }
    updateTopSongs(topSongs);
    return result;
  }

  Future<List<String>> getTopArtistsMix() async {
    final mediumArtists = await _spotify_repository.getTopArtists('medium_term');
    final longArtists = await _spotify_repository.getTopArtists('long_term', limit: 50);
    final shortArtists = await _spotify_repository.getTopArtists('short_term');

    List<String> topArtists = [];
    for (var artist in shortArtists) {
      topArtists.add(artist.id);
    }
    List<String> medium = [];
    for (var artist in mediumArtists) {
      if (topArtists.contains(artist.id)) {
        topArtists.remove(artist.id);
        medium.add(artist.id);
      } else {
        topArtists.add(artist.id);
      }
    }
    topArtists = medium + topArtists;
    List<String> long = [];
    for (var artist in longArtists) {
      if (topArtists.contains(artist.id)) {
        topArtists.remove(artist.id);
        long.add(artist.id);
      } else {
        topArtists.add(artist.id);
      }
    }
    topArtists = long + topArtists;
    updateTopArtists(topArtists);
    return topArtists;
  }

  void updateTopArtists(List<String> topArtists) => _user_repository.updateTopArtists(topArtists);
  void updateTopSongs(List<String> topSongs) => _user_repository.updateTopSongs(topSongs);

  Future<Artist> getArtist(String artistId) => _spotify_repository.getArtist(artistId);
  Future<Song> getSong(String songId) => _spotify_repository.getSong(songId);

  Future<List<Song>> getSongs(List<String> songs) async {
    List<Song> result = [];
    for (var songId in songs) {
      final song = await _spotify_repository.getSong(songId);
      result.add(song);
    }
    return result;
  }

  Stream<List<PostRecord?>> getMyPosts() {
    return _posts_repository.queryPostsRecord(
        queryBuilder: (PostRecord) =>
            PostRecord.where('user', isEqualTo: currentUserDocument!.reference)
                .orderBy('created_time', descending: true));
  }

  //OtherUser
  Stream<List<PostRecord?>> getOtherPosts(DocumentReference userRef) {
    return _posts_repository.queryPostsRecord(
      queryBuilder: (PostRecord) =>
          PostRecord.where('user', isEqualTo: userRef).orderBy('created_time', descending: true),
    );
  }

  List<String> getCommonArtists(UserRecord user) {
    List<String> artistList = [];
    if (user.topArtists != null) {
      artistList = user.topArtists!.toList();
    }
    List<String> myArtistList = [];
    if (user.topArtists != null) {
      myArtistList = currentUserDocument!.topArtists!.toList();
    }
    final artistLists = [
      myArtistList,
      artistList,
    ];
    return artistLists
        .fold<Set>(artistLists.first.toSet(), (a, b) => a.intersection(b.toSet()))
        .toList() as List<String>;
  }

  List<String> getCommonShows(UserRecord user) {
    List<String> commonShows = [];
    List<ShowStruct> showsList = [];
    if (user.showsList != null) {
      showsList = user.showsList!.asList();
    }
    List<ShowStruct> myShowsList = [];
    if (user.topArtists != null) {
      myShowsList = currentUserDocument!.showsList!.toList();
    }
    for (var show in myShowsList) {
      for (var show2 in showsList) {
        if (show.id == show2.id) {
          commonShows.add(show.id!);
        }
      }
    }
    return commonShows;
  }

  Future<List<Song>> getCommonSongs(UserRecord user) async {
    List<String> songsList = [];
    if (user.topSongs != null) {
      songsList = user.topSongs!.toList();
    }
    List<String> mySongsList = [];
    if (user.topSongs != null) {
      mySongsList = currentUserDocument!.topSongs!.toList();
    }
    final songsLists = [
      songsList,
      mySongsList,
    ];
    debugPrint(songsLists.toString());
    final songs = songsLists
        .fold<Set>(songsLists.first.toSet(), (a, b) => a.intersection(b.toSet()))
        .toList() as List<String>;
    List<Song> result = [];
    for (var songId in songs) {
      final song = await _spotify_repository.getSong(songId);
      result.add(song);
    }
    return result;
  }

  Stream<List<UserRecord?>> getAllUsers() =>
      _user_repository.queryUsersRecord(queryBuilder: (UserRecord) => UserRecord);
  Future<User> getUserById(String id) => _spotify_repository.getUserById(id);

  void newFriendRequest(DocumentReference from, DocumentReference to) =>
      _user_repository.newFriendRequest(from, to);

  void acceptFriendRequest(DocumentReference request, DocumentReference from, DocumentReference to) =>
      _user_repository.acceptFriendRequest(request, from, to);

  Stream<List<FriendRequestRecord?>> getMyFriendRequests() =>
      _user_repository.queryFriendRequestsRecord(
          queryBuilder: (FriendRequestRecord) =>
              FriendRequestRecord.where('to', isEqualTo: currentUserDocument!.reference));

  updateInstagramUrl(String instagramUrl) => _user_repository.updateInstagramUrl(instagramUrl);

  void newChat(DocumentReference userA, DocumentReference userB) =>
      _user_repository.newChat(userA, userB);

  Future<ChatRecord?> chatExists(DocumentReference userB) async {
    final chatsA = await _user_repository.queryChatsRecordOnce((queryBuilder) => queryBuilder
        .where('user_a', isEqualTo: currentUserDocument!.reference)
        .where('user_b', isEqualTo: userB));
    final chatsB = await _user_repository.queryChatsRecordOnce((queryBuilder) => queryBuilder
        .where('user_b', isEqualTo: currentUserDocument!.reference)
        .where('user_a', isEqualTo: userB));
    if (chatsA.isNotEmpty) {
      return chatsA[0];
    } else if (chatsB.isNotEmpty) {
      return chatsB[0];
    }
  }

  @override
  void dispose() {}
}
