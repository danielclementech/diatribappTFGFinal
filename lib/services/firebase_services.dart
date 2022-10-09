import 'dart:io';

import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diatribapp/models/chat_messages_record.dart';
import 'package:diatribapp/models/chat_record.dart';
import 'package:diatribapp/models/friend_request_record.dart';
import 'package:diatribapp/models/show_struct.dart';
import 'package:diatribapp/models/user_record.dart';
import 'package:diatribapp/services/serializers.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/post_record.dart';
import '../models/user.dart';
import '../util.dart';

class FirebaseServices {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<UserRecord> createUser(User user) {
    final reference = firebaseFirestore.doc('/users/${user.id}');
    reference.set({'name': user.name, 'avatarUrl': user.avatarImage});
    currentUserReference = reference;
    return UserRecord.getDocumentOnce(currentUserReference!);
  }

  Future<UserRecord?>? getUser() {
    currentUserReference ??= firebaseFirestore.doc('/users/${currentUser?.id}');

    return UserRecord.getDocumentOnce(currentUserReference!);
  }

  void updateInstagramUrl(String instagramUrl) {
    currentUserReference ??= firebaseFirestore.doc('/users/${currentUser?.id}');
    currentUserReference?.update({'instagramUrl': instagramUrl});
  }

  void updateTopArtists(List<String> topArtists) {
    currentUserReference ??= firebaseFirestore.doc('/users/${currentUser?.id}');
    currentUserReference?.update({'topArtists': topArtists});
  }

  void updateTopSongs(List<String> topSongs) {
    currentUserReference ??= firebaseFirestore.doc('/users/${currentUser?.id}');
    currentUserReference?.update({'topSongs': topSongs});
  }

  void addShowOnWishlist(String showId) {
    currentUserReference ??= firebaseFirestore.doc('/users/${currentUser?.id}');
    currentUserReference?.update({
      'showsWishlist': FieldValue.arrayUnion([showId]),
    });
  }

  void deleteShowOnWishlist(String showId) {
    currentUserReference ??= firebaseFirestore.doc('/users/${currentUser?.id}');
    currentUserReference?.update({
      'showsWishlist': FieldValue.arrayRemove([showId]),
    });
  }

  void newFriendRequest(DocumentReference from, DocumentReference to) {
    final reference = firebaseFirestore.collection('friend_requests').doc();
    reference.set({'from': from, 'to': to, 'time': DateTime.now()});
  }

  void acceptFriendRequest(DocumentReference request, DocumentReference from, DocumentReference to) {
    request.delete();
    from.update({
      'friends': FieldValue.arrayUnion([to])
    });
    to.update({
      'friends': FieldValue.arrayUnion([from])
    });
  }

  void newChat(DocumentReference userA, DocumentReference userB) {
    final reference = firebaseFirestore.collection('chats').doc();
    reference.set({
      'user_a': userA,
      'user_b': userB,
    });
  }

  void newChatMessage(
    DocumentReference from,
    DocumentReference to,
    DocumentReference chat,
    String song,
    String comment
  ) {
    final reference = firebaseFirestore.collection('chat_messages').doc();
    reference.set({
      'from': from,
      'to': to,
      'song': song,
      'chat': chat,
      'time': Timestamp.now(),
      'comment': comment
    });
  }

  void likeASongPost(DocumentReference post) {
    post.update({
      'likes': FieldValue.arrayUnion([currentUserReference]),
    });
  }

  void unlikeASongPost(DocumentReference post) {
    post.update({
      'likes': FieldValue.arrayRemove([currentUserReference]),
    });
  }

  void newShowOnlist(String showId, String? downloadUrl) {
    currentUserReference ??= firebaseFirestore.doc('/users/${currentUser?.id}');
    deleteShowOnWishlist(showId);
    currentUserReference?.update({
      'showsList': FieldValue.arrayUnion([
        getShowFirestoreData(
          createShowStruct(
            id: showId,
            ticket: downloadUrl,
            clearUnsetFields: false,
          ),
          true,
        )
      ]),
    });
  }

  void addTicketToShow(String showId, String? downloadUrl) {
    currentUserReference ??= firebaseFirestore.doc('/users/${currentUser?.id}');
    currentUserReference?.update({
      'showsList': FieldValue.arrayRemove([
        getShowFirestoreData(
          createShowStruct(
            id: showId,
            clearUnsetFields: false,
          ),
          true,
        )
      ]),
    });
    currentUserReference?.update({
      'showsList': FieldValue.arrayUnion([
        getShowFirestoreData(
          createShowStruct(
            id: showId,
            ticket: downloadUrl,
            clearUnsetFields: false,
          ),
          true,
        )
      ]),
    });
  }

