import 'dart:async';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diatribapp/models/show_struct.dart';

import '../services/index.dart';
import '../services/serializers.dart';

part 'user_record.g.dart';

abstract class UserRecord implements Built<UserRecord, UserRecordBuilder> {
  static Serializer<UserRecord> get serializer => _$userRecordSerializer;

  @BuiltValueField(wireName: 'name')
  String? get name;

  String? get avatarUrl;

  String? get instagramUrl;

  BuiltList<String>? get topArtists;

  BuiltList<String>? get topSongs;

  BuiltList<DocumentReference>? get friends;

  BuiltList<String>? get showsWishlist;

  BuiltList<ShowStruct>? get showsList;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(UserRecordBuilder builder) => builder
    ..name = ''
    ..instagramUrl = ''
    ..topArtists = ListBuilder()
    ..topSongs = ListBuilder()
    ..friends = ListBuilder()
    ..showsWishlist = ListBuilder()
    ..showsList = ListBuilder();

  static CollectionReference get collection => FirebaseFirestore.instance.collection('users');

  static Stream<UserRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<UserRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  UserRecord._();
  factory UserRecord([void Function(UserRecordBuilder) updates]) = _$UserRecord;

  static UserRecord? getDocumentFromData(Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(
          serializer, {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createUserRecordData({
  String? name,
  String? avatarUrl,
  String? instagramUrl,
}) =>
    serializers.toFirestore(
        UserRecord.serializer,
        UserRecord((c) => c
          ..name = name
          ..avatarUrl = avatarUrl
          ..instagramUrl = instagramUrl
          ..topArtists = null
          ..topSongs = null
          ..friends = null
          ..showsWishlist = null
          ..showsList = null));
