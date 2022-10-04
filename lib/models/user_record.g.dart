// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UserRecord> _$userRecordSerializer = new _$UserRecordSerializer();

class _$UserRecordSerializer implements StructuredSerializer<UserRecord> {
  @override
  final Iterable<Type> types = const [UserRecord, _$UserRecord];
  @override
  final String wireName = 'UserRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'Document__Reference__Field',
      serializers.serialize(object.reference,
          specifiedType: const FullType(
              DocumentReference, const [const FullType.nullable(Object)])),
    ];
    Object? value;
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.avatarUrl;
    if (value != null) {
      result
        ..add('avatarUrl')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.instagramUrl;
    if (value != null) {
      result
        ..add('instagramUrl')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.topArtists;
    if (value != null) {
      result
        ..add('topArtists')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.topSongs;
    if (value != null) {
      result
        ..add('topSongs')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.friends;
    if (value != null) {
      result
        ..add('friends')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(
                  DocumentReference, const [const FullType.nullable(Object)])
            ])));
    }
    value = object.showsWishlist;
    if (value != null) {
      result
        ..add('showsWishlist')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.showsList;
    if (value != null) {
      result
        ..add('showsList')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(ShowStruct)])));
    }
    return result;
  }

  @override
  UserRecord deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'avatarUrl':
          result.avatarUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'instagramUrl':
          result.instagramUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'topArtists':
          result.topArtists.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'topSongs':
          result.topSongs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'friends':
          result.friends.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(
                    DocumentReference, const [const FullType.nullable(Object)])
              ]))! as BuiltList<Object?>);
          break;
        case 'showsWishlist':
          result.showsWishlist.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'showsList':
          result.showsList.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(ShowStruct)]))!
              as BuiltList<Object?>);
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

class _$UserRecord extends UserRecord {
  @override
  final String? name;
  @override
  final String? avatarUrl;
  @override
  final String? instagramUrl;
  @override
  final BuiltList<String>? topArtists;
  @override
  final BuiltList<String>? topSongs;
  @override
  final BuiltList<DocumentReference<Object?>>? friends;
  @override
  final BuiltList<String>? showsWishlist;
  @override
  final BuiltList<ShowStruct>? showsList;
  @override
  final DocumentReference<Object?> reference;

  factory _$UserRecord([void Function(UserRecordBuilder)? updates]) =>
      (new UserRecordBuilder()..update(updates)).build();

  _$UserRecord._(
      {this.name,
      this.avatarUrl,
      this.instagramUrl,
      this.topArtists,
      this.topSongs,
      this.friends,
      this.showsWishlist,
      this.showsList,
      required this.reference})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(reference, 'UserRecord', 'reference');
  }

  @override
  UserRecord rebuild(void Function(UserRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserRecordBuilder toBuilder() => new UserRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserRecord &&
        name == other.name &&
        avatarUrl == other.avatarUrl &&
        instagramUrl == other.instagramUrl &&
        topArtists == other.topArtists &&
        topSongs == other.topSongs &&
        friends == other.friends &&
        showsWishlist == other.showsWishlist &&
        showsList == other.showsList &&
        reference == other.reference;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc($jc($jc(0, name.hashCode), avatarUrl.hashCode),
                                instagramUrl.hashCode),
                            topArtists.hashCode),
                        topSongs.hashCode),
                    friends.hashCode),
                showsWishlist.hashCode),
            showsList.hashCode),
        reference.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('UserRecord')
          ..add('name', name)
          ..add('avatarUrl', avatarUrl)
          ..add('instagramUrl', instagramUrl)
          ..add('topArtists', topArtists)
          ..add('topSongs', topSongs)
          ..add('friends', friends)
          ..add('showsWishlist', showsWishlist)
          ..add('showsList', showsList)
          ..add('reference', reference))
        .toString();
  }
}

class UserRecordBuilder implements Builder<UserRecord, UserRecordBuilder> {
  _$UserRecord? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _avatarUrl;
  String? get avatarUrl => _$this._avatarUrl;
  set avatarUrl(String? avatarUrl) => _$this._avatarUrl = avatarUrl;

  String? _instagramUrl;
  String? get instagramUrl => _$this._instagramUrl;
  set instagramUrl(String? instagramUrl) => _$this._instagramUrl = instagramUrl;

  ListBuilder<String>? _topArtists;
  ListBuilder<String> get topArtists =>
      _$this._topArtists ??= new ListBuilder<String>();
  set topArtists(ListBuilder<String>? topArtists) =>
      _$this._topArtists = topArtists;

  ListBuilder<String>? _topSongs;
  ListBuilder<String> get topSongs =>
      _$this._topSongs ??= new ListBuilder<String>();
  set topSongs(ListBuilder<String>? topSongs) => _$this._topSongs = topSongs;

  ListBuilder<DocumentReference<Object?>>? _friends;
  ListBuilder<DocumentReference<Object?>> get friends =>
      _$this._friends ??= new ListBuilder<DocumentReference<Object?>>();
  set friends(ListBuilder<DocumentReference<Object?>>? friends) =>
      _$this._friends = friends;

  ListBuilder<String>? _showsWishlist;
  ListBuilder<String> get showsWishlist =>
      _$this._showsWishlist ??= new ListBuilder<String>();
  set showsWishlist(ListBuilder<String>? showsWishlist) =>
      _$this._showsWishlist = showsWishlist;

  ListBuilder<ShowStruct>? _showsList;
  ListBuilder<ShowStruct> get showsList =>
      _$this._showsList ??= new ListBuilder<ShowStruct>();
  set showsList(ListBuilder<ShowStruct>? showsList) =>
      _$this._showsList = showsList;

  DocumentReference<Object?>? _reference;
  DocumentReference<Object?>? get reference => _$this._reference;
  set reference(DocumentReference<Object?>? reference) =>
      _$this._reference = reference;

  UserRecordBuilder() {
    UserRecord._initializeBuilder(this);
  }

  UserRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _avatarUrl = $v.avatarUrl;
      _instagramUrl = $v.instagramUrl;
      _topArtists = $v.topArtists?.toBuilder();
      _topSongs = $v.topSongs?.toBuilder();
      _friends = $v.friends?.toBuilder();
      _showsWishlist = $v.showsWishlist?.toBuilder();
      _showsList = $v.showsList?.toBuilder();
      _reference = $v.reference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserRecord;
  }

  @override
  void update(void Function(UserRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$UserRecord build() {
    _$UserRecord _$result;
    try {
      _$result = _$v ??
          new _$UserRecord._(
              name: name,
              avatarUrl: avatarUrl,
              instagramUrl: instagramUrl,
              topArtists: _topArtists?.build(),
              topSongs: _topSongs?.build(),
              friends: _friends?.build(),
              showsWishlist: _showsWishlist?.build(),
              showsList: _showsList?.build(),
              reference: BuiltValueNullFieldError.checkNotNull(
                  reference, 'UserRecord', 'reference'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'topArtists';
        _topArtists?.build();
        _$failedField = 'topSongs';
        _topSongs?.build();
        _$failedField = 'friends';
        _friends?.build();
        _$failedField = 'showsWishlist';
        _showsWishlist?.build();
        _$failedField = 'showsList';
        _showsList?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'UserRecord', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