  void newSongPost(String song, String? comment) {
    currentUserReference ??= firebaseFirestore.doc('/users/${currentUser?.id}');
    final ref = firebaseFirestore.collection('posts').doc();
    ref.set({
      'song': song,
      'user': currentUserReference,
      'created_time': DateTime.now(),
      'comment': comment
    });
  }

  void newEventPost(String event, bool wishlist) {
    currentUserReference ??= firebaseFirestore.doc('/users/${currentUser?.id}');
    final ref = firebaseFirestore.collection('posts').doc();
    ref.set({
      'event': event,
      'typeOfPost': wishlist ? 'wishlist_event' : 'event',
      'user': currentUserReference,
      'created_time': DateTime.now()
    });
  }

  Future<String> uploadFile(String path, File file) async {
    final storageRef = firebaseStorage.ref().child(path);
    final result = await storageRef.putFile(file);
    return result.ref.getDownloadURL();
  }

  Stream<List<PostRecord?>> queryPostsRecord(
          {required Query Function(Query) queryBuilder,
          int limit = -1,
          bool singleRecord = false}) =>
      queryCollection(PostRecord.collection, PostRecord.serializer,
          queryBuilder: queryBuilder, limit: limit, singleRecord: singleRecord);

  Future<List<PostRecord?>> queryPostsRecordOnce(
          {required Query Function(Query) queryBuilder,
          int limit = -1,
          bool singleRecord = false}) =>
      queryCollectionOnce(PostRecord.collection, PostRecord.serializer,
          queryBuilder: queryBuilder, limit: limit, singleRecord: singleRecord);

  Stream<List<UserRecord?>> queryUsersRecord(
          {required Query Function(Query) queryBuilder,
          int limit = -1,
          bool singleRecord = false}) =>
      queryCollection(UserRecord.collection, UserRecord.serializer,
          queryBuilder: queryBuilder, limit: limit, singleRecord: singleRecord);

  Stream<List<FriendRequestRecord?>> queryFriendRequestsRecord(
          {required Query Function(Query) queryBuilder,
          int limit = -1,
          bool singleRecord = false}) =>
      queryCollection(FriendRequestRecord.collection, FriendRequestRecord.serializer,
          queryBuilder: queryBuilder, limit: limit, singleRecord: singleRecord);

  Future<List<ChatRecord?>> queryChatsRecordOnce(
          {required Query Function(Query) queryBuilder,
          int limit = -1,
          bool singleRecord = false}) =>
      queryCollectionOnce(ChatRecord.collection, ChatRecord.serializer,
          queryBuilder: queryBuilder, limit: limit, singleRecord: singleRecord);

  Stream<List<ChatRecord?>> queryChatsRecord(
          {required Query Function(Query) queryBuilder,
          int limit = -1,
          bool singleRecord = false}) =>
      queryCollection(ChatRecord.collection, ChatRecord.serializer,
          queryBuilder: queryBuilder, limit: limit, singleRecord: singleRecord);

  Stream<List<ChatMessagesRecord?>> queryChatMessagesRecord(
          {required Query Function(Query) queryBuilder,
          int limit = -1,
          bool singleRecord = false}) =>
      queryCollection(ChatMessagesRecord.collection, ChatMessagesRecord.serializer,
          queryBuilder: queryBuilder, limit: limit, singleRecord: singleRecord);

  Stream<List<T>> queryCollection<T>(CollectionReference collection, Serializer<T> serializer,
      {required Query Function(Query) queryBuilder, int limit = -1, bool singleRecord = false}) {
    final builder = queryBuilder;
    var query = builder(collection);
    if (limit > 0 || singleRecord) {
      query = query.limit(singleRecord ? 1 : limit);
    }
    return query.snapshots().map((s) => s.docs
        .map(
          (d) => safeGet(
            () => serializers.deserializeWith(serializer, serializedData(d)),
            (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
          ),
        )
        .where((d) => d != null)
        .toList() as List<T>);
  }

  Future<List<T?>> queryCollectionOnce<T>(CollectionReference collection, Serializer<T> serializer,
      {required Query Function(Query) queryBuilder, int limit = -1, bool singleRecord = false}) {
    final builder = queryBuilder;
    var query = builder(collection);
    if (limit > 0 || singleRecord) {
      query = query.limit(singleRecord ? 1 : limit);
    }
    return query.get().then((s) => s.docs
        .map(
          (d) => safeGet(
            () => serializers.deserializeWith(serializer, serializedData(d)),
            (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
          ),
        )
        .where((d) => d != null)
        .toList());
  }
}
