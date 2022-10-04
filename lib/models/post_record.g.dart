// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PostRecord> _$postRecordSerializer = new _$PostRecordSerializer();

class _$PostRecordSerializer implements StructuredSerializer<PostRecord> {
  @override
  final Iterable<Type> types = const [PostRecord, _$PostRecord];
  @override
  final String wireName = 'PostRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, PostRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'typeOfPost',
      serializers.serialize(object.typeOfPost,
          specifiedType: const FullType(String)),
      'Document__Reference__Field',
      serializers.serialize(object.reference,
          specifiedType: const FullType(
              DocumentReference, const [const FullType.nullable(Object)])),
    ];
    Object? value;
    value = object.song;
    if (value != null) {
      result
        ..add('song')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.event;
    if (value != null) {
      result
        ..add('event')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.comment;
    if (value != null) {
      result
        ..add('comment')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.user;
    if (value != null) {
      result
        ..add('user')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    value = object.fecha;
    if (value != null) {
      result
        ..add('created_time')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.likes;
    if (value != null) {
      result
        ..add('likes')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(
                  DocumentReference, const [const FullType.nullable(Object)])
            ])));
    }
    return result;
  }

  @override
  PostRecord deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PostRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'song':
          result.song = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'event':
          result.event = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'comment':
          result.comment = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'user':
          result.user = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
        case 'created_time':
          result.fecha = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'typeOfPost':
          result.typeOfPost = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'likes':
          result.likes.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(
                    DocumentReference, const [const FullType.nullable(Object)])
              ]))! as BuiltList<Object?>);
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

class _$PostRecord extends PostRecord {
  @override
  final String? song;
  @override
  final String? event;
  @override
  final String? comment;
  @override
  final DocumentReference<Object?>? user;
  @override
  final DateTime? fecha;
  @override
  final String typeOfPost;
  @override
  final BuiltList<DocumentReference<Object?>>? likes;
  @override
  final DocumentReference<Object?> reference;

  factory _$PostRecord([void Function(PostRecordBuilder)? updates]) =>
      (new PostRecordBuilder()..update(updates)).build();

  _$PostRecord._(
      {this.song,
      this.event,
      this.comment,
      this.user,
      this.fecha,
      required this.typeOfPost,
      this.likes,
      required this.reference})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        typeOfPost, 'PostRecord', 'typeOfPost');
    BuiltValueNullFieldError.checkNotNull(reference, 'PostRecord', 'reference');
  }

  @override
  PostRecord rebuild(void Function(PostRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PostRecordBuilder toBuilder() => new PostRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PostRecord &&
        song == other.song &&
        event == other.event &&
        comment == other.comment &&
        user == other.user &&
        fecha == other.fecha &&
        typeOfPost == other.typeOfPost &&
        likes == other.likes &&
        reference == other.reference;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, song.hashCode), event.hashCode),
                            comment.hashCode),
                        user.hashCode),
                    fecha.hashCode),
                typeOfPost.hashCode),
            likes.hashCode),
        reference.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PostRecord')
          ..add('song', song)
          ..add('event', event)
          ..add('comment', comment)
          ..add('user', user)
          ..add('fecha', fecha)
          ..add('typeOfPost', typeOfPost)
          ..add('likes', likes)
          ..add('reference', reference))
        .toString();
  }
}

class PostRecordBuilder implements Builder<PostRecord, PostRecordBuilder> {
  _$PostRecord? _$v;

  String? _song;
  String? get song => _$this._song;
  set song(String? song) => _$this._song = song;

  String? _event;
  String? get event => _$this._event;
  set event(String? event) => _$this._event = event;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  DocumentReference<Object?>? _user;
  DocumentReference<Object?>? get user => _$this._user;
  set user(DocumentReference<Object?>? user) => _$this._user = user;

  DateTime? _fecha;
  DateTime? get fecha => _$this._fecha;
  set fecha(DateTime? fecha) => _$this._fecha = fecha;

  String? _typeOfPost;
  String? get typeOfPost => _$this._typeOfPost;
  set typeOfPost(String? typeOfPost) => _$this._typeOfPost = typeOfPost;

  ListBuilder<DocumentReference<Object?>>? _likes;
  ListBuilder<DocumentReference<Object?>> get likes =>
      _$this._likes ??= new ListBuilder<DocumentReference<Object?>>();
  set likes(ListBuilder<DocumentReference<Object?>>? likes) =>
      _$this._likes = likes;

  DocumentReference<Object?>? _reference;
  DocumentReference<Object?>? get reference => _$this._reference;
  set reference(DocumentReference<Object?>? reference) =>
      _$this._reference = reference;

  PostRecordBuilder() {
    PostRecord._initializeBuilder(this);
  }

  PostRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _song = $v.song;
      _event = $v.event;
      _comment = $v.comment;
      _user = $v.user;
      _fecha = $v.fecha;
      _typeOfPost = $v.typeOfPost;
      _likes = $v.likes?.toBuilder();
      _reference = $v.reference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PostRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PostRecord;
  }

  @override
  void update(void Function(PostRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PostRecord build() {
    _$PostRecord _$result;
    try {
      _$result = _$v ??
          new _$PostRecord._(
              song: song,
              event: event,
              comment: comment,
              user: user,
              fecha: fecha,
              typeOfPost: BuiltValueNullFieldError.checkNotNull(
                  typeOfPost, 'PostRecord', 'typeOfPost'),
              likes: _likes?.build(),
              reference: BuiltValueNullFieldError.checkNotNull(
                  reference, 'PostRecord', 'reference'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'likes';
        _likes?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'PostRecord', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
