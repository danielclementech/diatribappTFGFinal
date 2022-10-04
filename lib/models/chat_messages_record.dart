import 'dart:async';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/index.dart';
import '../services/serializers.dart';

part 'chat_messages_record.g.dart';

abstract class ChatMessagesRecord implements Built<ChatMessagesRecord, ChatMessagesRecordBuilder> {
  static Serializer<ChatMessagesRecord> get serializer => _$chatMessagesRecordSerializer;

  DocumentReference get from;

  DocumentReference get to;

  DocumentReference get chat;

  String get song;

  String? get comment;

  DateTime get time;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(ChatMessagesRecordBuilder builder) => builder;

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('chat_messages');

  static Stream<ChatMessagesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<ChatMessagesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  ChatMessagesRecord._();
  factory ChatMessagesRecord([void Function(ChatMessagesRecordBuilder) updates]) =
      _$ChatMessagesRecord;

  static ChatMessagesRecord? getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(
          serializer, {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createChatMessagesRecordData(
        {required DocumentReference from,
        required DocumentReference to,
        required DocumentReference chat,
        required String song,
          String? comment,
        required DateTime time}) =>
    serializers.toFirestore(
        ChatMessagesRecord.serializer,
        ChatMessagesRecord(
          (c) => c
            ..from = from
            ..to = to
            ..song = song
            ..chat = chat
            ..time = time
            ..comment = comment,
        ));
