import 'package:cached_network_image/cached_network_image.dart';
import 'package:diatribapp/blocs/artist_bloc.dart';
import 'package:diatribapp/blocs/profile_bloc.dart';
import 'package:diatribapp/friend_requests_page.dart';
import 'package:diatribapp/friends_page.dart';
import 'package:diatribapp/list_of_artists.dart';
import 'package:diatribapp/list_of_songs.dart';
import 'package:diatribapp/profile/edit_profile_page.dart';
import 'package:diatribapp/shows_list_page.dart';
import 'package:diatribapp/shows_wishlist_page.dart';
import 'package:diatribapp/tema.dart';
import 'package:diatribapp/util.dart';
import 'package:diatribapp/widgets/event_post_widget.dart';
import 'package:diatribapp/widgets/song_post_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/events_bloc.dart';
import '../blocs/song_bloc.dart';
import '../models/Artist.dart';
import '../models/Song.dart';
import '../models/post_record.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late ProfileBloc profileBloc;

  List<Song> songs = [];
  List<String> artists = [];

  @override
  void initState() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      getArtistsAndSongs();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    profileBloc = BlocProvider.of<ProfileBloc>(context);
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF1F4F8),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 170,
              decoration: BoxDecoration(
                color: Tema.of(context).primaryColor,
                border: Border(
                  bottom: BorderSide(width: 2.0, color: Tema.of(context).secondaryColor),
                ),
              ),
              child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 40, 0, 0),
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 160,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfileWidget(bloc: profileBloc),
                                    ),
                                  );
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Tema.of(context).white,
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                                    ),
                                    padding: EdgeInsetsDirectional.fromSTEB(10, 7, 10, 7),
                                    child: Row(children: [
                                      Icon(
                                        Icons.edit_rounded,
                                        color: Tema.of(context).secondaryColor,
                                      ),
                                      Text(
                                        'Editar perfil',
                                        style: Tema.of(context).subtitle2,
                                      ),
                                    ])))
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Tema.of(context).secondaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                                child: InkWell(
                                  onTap: () async {},
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: currentUserDocument!.avatarUrl ?? '',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentUser!.name,
                                    style: Tema.of(context).title3.override(
                                          fontFamily: 'Montserrat',
                                          color: Tema.of(context).turquesa,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  currentUserDocument?.friends != null
                                      ? Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(3, 5, 0, 0),
                                          child: Text(
                                            currentUserDocument!.friends!.length.toString() +
                                                (currentUserDocument!.friends!.length == 1
                                                    ? ' Amigo'
                                                    : ' Amigos'),
                                            style: Tema.of(context).bodyText1.override(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                          ),
                                        )
                                      : Container(),
                                  Row(
                                    children: [
                                      Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                          child: InkWell(
                                              onTap: () async {
                                                await launchUrl(Uri.parse(currentUser!.spotifyUrl));
                                              },
                                              child: Image.asset(
                                                'assets/images/spotify.png',
                                                width: 25,
                                              ))),
                                      currentUserDocument!.instagramUrl != null
                                          ? Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(10, 10, 0, 0),
                                              child: InkWell(
                                                  onTap: () async {
                                                    await launchUrl(Uri.parse(
                                                        currentUserDocument!.instagramUrl!));
                                                  },
                                                  child: Image.asset(
                                                    'assets/images/instagram-4.png',
                                                    width: 25,
                                                  )))
                                          : Container()
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shows',
                      style: Tema.of(context).subtitle1,
                    ),
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: InkWell(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                              child: ShowslistPageWidget(), bloc: EventsBloc())),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Tema.of(context).secondaryColor,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                    child: Text(
                                      'Mis Shows',
                                      style: Tema.of(context).subtitle3,
                                    ),
                                  )),
                            ),
                            Expanded(
                                child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                              child: InkWell(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                              child: ShowsWishlistPageWidget(),
                                              bloc: EventsBloc())),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Tema.of(context).secondaryColor,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                                    child: Text(
                                      'Wishlist Shows',
                                      style: Tema.of(context).subtitle3,
                                    ),
                                  )),
                            ))
                          ],
                        )),
                    Text(
                      'Tops',
                      style: Tema.of(context).subtitle1,
                    ),
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: InkWell(
                                  onTap: () async {
                                    final artists = await profileBloc.getTopArtistsMix();
                                    final artists2 = artists.sublist(0, 19);
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                              child: ListOfArtistsWidget(
                                                  artists: artists2, title: 'Mi Top Artistas'),
                                              bloc: ArtistBloc())),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Tema.of(context).secondaryColor,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                    child: Text(
                                      'Top Artistas',
                                      style: Tema.of(context).subtitle3,
                                    ),
                                  )),
                            ),
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                                    child: InkWell(
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ListOfSongsWidget(
                                                  songs: songs, title: 'Mi Top Canciones'),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Tema.of(context).secondaryColor,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                          alignment: Alignment.center,
                                          padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                                          child: Text(
                                            'Top Canciones',
                                            style: Tema.of(context).subtitle3,
                                          ),
                                        ))))
                          ],
                        )),
                    Text(
                      'Amigos',
                      style: Tema.of(context).subtitle1,
                    ),
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: InkWell(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FriendRequestsWidget(bloc: profileBloc),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Tema.of(context).secondaryColor,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                    child: Text(
                                      'Solicitudes',
                                      style: Tema.of(context).subtitle3,
                                    ),
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                                child: InkWell(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FriendsPageWidget(bloc: profileBloc)),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Tema.of(context).secondaryColor,
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      alignment: Alignment.center,
                                      padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                                      child: Text(
                                        'Mis Amigos',
                                        style: Tema.of(context).subtitle3,
                                      ),
                                    )))
                          ],
                        )),
                  ],
                ),
              ),
              InkWell(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Tema.of(context).white,
                      ),
                      padding: EdgeInsetsDirectional.fromSTEB(10, 7, 10, 7),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Tema.of(context).turquesa,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                        child: Text(
                          'Mis Posts',
                          style: Tema.of(context).subtitle2,
                        ),
                      ))),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                child: StreamBuilder<List<PostRecord?>>(
                  stream: profileBloc.getMyPosts(),
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
                    List<PostRecord?> events = snapshot.data!;
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: events.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, listViewIndex) {
                        final listViewSongPostsRecord = events[listViewIndex];
                        return listViewSongPostsRecord!.typeOfPost == 'event' ||
                                listViewSongPostsRecord.typeOfPost == 'wishlist_event'
                            ? BlocProvider(
                                bloc: SongBloc(),
                                child: EventPostWidget(post: listViewSongPostsRecord))
                            : BlocProvider(
                                bloc: SongBloc(),
                                child: SongPostWidget(
                                  post: listViewSongPostsRecord,
                                ));
                      },
                    );
                  },
                ),
              )
            ])))
          ],
        ),
      ),
    );
  }
  getArtistsAndSongs() async {
    songs = await profileBloc.getTopSongsMix();
    artists = await profileBloc.getTopArtistsMix();
  }
}
