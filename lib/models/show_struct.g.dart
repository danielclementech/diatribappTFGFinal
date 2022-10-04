// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_struct.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ShowStruct> _$showStructSerializer = new _$ShowStructSerializer();

class _$ShowStructSerializer implements StructuredSerializer<ShowStruct> {
  @override
  final Iterable<Type> types = const [ShowStruct, _$ShowStruct];
  @override
  final String wireName = 'ShowStruct';

  @override
  Iterable<Object?> serialize(Serializers serializers, ShowStruct object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'firestoreUtilData',
      serializers.serialize(object.firestoreUtilData,
          specifiedType: const FullType(FirestoreUtilData)),
    ];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.ticket;
    if (value != null) {
      result
        ..add('ticket')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  ShowStruct deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ShowStructBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'ticket':
          result.ticket = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'firestoreUtilData':
          result.firestoreUtilData = serializers.deserialize(value,
                  specifiedType: const FullType(FirestoreUtilData))
              as FirestoreUtilData;
          break;
      }
    }

    return result.build();
  }
}

class _$ShowStruct extends ShowStruct {
  @override
  final String? id;
  @override
  final String? ticket;
  @override
  final FirestoreUtilData firestoreUtilData;

  factory _$ShowStruct([void Function(ShowStructBuilder)? updates]) =>
      (new ShowStructBuilder()..update(updates)).build();

  _$ShowStruct._({this.id, this.ticket, required this.firestoreUtilData})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        firestoreUtilData, 'ShowStruct', 'firestoreUtilData');
  }

  @override
  ShowStruct rebuild(void Function(ShowStructBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ShowStructBuilder toBuilder() => new ShowStructBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ShowStruct &&
        id == other.id &&
        ticket == other.ticket &&
        firestoreUtilData == other.firestoreUtilData;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc(0, id.hashCode), ticket.hashCode), firestoreUtilData.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ShowStruct')
          ..add('id', id)
          ..add('ticket', ticket)
          ..add('firestoreUtilData', firestoreUtilData))
        .toString();
  }
}

class ShowStructBuilder implements Builder<ShowStruct, ShowStructBuilder> {
  _$ShowStruct? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _ticket;
  String? get ticket => _$this._ticket;
  set ticket(String? ticket) => _$this._ticket = ticket;

  FirestoreUtilData? _firestoreUtilData;
  FirestoreUtilData? get firestoreUtilData => _$this._firestoreUtilData;
  set firestoreUtilData(FirestoreUtilData? firestoreUtilData) =>
      _$this._firestoreUtilData = firestoreUtilData;

  ShowStructBuilder() {
    ShowStruct._initializeBuilder(this);
  }

  ShowStructBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _ticket = $v.ticket;
      _firestoreUtilData = $v.firestoreUtilData;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ShowStruct other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ShowStruct;
  }

  @override
  void update(void Function(ShowStructBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ShowStruct build() {
    final _$result = _$v ??
        new _$ShowStruct._(
            id: id,
            ticket: ticket,
            firestoreUtilData: BuiltValueNullFieldError.checkNotNull(
                firestoreUtilData, 'ShowStruct', 'firestoreUtilData'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
