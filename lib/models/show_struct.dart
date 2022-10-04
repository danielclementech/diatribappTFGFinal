import 'package:built_value/built_value.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/index.dart';
import '../services/serializers.dart';

part 'show_struct.g.dart';

abstract class ShowStruct implements Built<ShowStruct, ShowStructBuilder> {
  static Serializer<ShowStruct> get serializer => _$showStructSerializer;

  String? get id;

  String? get ticket;

  /// Utility class for Firestore updates
  FirestoreUtilData get firestoreUtilData;

  static void _initializeBuilder(ShowStructBuilder builder) => builder
    ..id = ''
    ..ticket = ''
    ..firestoreUtilData = FirestoreUtilData();

  ShowStruct._();
  factory ShowStruct([void Function(ShowStructBuilder) updates]) = _$ShowStruct;
}

ShowStruct createShowStruct({
  String? id,
  String? ticket,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ShowStruct(
      (s) => s
        ..id = id
        ..ticket = ticket
        ..firestoreUtilData = FirestoreUtilData(
          clearUnsetFields: clearUnsetFields,
          create: create,
          delete: delete,
          fieldValues: fieldValues,
        ),
    );

ShowStruct? updateShowStruct(
  ShowStruct? show, {
  bool clearUnsetFields = true,
}) =>
    show != null
        ? (show.toBuilder()
              ..firestoreUtilData = FirestoreUtilData(clearUnsetFields: clearUnsetFields))
            .build()
        : null;

void addShowStructData(
  Map<String, dynamic> firestoreData,
  ShowStruct? show,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (show == null) {
    return;
  }
  if (show.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  if (!forFieldValue && show.firestoreUtilData.clearUnsetFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final showData = getShowFirestoreData(show, forFieldValue);
  final nestedData = showData.map((k, v) => MapEntry('$fieldName.$k', v));

  final create = show.firestoreUtilData.create;
  firestoreData.addAll(create ? mergeNestedFields(nestedData) : nestedData);

  return;
}

Map<String, dynamic> getShowFirestoreData(
  ShowStruct? show, [
  bool forFieldValue = false,
]) {
  if (show == null) {
    return {};
  }
  final firestoreData = serializers.toFirestore(ShowStruct.serializer, show);

  // Add any Firestore field values
  show.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getShowListFirestoreData(
  List<ShowStruct>? shows,
) =>
    shows?.map((s) => getShowFirestoreData(s, true)).toList() ?? [];
