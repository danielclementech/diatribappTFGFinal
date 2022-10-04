import 'dart:async';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/index.dart';
import '../services/serializers.dart';

part 'chat_record.g.dart';

abstract class ChatRecord implements Built<ChatRecord, ChatRecordBuilder> {
  static Serializer<ChatRecord> get serializer => _$chatRecordSerializer;

  DocumentReference get user_a;

  DocumentReference get user_b;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(ChatRecordBuilder builder) => builder;

  static CollectionReference get collection => FirebaseFirestore.instance.collection('chats');

  static Stream<ChatRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<ChatRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  ChatRecord._();
  factory ChatRecord([void Function(ChatRecordBuilder) updates]) = _$ChatRecord;

  static ChatRecord? getDocumentFromData(Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(
          serializer, {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createChatRecordData({
  required DocumentReference user_a,
  required DocumentReference user_b,
}) =>
    serializers.toFirestore(
        ChatRecord.serializer,
        ChatRecord((c) => c
          ..user_a = user_a
          ..user_b = user_b));
