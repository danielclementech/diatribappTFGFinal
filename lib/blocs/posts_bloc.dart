import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diatribapp/repositories/posts_repository.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '../models/post_record.dart';
import '../util.dart';

class PostsBloc implements Bloc {
  final _posts_repository = PostsRepository();

  void newEventPost(String event, bool wishlist) => _posts_repository.newEventPost(event, wishlist);


  Stream<List<PostRecord?>> queryPostsRecord(
          {required Query Function(Query) queryBuilder,
          int limit = -1,
          bool singleRecord = false}) =>
      _posts_repository.queryPostsRecord(queryBuilder: queryBuilder);

  Future<List<PostRecord>> onlyFriendsPosts(List<PostRecord?> list) async {
    List<PostRecord> result = [];
    List<DocumentReference>? friends = currentUserDocument!.friends?.toList();
    if (friends != null) {
      for (var post in list) {
        if (friends.contains(post?.user)) {
          result.add(post!);
        } else if (post?.user == currentUserReference) {
          result.add(post!);
        }
      }
    }
    return result;
  }

  @override
  void dispose() {}
}
