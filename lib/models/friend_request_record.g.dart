// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FriendRequestRecord> _$friendRequestRecordSerializer =
    new _$FriendRequestRecordSerializer();

class _$FriendRequestRecordSerializer
    implements StructuredSerializer<FriendRequestRecord> {
  @override
  final Iterable<Type> types = const [
    FriendRequestRecord,
    _$FriendRequestRecord
  ];
  @override
  final String wireName = 'FriendRequestRecord';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, FriendRequestRecord object,
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
  FriendRequestRecord deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FriendRequestRecordBuilder();

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

class _$FriendRequestRecord extends FriendRequestRecord {
  @override
  final DocumentReference<Object?> from;
  @override
  final DocumentReference<Object?> to;
  @override
  final DateTime time;
  @override
  final DocumentReference<Object?> reference;

  factory _$FriendRequestRecord(
          [void Function(FriendRequestRecordBuilder)? updates]) =>
      (new FriendRequestRecordBuilder()..update(updates)).build();

  _$FriendRequestRecord._(
      {required this.from,
      required this.to,
      required this.time,
      required this.reference})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(from, 'FriendRequestRecord', 'from');
    BuiltValueNullFieldError.checkNotNull(to, 'FriendRequestRecord', 'to');
    BuiltValueNullFieldError.checkNotNull(time, 'FriendRequestRecord', 'time');
    BuiltValueNullFieldError.checkNotNull(
        reference, 'FriendRequestRecord', 'reference');
  }

  @override
  FriendRequestRecord rebuild(
          void Function(FriendRequestRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FriendRequestRecordBuilder toBuilder() =>
      new FriendRequestRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FriendRequestRecord &&
        from == other.from &&
        to == other.to &&
        time == other.time &&
        reference == other.reference;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc($jc(0, from.hashCode), to.hashCode), time.hashCode),
        reference.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FriendRequestRecord')
          ..add('from', from)
          ..add('to', to)
          ..add('time', time)
          ..add('reference', reference))
        .toString();
  }
}

class FriendRequestRecordBuilder
    implements Builder<FriendRequestRecord, FriendRequestRecordBuilder> {
  _$FriendRequestRecord? _$v;

  DocumentReference<Object?>? _from;
  DocumentReference<Object?>? get from => _$this._from;
  set from(DocumentReference<Object?>? from) => _$this._from = from;

  DocumentReference<Object?>? _to;
  DocumentReference<Object?>? get to => _$this._to;
  set to(DocumentReference<Object?>? to) => _$this._to = to;

  DateTime? _time;
  DateTime? get time => _$this._time;
  set time(DateTime? time) => _$this._time = time;

  DocumentReference<Object?>? _reference;
  DocumentReference<Object?>? get reference => _$this._reference;
  set reference(DocumentReference<Object?>? reference) =>
      _$this._reference = reference;

  FriendRequestRecordBuilder() {
    FriendRequestRecord._initializeBuilder(this);
  }

  FriendRequestRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _time = $v.time;
      _reference = $v.reference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FriendRequestRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FriendRequestRecord;
  }

  @override
  void update(void Function(FriendRequestRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FriendRequestRecord build() {
    final _$result = _$v ??
        new _$FriendRequestRecord._(
            from: BuiltValueNullFieldError.checkNotNull(
                from, 'FriendRequestRecord', 'from'),
            to: BuiltValueNullFieldError.checkNotNull(
                to, 'FriendRequestRecord', 'to'),
            time: BuiltValueNullFieldError.checkNotNull(
                time, 'FriendRequestRecord', 'time'),
            reference: BuiltValueNullFieldError.checkNotNull(
                reference, 'FriendRequestRecord', 'reference'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
