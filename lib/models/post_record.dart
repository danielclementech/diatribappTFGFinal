import 'dart:async';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/index.dart';
import '../services/serializers.dart';

part 'post_record.g.dart';

abstract class PostRecord implements Built<PostRecord, PostRecordBuilder> {
  static Serializer<PostRecord> get serializer => _$postRecordSerializer;

  @BuiltValueField(wireName: 'song')
  String? get song;

  @BuiltValueField(wireName: 'event')
  String? get event;

  @BuiltValueField(wireName: 'comment')
  String? get comment;

  @BuiltValueField(wireName: 'user')
  DocumentReference? get user;

  @BuiltValueField(wireName: 'created_time')
  DateTime? get fecha;

  @BuiltValueField(wireName: 'typeOfPost')
  String get typeOfPost;

  BuiltList<DocumentReference>? get likes;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(PostRecordBuilder builder) => builder
    ..song = ''
    ..event = ''
    ..comment = ''
    ..typeOfPost = ''
    ..likes = ListBuilder();

  static CollectionReference get collection => FirebaseFirestore.instance.collection('posts');

  static Stream<PostRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<PostRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  PostRecord._();
  factory PostRecord([void Function(PostRecordBuilder) updates]) = _$PostRecord;

  static PostRecord? getDocumentFromData(Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(
          serializer, {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createPostRecordData({
  String? song,
  required String typeOfPost,
  String? event,
  String? comment,
  DocumentReference? user,
  DateTime? fecha,
}) =>
    serializers.toFirestore(
        PostRecord.serializer,
        PostRecord((c) => c
          ..typeOfPost = typeOfPost
          ..song = song
          ..event = event
          ..comment = comment
          ..user = user
          ..fecha = fecha
          ..likes = null));
