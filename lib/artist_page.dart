import 'package:cached_network_image/cached_network_image.dart';
import 'package:diatribapp/event_details_page.dart';
import 'package:diatribapp/tema.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'blocs/artist_bloc.dart';
import 'blocs/event_details_bloc.dart';
import 'models/Album.dart';
import 'models/Artist.dart';
import 'models/Event.dart';

class ArtistWidget extends StatefulWidget {
  const ArtistWidget({Key? key, required this.artist, required this.id}) : super(key: key);

  final Artist artist;
  final String id;

  @override
  _ArtistWidgetState createState() => _ArtistWidgetState();
}

class _ArtistWidgetState extends State<ArtistWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Album> albums = [];
  bool showAlbums = false;

  late ArtistBloc artistBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    artistBloc = BlocProvider.of<ArtistBloc>(context);

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
                widget.artist.name,
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
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.all(10),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: widget.artist.image!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => new CircularProgressIndicator(),
                        ),
                      ),
                      title: Text(
                        widget.artist.name,
                        style: Tema.of(context)
                            .subtitle1
                            .override(fontFamily: 'Nunito', color: Tema.of(context).primaryColor),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              showAlbums = true;
                            });
                            if (albums.isEmpty) {
                              getMyNewReleases();
                            }
                          },
                          child: showAlbums
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Tema.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsetsDirectional.all(10),
                                  child: Text(
                                    'Discografía',
                                    style: Tema.of(context).subtitle2,
                                  ))
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Tema.of(context).turquesa,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsetsDirectional.all(10),
                                  child: Text(
                                    'Discografía',
                                    style: Tema.of(context).subtitle3,
                                  ))),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              showAlbums = false;
                            });
                          },
                          child: !showAlbums
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Tema.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsetsDirectional.all(10),
                                  child: Text(
                                    'Shows',
                                    style: Tema.of(context).subtitle2,
                                  ))
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Tema.of(context).turquesa,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsetsDirectional.all(10),
                                  child: Text(
                                    'Shows',
                                    style: Tema.of(context).subtitle3,
                                  ))),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                        child: Column(children: [
                      !showAlbums
                          ? FutureBuilder<List<Event>?>(
                              future: artistBloc.getShows(widget.id),
                              builder: (context, snapshot) {
                                final events = snapshot.data;
                                if (snapshot.hasData) {
                                  if (events == null) {
                                    return Text('No tiene conciertos previstos');
                                  } else {
                                    return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: events.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFFD2D9E7),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 0,
                                                    color: Color(0xFFDBE2E7),
                                                    offset: Offset(0, 2),
                                                  )
                                                ],
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        color: Tema.of(context).alternate,
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            blurRadius: 0,
                                                            color: Color(0xFFDBE2E7),
                                                            offset: Offset(0, 2),
                                                          )
                                                        ],
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                            10, 5, 10, 5),
                                                        child: Text(
                                                          events[index].type.name,
                                                          style: Tema.of(context).subtitle3,
                                                        ),
                                                      )),
                                                  Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(
                                                        15, 5, 15, 15),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional.fromSTEB(
                                                                        24, 0, 24, 0),
                                                                child: Text(
                                                                  events[index].name,
                                                                  style: Tema.of(context)
                                                                      .title3
                                                                      .override(
                                                                        fontFamily: 'Nunito',
                                                                        fontSize: 24,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional.fromSTEB(
                                                                        24, 0, 24, 0),
                                                                child: Text(
                                                                  events[index].location,
                                                                  style: Tema.of(context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily: 'Nunito',
                                                                        color: Tema.of(context)
                                                                            .secondaryColor,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional.fromSTEB(
                                                                        24, 0, 24, 0),
                                                                child: Text(
                                                                  events[index].type ==
                                                                          typeOfEvent.Festival
                                                                      ? DateFormat('dd/MM/yyyy')
                                                                          .format(
                                                                              events[index].time)
                                                                      : DateFormat(
                                                                              'HH:mm dd/MM/yyyy')
                                                                          .format(
                                                                              events[index].time),
                                                                  style: Tema.of(context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily: 'Nunito',
                                                                        color: Tema.of(context)
                                                                            .secondaryColor,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        events[index].type == typeOfEvent.Festival
                                                            ? Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(20, 0, 24, 0),
                                                                      child: TextButton(
                                                                        onPressed: () async {
                                                                          await Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => BlocProvider(
                                                                                    child: EventDetailsWidget(
                                                                                        event: events[
                                                                                            index]),
                                                                                    bloc:
                                                                                        EventDetailsBloc())),
                                                                          );
                                                                        },
                                                                        child: Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color:
                                                                                  Tema.of(context)
                                                                                      .primaryColor,
                                                                              boxShadow: const [
                                                                                BoxShadow(
                                                                                  blurRadius: 0,
                                                                                  color: Color(
                                                                                      0xFFDBE2E7),
                                                                                  offset:
                                                                                      Offset(0, 2),
                                                                                )
                                                                              ],
                                                                              borderRadius:
                                                                                  BorderRadius
                                                                                      .circular(10),
                                                                            ),
                                                                            child: Padding(
                                                                              padding:
                                                                                  EdgeInsetsDirectional
                                                                                      .fromSTEB(10,
                                                                                          5, 10, 5),
                                                                              child: Text('Line Up',
                                                                                  style: Tema.of(
                                                                                          context)
                                                                                      .subtitle1
                                                                                      .override(
                                                                                          fontFamily:
                                                                                              'Nunito',
                                                                                          color: Tema.of(
                                                                                                  context)
                                                                                              .white)),
                                                                            )),
                                                                      )),
                                                                  Expanded(
                                                                    child: Padding(
                                                                        padding:
                                                                            EdgeInsetsDirectional
                                                                                .fromSTEB(
                                                                                    10, 10, 10, 10),
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            TextButton(
                                                                                onPressed:
                                                                                    () async {
                                                                                  await Navigator
                                                                                      .push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (context) => BlocProvider(
                                                                                            child: EventDetailsWidget(
                                                                                                event: events[
                                                                                                    index]),
                                                                                            bloc:
                                                                                                EventDetailsBloc())),
                                                                                  );
                                                                                },
                                                                                child: Container(
                                                                                  decoration:
                                                                                      BoxDecoration(
                                                                                    color: Tema.of(
                                                                                            context)
                                                                                        .primaryColor,
                                                                                    borderRadius:
                                                                                        BorderRadius
                                                                                            .circular(
                                                                                                10),
                                                                                  ),
                                                                                  child: Padding(
                                                                                      padding: EdgeInsetsDirectional
                                                                                          .fromSTEB(
                                                                                              10,
                                                                                              5,
                                                                                              10,
                                                                                              5),
                                                                                      child: Text(
                                                                                        '+ info',
                                                                                        style: Tema.of(
                                                                                                context)
                                                                                            .bodyText1
                                                                                            .override(
                                                                                                fontFamily:
                                                                                                    'Nunito',
                                                                                                color:
                                                                                                    Tema.of(context).white),
                                                                                      )),
                                                                                ))
                                                                          ],
                                                                        )),
                                                                  )
                                                                ],
                                                              )
                                                            : GestureDetector(
                                                                onTap: () async {
                                                                  final artists =
                                                                      await artistBloc.searchArtist(
                                                                              events[index]
                                                                                  .lineUp[0]) ??
                                                                          [];
                                                                  final id = await artistBloc
                                                                      .getArtistId(artists[0].name);
                                                                  if (id != null) {
                                                                    await Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              BlocProvider(
                                                                                  child: ArtistWidget(
                                                                                      artist:
                                                                                          artists[
                                                                                              0],
                                                                                      id: id),
                                                                                  bloc:
                                                                                      ArtistBloc())),
                                                                    );
                                                                  }
                                                                },
                                                                child: Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(24, 10, 10, 10),
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        color:
                                                                            Tema.of(context).white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10),
                                                                      ),
                                                                      child: Padding(
                                                                          padding:
                                                                              EdgeInsetsDirectional
                                                                                  .fromSTEB(10, 10,
                                                                                      10, 10),
                                                                          child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment
                                                                                    .start,
                                                                            children: [
                                                                              Text(
                                                                                events[index]
                                                                                    .lineUp[0],
                                                                                style: Tema.of(
                                                                                        context)
                                                                                    .subtitle1
                                                                                    .override(
                                                                                        fontFamily:
                                                                                            'Nunito',
                                                                                        color: Tema.of(
                                                                                                context)
                                                                                            .primaryColor),
                                                                              ),
                                                                            ],
                                                                          )),
                                                                    ))),
                                                        Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                10, 5, 10, 10),
                                                            child: Image.asset(
                                                              'assets/images/powered-by-songkick-pink.png',
                                                              height: 22,
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  if (snapshot.hasError || events == null) {
                                    return Text('No tiene conciertos previstos');
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                }
                              })
                          : Builder(
                              builder: (BuildContext context) {
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: albums.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Tema.of(context).secondaryColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(
                                                      10, 10, 10, 10),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: albums[index].albumImage != null
                                                            ? ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius.circular(10),
                                                                child: CachedNetworkImage(
                                                                  imageUrl:
                                                                      albums[index].albumImage,
                                                                  width: 56,
                                                                  height: 56,
                                                                  fit: BoxFit.cover,
                                                                  placeholder: (context, url) =>
                                                                      new CircularProgressIndicator(),
                                                                ),
                                                              )
                                                            : ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius.circular(10),
                                                                child: Image.asset(
                                                                  'assets/images/user.png',
                                                                  width: 56,
                                                                  height: 56,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                      ),
                                                      Expanded(
                                                          child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional.fromSTEB(
                                                                      10, 0, 10, 0),
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      albums[index].name,
                                                                      style: Tema.of(context)
                                                                          .subtitle1
                                                                          .override(
                                                                              fontFamily: 'Nunito',
                                                                              color: Tema.of(
                                                                                      context)
                                                                                  .primaryColor),
                                                                    ),
                                                                    Text(
                                                                      DateFormat('dd/MM/yyyy')
                                                                          .format(albums[index]
                                                                              .releaseDate),
                                                                      style: Tema.of(context)
                                                                          .bodyText1
                                                                          .override(
                                                                              fontFamily: 'Nunito',
                                                                              color:
                                                                                  Tema.of(context)
                                                                                      .white),
                                                                    ),
                                                                    Wrap(
                                                                      children: albums[index]
                                                                          .artists
                                                                          .map((el) =>
                                                                              GestureDetector(
                                                                                  onTap: () async {
                                                                                    final artists =
                                                                                        await albums[
                                                                                                index]
                                                                                            .artists;
                                                                                    final id = await artistBloc
                                                                                        .getArtistId(
                                                                                            artists[0]
                                                                                                .name);
                                                                                    if (id !=
                                                                                        null) {
                                                                                      if (el.name !=
                                                                                          widget
                                                                                              .artist
                                                                                              .name) {
                                                                                        await Navigator
                                                                                            .push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) => BlocProvider(
                                                                                                  child: ArtistWidget(artist: el, id: id),
                                                                                                  bloc: ArtistBloc())),
                                                                                        );
                                                                                      }
                                                                                    }
                                                                                  },
                                                                                  child: Padding(
                                                                                      padding: EdgeInsetsDirectional
                                                                                          .fromSTEB(
                                                                                              0,
                                                                                              10,
                                                                                              10,
                                                                                              0),
                                                                                      child:
                                                                                          Container(
                                                                                        decoration:
                                                                                            BoxDecoration(
                                                                                          color: Tema.of(
                                                                                                  context)
                                                                                              .white,
                                                                                          borderRadius:
                                                                                              BorderRadius.circular(
                                                                                                  10),
                                                                                        ),
                                                                                        child: Padding(
                                                                                            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                                                                            child: Column(
                                                                                              crossAxisAlignment:
                                                                                                  CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  el.name,
                                                                                                  style: Tema.of(context).subtitle1.override(fontFamily: 'Nunito', color: Tema.of(context).primaryColor),
                                                                                                ),
                                                                                              ],
                                                                                            )),
                                                                                      ))))
                                                                          .toList(),
                                                                    ),
                                                                    Padding(
                                                                        padding:
                                                                            EdgeInsetsDirectional
                                                                                .fromSTEB(
                                                                                    0, 10, 10, 0),
                                                                        child: InkWell(
                                                                          onTap: () {
                                                                            if (albums[index]
                                                                                    .spotifyUrl !=
                                                                                null) {
                                                                              launchUrl(Uri.parse(
                                                                                  'spotify:album:' +
                                                                                      albums[index]
                                                                                          .id));
                                                                            }
                                                                          },
                                                                          child: Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color:
                                                                                  Tema.of(context)
                                                                                      .primaryColor,
                                                                              borderRadius:
                                                                                  BorderRadius
                                                                                      .circular(10),
                                                                            ),
                                                                            child: Padding(
                                                                                padding:
                                                                                    EdgeInsetsDirectional
                                                                                        .fromSTEB(
                                                                                            10,
                                                                                            10,
                                                                                            10,
                                                                                            10),
                                                                                child: Row(
                                                                                  mainAxisSize:
                                                                                      MainAxisSize
                                                                                          .min,
                                                                                  children: [
                                                                                    Image.asset(
                                                                                      'assets/images/spotify.png',
                                                                                      width: 20,
                                                                                    ),
                                                                                    Text(
                                                                                        '  ABRIR EN SPOTIFY',
                                                                                        style: Tema.of(
                                                                                                context)
                                                                                            .subtitle2
                                                                                            .override(
                                                                                                fontFamily:
                                                                                                    'Nunito',
                                                                                                color:
                                                                                                    Tema.of(context).spotifyColor))
                                                                                  ],
                                                                                )),
                                                                          ),
                                                                        ))
                                                                  ])))
                                                    ],
                                                  )))),
                                    );
                                  },
                                );
                              },
                            )
                    ])),
                  )
                ],
              ),
            )));
  }

  void getMyNewReleases() async {
    List<Album> newAlbums = [];
    List<Album>? albumsNow = await artistBloc.getMyNewReleases(widget.artist.id);
    if (albumsNow != null) {
      for (var album in albumsNow) {
        newAlbums.add(album);
      }
    }
    setState(() {
      albums = newAlbums;
    });
  }

  int compareAlbums(Album a, Album b) {
    final dateTimeA = a.releaseDate;
    final dateTimeB = b.releaseDate;
    if (dateTimeA.isBefore(dateTimeB)) {
      return 1;
    } else if (dateTimeB.isBefore(dateTimeA)) {
      return -1;
    } else {
      return 0;
    }
  }
}
