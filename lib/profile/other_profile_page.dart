import 'package:cached_network_image/cached_network_image.dart';
import 'package:diatribapp/blocs/chat_bloc.dart';
import 'package:diatribapp/blocs/events_bloc.dart';
import 'package:diatribapp/blocs/profile_bloc.dart';
import 'package:diatribapp/blocs/song_bloc.dart';
import 'package:diatribapp/chat_page.dart';
import 'package:diatribapp/list_of_artists.dart';
import 'package:diatribapp/list_of_events.dart';
import 'package:diatribapp/list_of_songs.dart';
import 'package:diatribapp/models/user_record.dart';
import 'package:diatribapp/tema.dart';
import 'package:diatribapp/util.dart';
import 'package:diatribapp/widgets/event_post_widget.dart';
import 'package:diatribapp/widgets/song_post_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/artist_bloc.dart';
import '../models/Artist.dart';
import '../models/Song.dart';
import '../models/chat_record.dart';
import '../models/post_record.dart';
import '../models/user.dart';

class OtherProfileWidget extends StatefulWidget {
  const OtherProfileWidget({Key? key, required this.user, this.bloc}) : super(key: key);

  final UserRecord user;
  final ProfileBloc? bloc;

  @override
  _OtherProfileWidgetState createState() => _OtherProfileWidgetState();
}

