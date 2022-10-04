import 'package:diatribapp/blocs/song_bloc.dart';
import 'package:diatribapp/blocs/user_bloc.dart';
import 'package:diatribapp/services/firebase_services.dart';
import 'package:diatribapp/song_post.dart';
import 'package:diatribapp/tema.dart';
import 'package:diatribapp/util.dart';
import 'package:diatribapp/widgets/event_post_widget.dart';
import 'package:diatribapp/widgets/song_post_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import 'blocs/posts_bloc.dart';
import 'models/post_record.dart';

class FeedWidget extends StatefulWidget {
  const FeedWidget({Key? key}) : super(key: key);

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late PostsBloc postsBloc;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    postsBloc = BlocProvider.of<PostsBloc>(context);
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF1F4F8),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Nuevo post'),
                  content: Container(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.pop(alertDialogContext);
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BlocProvider(child: PostSongWidget(), bloc: UserBloc()),
                                ),
                              );
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Tema.of(context).primaryColor,
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 0,
                                      color: Color(0xFFDBE2E7),
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsetsDirectional.all(10),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.music_note,
                                      color: Tema.of(context).turquesa,
                                    ),
                                    Text(
                                      'Compartir\ncanción',
                                      style: Tema.of(context).bodyText2,
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                )),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(start: 5),
                            child: InkWell(
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Tema.of(context).primaryColor,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 0,
                                        color: Color(0xFFDBE2E7),
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsetsDirectional.all(10),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.library_music_outlined,
                                        color: Tema.of(context).turquesa,
                                      ),
                                      Text(
                                        'Compartir\nálbum',
                                        style: Tema.of(context).bodyText2,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(start: 5),
                            child: InkWell(
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Tema.of(context).primaryColor,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 0,
                                        color: Color(0xFFDBE2E7),
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsetsDirectional.all(10),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.playlist_play_rounded,
                                        color: Tema.of(context).turquesa,
                                      ),
                                      Text(
                                        'Compartir\nplaylist',
                                        style: Tema.of(context).bodyText2,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(top: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {},
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Tema.of(context).primaryColor,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 0,
                                        color: Color(0xFFDBE2E7),
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 250,
                                  padding: EdgeInsetsDirectional.all(10),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Reto del día',
                                        style: Tema.of(context).bodyText2,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
                  actions: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(alertDialogContext);
                        },
                        child: Text('Cancelar'),
                      ),
                    ]),
                  ],
                );
              },
            );
          },
          backgroundColor: Tema.of(context).primaryColor,
          elevation: 8,
          label: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.post_add_outlined,
                color: Tema.of(context).white,
                size: 30,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                child: Text(
                  'Nuevo post',
                  style: Tema.of(context).subtitle1.override(
                        fontFamily: 'Nunito',
                        color: Tema.of(context).white,
                      ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Tema.of(context).primaryColor,
          automaticallyImplyLeading: false,
          title: Text(
            'Posts',
            style: Tema.of(context).title2.override(
                  fontFamily: 'Nunito',
                  color: Colors.white,
                  fontSize: 22,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<List<PostRecord?>>(
                stream: postsBloc.queryPostsRecord(
                    queryBuilder: (PostRecord) =>
                        PostRecord.orderBy('created_time', descending: true)),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          color: Tema.of(context).alternate,
                        ),
                      ),
                    );
                  }
                  List<PostRecord?> listViewSongpostsRecordList = snapshot.data!;
                  return FutureBuilder<List<PostRecord>?>(
                      future: postsBloc.onlyFriendsPosts(listViewSongpostsRecordList),
                      builder: (context, snapshot) {
                        final events = snapshot.data;
                        if (!snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                color: Tema.of(context).alternate,
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: events!.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, listViewIndex) {
                              final listViewSongPostsRecord = events[listViewIndex];
                              return listViewSongPostsRecord.typeOfPost == 'event' ||
                                      listViewSongPostsRecord.typeOfPost == 'wishlist_event'
                                  ? BlocProvider(
                                      bloc: SongBloc(),
                                      child: EventPostWidget(post: listViewSongPostsRecord))
                                  : Column(
                                      children: [
                                        BlocProvider(
                                            child: SongPostWidget(post: listViewSongPostsRecord,),
                                            bloc: SongBloc())
                                      ],
                                    );
                            },
                          );
                        }
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
  getCurrentUser() async {
    currentUserDocument = await FirebaseServices().getUser();
  }
  refresh() {
    setState(() {

    });
  }
}
