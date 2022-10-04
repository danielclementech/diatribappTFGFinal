import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diatribapp/repositories/spotify_repository.dart';
import 'package:diatribapp/repositories/user_repository.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '../models/Song.dart';
import '../models/chat_messages_record.dart';
import '../models/user.dart';

class ChatBloc implements Bloc {
  final _user_repository = UserRepository();
  final _spotify_repository = SpotifyRepository();

  Future<User> getUserById(String id) => _spotify_repository.getUserById(id);

  Stream<List<ChatMessagesRecord?>> getMessages(DocumentReference chat) =>
      _user_repository.queryChatMessagesRecord(
          queryBuilder: (queryBuilder) => queryBuilder
              .where('chat', isEqualTo: chat)
              .where('time', isNull: false)
              .orderBy('time', descending: true));

  void newChatMessage(
          DocumentReference from, DocumentReference to, DocumentReference chat, String song, String comment) =>
      _user_repository.newChatMessage(from, to, chat, song, comment);

  Future<Song> getSong(String songId) => _spotify_repository.getSong(songId);
  Future<List<Song>?> searchSong(String word, {int limit = 20, int offset = 0}) =>
      _spotify_repository.searchSong(word, limit: limit, offset: offset);

  Future<List<Song>> getTopSongsShort() async =>
      await _spotify_repository.getTopSongs('short_term');

  @override
  void dispose() {}
}
