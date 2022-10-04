// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_messages_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ChatMessagesRecord> _$chatMessagesRecordSerializer =
    new _$ChatMessagesRecordSerializer();

class _$ChatMessagesRecordSerializer
    implements StructuredSerializer<ChatMessagesRecord> {
  @override
  final Iterable<Type> types = const [ChatMessagesRecord, _$ChatMessagesRecord];
  @override
  final String wireName = 'ChatMessagesRecord';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ChatMessagesRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'from',
      serializers.serialize(object.from,
          specifiedType: const FullType(
              DocumentReference, const [const FullType.nullable(Object)])),
      'to',
      serializers.serialize(object.to,
          specifiedType: const FullType(
              DocumentReference, const [const FullType.nullable(Object)])),
      'chat',
      serializers.serialize(object.chat,
          specifiedType: const FullType(
              DocumentReference, const [const FullType.nullable(Object)])),
      'song',
      serializers.serialize(object.song, specifiedType: const FullType(String)),
      'comment',
      serializers.serialize(object.comment,
          specifiedType: const FullType(String)),
      'time',
      serializers.serialize(object.time,
          specifiedType: const FullType(DateTime)),
      'Document__Reference__Field',
      serializers.serialize(object.reference,
          specifiedType: const FullType(
              DocumentReference, const [const FullType.nullable(Object)])),
    ];

    return result;
  }

  @override
  ChatMessagesRecord deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChatMessagesRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'from':
          result.from = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>;
          break;
        case 'to':
          result.to = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>;
          break;
        case 'chat':
          result.chat = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>;
          break;
        case 'song':
          result.song = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'comment':
          result.comment = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'time':
          result.time = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'Document__Reference__Field':
          result.reference = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>;
          break;
      }
    }

    return result.build();
  }
}

class _$ChatMessagesRecord extends ChatMessagesRecord {
  @override
  final DocumentReference<Object?> from;
  @override
  final DocumentReference<Object?> to;
  @override
  final DocumentReference<Object?> chat;
  @override
  final String song;
  @override
  final String comment;
  @override
  final DateTime time;
  @override
  final DocumentReference<Object?> reference;

  factory _$ChatMessagesRecord(
          [void Function(ChatMessagesRecordBuilder)? updates]) =>
      (new ChatMessagesRecordBuilder()..update(updates)).build();

  _$ChatMessagesRecord._(
      {required this.from,
      required this.to,
      required this.chat,
      required this.song,
      required this.comment,
      required this.time,
      required this.reference})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(from, 'ChatMessagesRecord', 'from');
    BuiltValueNullFieldError.checkNotNull(to, 'ChatMessagesRecord', 'to');
    BuiltValueNullFieldError.checkNotNull(chat, 'ChatMessagesRecord', 'chat');
    BuiltValueNullFieldError.checkNotNull(song, 'ChatMessagesRecord', 'song');
    BuiltValueNullFieldError.checkNotNull(
        comment, 'ChatMessagesRecord', 'comment');
    BuiltValueNullFieldError.checkNotNull(time, 'ChatMessagesRecord', 'time');
    BuiltValueNullFieldError.checkNotNull(
        reference, 'ChatMessagesRecord', 'reference');
  }

  @override
  ChatMessagesRecord rebuild(
          void Function(ChatMessagesRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatMessagesRecordBuilder toBuilder() =>
      new ChatMessagesRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatMessagesRecord &&
        from == other.from &&
        to == other.to &&
        chat == other.chat &&
        song == other.song &&
        comment == other.comment &&
        time == other.time &&
        reference == other.reference;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc($jc(0, from.hashCode), to.hashCode), chat.hashCode),
                    song.hashCode),
                comment.hashCode),
            time.hashCode),
        reference.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ChatMessagesRecord')
          ..add('from', from)
          ..add('to', to)
          ..add('chat', chat)
          ..add('song', song)
          ..add('comment', comment)
          ..add('time', time)
          ..add('reference', reference))
        .toString();
  }
}

class ChatMessagesRecordBuilder
    implements Builder<ChatMessagesRecord, ChatMessagesRecordBuilder> {
  _$ChatMessagesRecord? _$v;

  DocumentReference<Object?>? _from;
  DocumentReference<Object?>? get from => _$this._from;
  set from(DocumentReference<Object?>? from) => _$this._from = from;

  DocumentReference<Object?>? _to;
  DocumentReference<Object?>? get to => _$this._to;
  set to(DocumentReference<Object?>? to) => _$this._to = to;

  DocumentReference<Object?>? _chat;
  DocumentReference<Object?>? get chat => _$this._chat;
  set chat(DocumentReference<Object?>? chat) => _$this._chat = chat;

  String? _song;
  String? get song => _$this._song;
  set song(String? song) => _$this._song = song;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  DateTime? _time;
  DateTime? get time => _$this._time;
  set time(DateTime? time) => _$this._time = time;

  DocumentReference<Object?>? _reference;
  DocumentReference<Object?>? get reference => _$this._reference;
  set reference(DocumentReference<Object?>? reference) =>
      _$this._reference = reference;

  ChatMessagesRecordBuilder() {
    ChatMessagesRecord._initializeBuilder(this);
  }

  ChatMessagesRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _chat = $v.chat;
      _song = $v.song;
      _comment = $v.comment;
      _time = $v.time;
      _reference = $v.reference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatMessagesRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatMessagesRecord;
  }

  @override
  void update(void Function(ChatMessagesRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ChatMessagesRecord build() {
    final _$result = _$v ??
        new _$ChatMessagesRecord._(
            from: BuiltValueNullFieldError.checkNotNull(
                from, 'ChatMessagesRecord', 'from'),
            to: BuiltValueNullFieldError.checkNotNull(
                to, 'ChatMessagesRecord', 'to'),
            chat: BuiltValueNullFieldError.checkNotNull(
                chat, 'ChatMessagesRecord', 'chat'),
            song: BuiltValueNullFieldError.checkNotNull(
                song, 'ChatMessagesRecord', 'song'),
            comment: BuiltValueNullFieldError.checkNotNull(
                comment, 'ChatMessagesRecord', 'comment'),
            time: BuiltValueNullFieldError.checkNotNull(
                time, 'ChatMessagesRecord', 'time'),
            reference: BuiltValueNullFieldError.checkNotNull(
                reference, 'ChatMessagesRecord', 'reference'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
