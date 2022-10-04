import 'dart:async';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/index.dart';
import '../services/serializers.dart';

part 'friend_request_record.g.dart';

abstract class FriendRequestRecord
    implements Built<FriendRequestRecord, FriendRequestRecordBuilder> {
  static Serializer<FriendRequestRecord> get serializer => _$friendRequestRecordSerializer;

  DocumentReference get from;

  DocumentReference get to;

  DateTime get time;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(FriendRequestRecordBuilder builder) => builder;

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('friend_requests');

  static Stream<FriendRequestRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<FriendRequestRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  FriendRequestRecord._();
  factory FriendRequestRecord([void Function(FriendRequestRecordBuilder) updates]) =
      _$FriendRequestRecord;

  static FriendRequestRecord? getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(
          serializer, {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createFriendRequestRecordData(
        {required DocumentReference from, required DocumentReference to, required DateTime time}) =>
    serializers.toFirestore(
        FriendRequestRecord.serializer,
        FriendRequestRecord((c) => c
          ..from = from
          ..to = to
          ..time = time));
