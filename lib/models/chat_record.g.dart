// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ChatRecord> _$chatRecordSerializer = new _$ChatRecordSerializer();

class _$ChatRecordSerializer implements StructuredSerializer<ChatRecord> {
  @override
  final Iterable<Type> types = const [ChatRecord, _$ChatRecord];
  @override
  final String wireName = 'ChatRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, ChatRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'user_a',
      serializers.serialize(object.user_a,
          specifiedType: const FullType(
              DocumentReference, const [const FullType.nullable(Object)])),
      'user_b',
      serializers.serialize(object.user_b,
          specifiedType: const FullType(
              DocumentReference, const [const FullType.nullable(Object)])),
      'Document__Reference__Field',
      serializers.serialize(object.reference,
          specifiedType: const FullType(
              DocumentReference, const [const FullType.nullable(Object)])),
    ];

    return result;
  }

  @override
  ChatRecord deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChatRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'user_a':
          result.user_a = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>;
          break;
        case 'user_b':
          result.user_b = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>;
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

class _$ChatRecord extends ChatRecord {
  @override
  final DocumentReference<Object?> user_a;
  @override
  final DocumentReference<Object?> user_b;
  @override
  final DocumentReference<Object?> reference;

  factory _$ChatRecord([void Function(ChatRecordBuilder)? updates]) =>
      (new ChatRecordBuilder()..update(updates)).build();

  _$ChatRecord._(
      {required this.user_a, required this.user_b, required this.reference})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(user_a, 'ChatRecord', 'user_a');
    BuiltValueNullFieldError.checkNotNull(user_b, 'ChatRecord', 'user_b');
    BuiltValueNullFieldError.checkNotNull(reference, 'ChatRecord', 'reference');
  }

  @override
  ChatRecord rebuild(void Function(ChatRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatRecordBuilder toBuilder() => new ChatRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatRecord &&
        user_a == other.user_a &&
        user_b == other.user_b &&
        reference == other.reference;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, user_a.hashCode), user_b.hashCode), reference.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ChatRecord')
          ..add('user_a', user_a)
          ..add('user_b', user_b)
          ..add('reference', reference))
        .toString();
  }
}

class ChatRecordBuilder implements Builder<ChatRecord, ChatRecordBuilder> {
  _$ChatRecord? _$v;

  DocumentReference<Object?>? _user_a;
  DocumentReference<Object?>? get user_a => _$this._user_a;
  set user_a(DocumentReference<Object?>? user_a) => _$this._user_a = user_a;

  DocumentReference<Object?>? _user_b;
  DocumentReference<Object?>? get user_b => _$this._user_b;
  set user_b(DocumentReference<Object?>? user_b) => _$this._user_b = user_b;

  DocumentReference<Object?>? _reference;
  DocumentReference<Object?>? get reference => _$this._reference;
  set reference(DocumentReference<Object?>? reference) =>
      _$this._reference = reference;

  ChatRecordBuilder() {
    ChatRecord._initializeBuilder(this);
  }

  ChatRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _user_a = $v.user_a;
      _user_b = $v.user_b;
      _reference = $v.reference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ChatRecord;
  }

  @override
  void update(void Function(ChatRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ChatRecord build() {
    final _$result = _$v ??
        new _$ChatRecord._(
            user_a: BuiltValueNullFieldError.checkNotNull(
                user_a, 'ChatRecord', 'user_a'),
            user_b: BuiltValueNullFieldError.checkNotNull(
                user_b, 'ChatRecord', 'user_b'),
            reference: BuiltValueNullFieldError.checkNotNull(
                reference, 'ChatRecord', 'reference'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
