import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diatribapp/models/post_record.dart';
import 'package:diatribapp/services/firebase_services.dart';

import '../models/user_record.dart';

class PostsRepository {
  final _firebaseServices = FirebaseServices();

  Future<UserRecord?>? getUser() => _firebaseServices.getUser();

  Future<List<PostRecord?>> queryPostsRecordOnce(
          {required Query Function(Query) queryBuilder,
          int limit = -1,
          bool singleRecord = false}) =>
      _firebaseServices.queryPostsRecordOnce(queryBuilder: queryBuilder);

  Stream<List<PostRecord?>> queryPostsRecord(
          {required Query Function(Query) queryBuilder,
          int limit = -1,
          bool singleRecord = false}) =>
      _firebaseServices.queryPostsRecord(queryBuilder: queryBuilder);

  void newEventPost(String event, bool wishlist) => _firebaseServices.newEventPost(event, wishlist);
  void newSongPost(String song, String comment) => _firebaseServices.newSongPost(song, comment);

  void likeASongPost(DocumentReference post) => _firebaseServices.likeASongPost(post);
  void unlikeASongPost(DocumentReference post) => _firebaseServices.unlikeASongPost(post);
}
