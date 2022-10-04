import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/Playlist.dart';
import 'models/user.dart';
import 'models/user_record.dart';

User? currentUser;
UserRecord? currentUserDocument;
DocumentReference? currentUserReference;

String get currentUserName => currentUser?.name ?? currentUser?.name ?? '';

List<Playlist>? playlists;