class _OtherProfileWidgetState extends State<OtherProfileWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileBloc = widget.bloc ?? BlocProvider.of<ProfileBloc>(context);
    return MaterialApp(
      home: Scaffold(
          key: scaffoldKey,
          backgroundColor: Color(0xFFF1F4F8),
          appBar: AppBar(
            backgroundColor: Tema.of(context).primaryColor,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Perfil',
              style: Tema.of(context).title2.override(
                    fontFamily: 'Nunito',
                    color: Colors.white,
                    fontSize: 22,
                  ),
            ),
          ),
          body: FutureBuilder<User>(
              future: profileBloc.getUserById(widget.user.reference.id),
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
                User? user = snapshot.data;
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Tema.of(context).primaryColor,
                        border: Border(
                          bottom: BorderSide(width: 2.0, color: Tema.of(context).secondaryColor),
                        ),
                      ),
                      child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 20, 0, 20),
                          child: Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          profileBloc.newFriendRequest(
                                              currentUserDocument!.reference,
                                              widget.user.reference);
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Solicitud enviada'),
                                                content: Text('Espera a que sea aceptada'),
                                                actions: [
                                                  Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () async {
                                                            Navigator.pop(alertDialogContext);
                                                          },
                                                          child: Text('OK'),
                                                        ),
                                                      ]),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Tema.of(context).white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            padding: EdgeInsetsDirectional.fromSTEB(10, 7, 10, 7),
                                            child: currentUserDocument!.friends != null &&
                                                    currentUserDocument!.friends!
                                                        .contains(widget.user.reference)
                                                ? Row(children: [
                                                    Icon(
                                                      Icons.supervised_user_circle_sharp,
                                                      color: Tema.of(context).secondaryColor,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional.only(start: 10),
                                                      child: Text(
                                                        'Amig@',
                                                        style: Tema.of(context).subtitle2,
                                                      ),
                                                    )
                                                  ])
                                                : Row(children: [
                                                    Icon(
                                                      Icons.person_add,
                                                      color: Tema.of(context).secondaryColor,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional.only(start: 10),
                                                      child: Text(
                                                        'Solicitar amistad',
                                                        style: Tema.of(context).subtitle2,
                                                      ),
                                                    )
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
                                              imageUrl: widget.user.avatarUrl ?? '',
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
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                widget.user.name!,
                                                style: Tema.of(context).title3.override(
                                                      fontFamily: 'Montserrat',
                                                      color: Tema.of(context).turquesa,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                                                child: InkWell(
                                                  onTap: () async {
                                                    ChatRecord? exists = await profileBloc
                                                        .chatExists(widget.user.reference);
                                                    if (exists == null) {
                                                      profileBloc.newChat(
                                                          currentUserDocument!.reference,
                                                          widget.user.reference);
                                                      exists = await profileBloc
                                                          .chatExists(widget.user.reference);
                                                    }
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => BlocProvider(
                                                              child: ChatPageWidget(
                                                                  chat: exists!, user: widget.user),
                                                              bloc: ChatBloc())),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Tema.of(context).softBlue,
                                                        borderRadius: BorderRadius.circular(15)),
                                                    padding: EdgeInsetsDirectional.all(7),
                                                    child: Icon(Icons.chat_bubble_rounded),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          currentUserDocument?.friends != null
                                              ? Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(3, 5, 0, 0),
                                                  child: Text(
                                                    widget.user.friends!.length.toString() +
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
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                  child: InkWell(
                                                      onTap: () async {
                                                        await launchUrl(
                                                            Uri.parse(user!.spotifyUrl));
                                                      },
                                                      child: Image.asset(
                                                        'assets/images/spotify.png',
                                                        width: 25,
                                                      ))),
                                              currentUserDocument!.instagramUrl != null
                                                  ? Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                          10, 10, 0, 0),
                                                      child: InkWell(
                                                          onTap: () async {
                                                            await launchUrl(Uri.parse(
                                                                widget.user.instagramUrl!));
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
                              'En común',
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
                                                        child: ListOfArtistsWidget(
                                                            artists: profileBloc
                                                                .getCommonArtists(widget.user),
                                                            title: 'Artistas en común con ' +
                                                                widget.user.name!),
                                                        bloc: ArtistBloc())),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Tema.of(context).turquesa,
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                              ),
                                              alignment: Alignment.center,
                                              padding: EdgeInsetsDirectional.fromSTEB(5, 7, 5, 7),
                                              child: Text(
                                                profileBloc
                                                        .getCommonArtists(widget.user)
                                                        .length
                                                        .toString() +
                                                    ' Artistas',
                                                style: Tema.of(context).subtitle3,
                                              ),
                                            ))),
                                    Expanded(
                                        child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                      child: InkWell(
                                          onTap: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => BlocProvider(
                                                      child: ListOfEventsWidget(
                                                          events: profileBloc
                                                              .getCommonShows(widget.user),
                                                          title: 'Shows en común con ' +
                                                              widget.user.name!),
                                                      bloc: EventsBloc())),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Tema.of(context).turquesa,
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            alignment: Alignment.center,
                                            padding: EdgeInsetsDirectional.all(7),
                                            child: Text(
                                              profileBloc
                                                      .getCommonShows(widget.user)
                                                      .length
                                                      .toString() +
                                                  ' Shows',
                                              style: Tema.of(context).subtitle3,
                                            ),
                                          )),
                                    )),
                                    Expanded(
                                        child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                            child: FutureBuilder<List<Song>>(
                                                future: profileBloc.getCommonSongs(widget.user),
                                                builder: (context, snapshot) {
                                                  final commonSongs = snapshot.data;
                                                  if (commonSongs != null) {
                                                    return InkWell(
                                                        onTap: () async {
                                                          await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ListOfSongsWidget(
                                                                      songs: commonSongs,
                                                                      title:
                                                                          'Canciones en común con ' +
                                                                              widget.user.name!),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Tema.of(context).turquesa,
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(10)),
                                                          ),
                                                          alignment: Alignment.center,
                                                          padding: EdgeInsetsDirectional.all(7),
                                                          child: Text(
                                                            commonSongs.length.toString() +
                                                                ' Canciones',
                                                            style: Tema.of(context).subtitle3,
                                                          ),
                                                        ));
                                                  } else {
                                                    return Container();
                                                  }
                                                })))
                                  ],
                                )),
                            Text(
                              'Top Artistas',
                              style: Tema.of(context).subtitle1.override(
                                  fontFamily: 'Montserrat', color: Tema.of(context).darkGreen),
                            ),
                            Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 110,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ListView.builder(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: 4,
                                          itemBuilder: (context, listViewIndex) {
                                            final artistId = widget.user.topArtists![listViewIndex];
                                            return FutureBuilder<Artist>(
                                              future: profileBloc.getArtist(artistId),
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
                                                Artist? artist = snapshot.data;
                                                return InkWell(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(
                                                        0, 0, 10, 10),
                                                    child: Container(
                                                        width: 65,
                                                        height: 100,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius.circular(10),
                                                                child: CachedNetworkImage(
                                                                  imageUrl: artist?.image ?? '',
                                                                  width: 65,
                                                                  height: 65,
                                                                  fit: BoxFit.cover,
                                                                )),
                                                            Text(artist?.name ?? '')
                                                          ],
                                                        )),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 45),
                                            child: InkWell(
                                                onTap: () async {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => BlocProvider(
                                                            child: ListOfArtistsWidget(
                                                                artists: widget.user.topArtists!
                                                                    .toList(),
                                                                title: 'Top Artistas de ' +
                                                                    widget.user.name!),
                                                            bloc: ArtistBloc())),
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Tema.of(context).darkGreen,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        blurRadius: 0,
                                                        color: Color(0xFFDBE2E7),
                                                        offset: Offset(0, 2),
                                                      )
                                                    ],
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  padding: EdgeInsetsDirectional.all(3),
                                                  child: Icon(
                                                    Icons.navigate_next,
                                                    color: Tema.of(context).turquesa,
                                                  ),
                                                )))
                                      ],
                                    ))),
                            Text(
                              'Top Canciones',
                              style: Tema.of(context).subtitle1.override(
                                  fontFamily: 'Montserrat', color: Tema.of(context).darkGreen),
                            ),
                            Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 110,
                                    child: Row(
                                      children: [
                                        ListView.builder(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: 4,
                                          itemBuilder: (context, listViewIndex) {
                                            final songId = widget.user.topSongs![listViewIndex];
                                            return FutureBuilder<Song>(
                                              future: profileBloc.getSong(songId),
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
                                                Song? song = snapshot.data;
                                                return InkWell(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(
                                                        0, 0, 10, 10),
                                                    child: Container(
                                                        width: 65,
                                                        height: 100,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius.circular(10),
                                                                child: CachedNetworkImage(
                                                                  imageUrl: song?.albumImage ?? '',
                                                                  width: 65,
                                                                  height: 65,
                                                                  fit: BoxFit.cover,
                                                                )),
                                                            Text(song?.name ?? '')
                                                          ],
                                                        )),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 45),
                                            child: InkWell(
                                                onTap: () async {
                                                  final songs = await profileBloc
                                                      .getSongs(widget.user.topSongs!.toList());
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ListOfSongsWidget(
                                                          songs: songs,
                                                          title: 'Top Canciones de ' +
                                                              widget.user.name!),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Tema.of(context).darkGreen,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        blurRadius: 0,
                                                        color: Color(0xFFDBE2E7),
                                                        offset: Offset(0, 2),
                                                      )
                                                    ],
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  padding: EdgeInsetsDirectional.all(3),
                                                  child: Icon(
                                                    Icons.navigate_next,
                                                    color: Tema.of(context).turquesa,
                                                  ),
                                                )))
                                      ],
                                    ))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                        child: StreamBuilder<List<PostRecord?>>(
                          stream: profileBloc.getOtherPosts(widget.user.reference),
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
                            return Column(
                              children: [
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
                                          events.length.toString() + ' Posts',
                                          style: Tema.of(context).subtitle2,
                                        ),
                                      )),
                                ),
                                ListView.builder(
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
                                            child: SongPostWidget(post: listViewSongPostsRecord),
                                            bloc: SongBloc());
                                  },
                                )
                              ],
                            );
                          },
                        ),
                      )
                    ])))
                  ],
                );
              })),
    );
  }
}
