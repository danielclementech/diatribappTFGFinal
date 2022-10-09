import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diatribapp/models/chat_messages_record.dart';
import 'package:diatribapp/services/firebase_services.dart';

import '../models/chat_record.dart';
import '../models/friend_request_record.dart';
import '../models/user_record.dart';

class UserRepository {
  final _firebaseServices = FirebaseServices();

  Future<UserRecord?>? getUser() => _firebaseServices.getUser();

  void updateInstagramUrl(String instagramUrl) =>
      _firebaseServices.updateInstagramUrl(instagramUrl);

  void updateTopArtists(List<String> topArtists) => _firebaseServices.updateTopArtists(topArtists);
  void updateTopSongs(List<String> topSongs) => _firebaseServices.updateTopSongs(topSongs);

  void addShowOnWishlist(String showId) => _firebaseServices.addShowOnWishlist(showId);
  void deleteShowOnWishlist(String showId) => _firebaseServices.deleteShowOnWishlist(showId);

  void newShowOnlist(String showId, String? downloadUrl) =>
      _firebaseServices.newShowOnlist(showId, downloadUrl);

  void addTicketToShow(String showId, String? downloadUrl) =>
      _firebaseServices.addTicketToShow(showId, downloadUrl);

  void newFriendRequest(DocumentReference from, DocumentReference to) =>
      _firebaseServices.newFriendRequest(from, to);

  void acceptFriendRequest(DocumentReference request, DocumentReference from, DocumentReference to) =>
      _firebaseServices.acceptFriendRequest(request, from, to);

  void newChat(DocumentReference userA, DocumentReference userB) =>
      _firebaseServices.newChat(userA, userB);

  void newChatMessage(
          DocumentReference from, DocumentReference to, DocumentReference chat, String song, String comment) =>
      _firebaseServices.newChatMessage(from, to, chat, song, comment);

  Stream<List<UserRecord?>> queryUsersRecord(
          {required Query Function(Query) queryBuilder,
          int limit = -1,
          bool singleRecord = false}) =>
      _firebaseServices.queryUsersRecord(queryBuilder: queryBuilder);

  Stream<List<FriendRequestRecord?>> queryFriendRequestsRecord(
          {required Query Function(Query) queryBuilder,
          int limit = -1,
          bool singleRecord = false}) =>
      _firebaseServices.queryFriendRequestsRecord(queryBuilder: queryBuilder);

  Future<List<ChatRecord?>> queryChatsRecordOnce(
      {required Query Function(Query) queryBuilder,
        int limit = -1,
        bool singleRecord = false}) =>
      _firebaseServices.queryChatsRecordOnce(queryBuilder: queryBuilder);

  Stream<List<ChatRecord?>> queryChatsRecord(
      {required Query Function(Query) queryBuilder,
        int limit = -1,
        bool singleRecord = false}) =>
      _firebaseServices.queryChatsRecord(queryBuilder: queryBuilder);

  Stream<List<ChatMessagesRecord?>> queryChatMessagesRecord(
          {required Query Function(Query) queryBuilder}) =>
      _firebaseServices.queryChatMessagesRecord(queryBuilder: queryBuilder);

  Future<String> uploadFile(String path, File file) => _firebaseServices.uploadFile(path, file);
}
