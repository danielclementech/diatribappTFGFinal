import 'package:cached_network_image/cached_network_image.dart';
import 'package:diatribapp/event_details_page.dart';
import 'package:diatribapp/tema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:intl/intl.dart';

import 'artist_page.dart';
import 'blocs/artist_bloc.dart';
import 'blocs/event_details_bloc.dart';
import 'blocs/news_bloc.dart';
import 'models/Album.dart';
import 'models/Event.dart';

class MyShowsWidget extends StatefulWidget {
  const MyShowsWidget({
    Key? key,
  }) : super(key: key);

  @override
  _MyShowsWidgetState createState() => _MyShowsWidgetState();
}

class _MyShowsWidgetState extends State<MyShowsWidget> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TabController? tabController;
  late NewsBloc newsBloc;
  int distance = 300;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    newsBloc = BlocProvider.of<NewsBloc>(context);
    return MaterialApp(
      home: Scaffold(
          key: scaffoldKey,
          backgroundColor: Tema.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: Tema.of(context).primaryColor,
            automaticallyImplyLeading: false,
            title: Text(
              'Noticias',
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
          body: Column(
            children: [
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Column(
                    children: [
                      TabBar(
                        isScrollable: true,
                        labelColor: Tema.of(context).primaryColor,
                        unselectedLabelColor: Color(0xFF95A1AC),
                        labelStyle: Tema.of(context).subtitle2.override(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                            ),
                        indicatorColor: Tema.of(context).secondaryColor,
                        indicatorWeight: 3,
                        tabs: [
                          Tab(
                            text: 'Próximos shows',
                          ),
                          Tab(
                            text: 'Últimos lanzamientos',
                          ),
                        ],
                        controller: tabController,
                        onTap: (value) {
                          tabController?.animateTo(value,
                              duration: Duration(milliseconds: 1000), curve: Curves.ease);
                        },
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                              child: FutureBuilder<List<Event>>(
                                future: newsBloc.getMyShows(distance),
                                builder:
                                    (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
                                  if (!snapshot.hasData) {
                                    // while data is loading:
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Cargando shows...',
                                          style: Tema.of(context).title3,
                                        ),
                                        Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                            child: CircularProgressIndicator(
                                              color: Tema.of(context).alternate,
                                            ))
                                      ],
                                    );
                                  } else {
                                    // data loaded:
                                    final shows = snapshot.data;
                                    if (shows != null) {
                                      return Column(children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Tema.of(context).turquesa,
                                              borderRadius: BorderRadius.circular(10)),
                                          padding: EdgeInsetsDirectional.all(10),
                                          child: FutureBuilder<String>(
                                              future: newsBloc.getMyCity(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String> snapshot) {
                                                if (snapshot.hasData) {
                                                  final city = snapshot.data;
                                                  return Text(
                                                      'Shows más cercanos a tu localización: ' +
                                                          city!);
                                                } else {
                                                  return Text('Ciudad no localizada');
                                                }
                                              }),
                                        ),
                                        Expanded(
                                            child: ListView.builder(
                                          itemCount: shows.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {},
                                              child: Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
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
                                                              borderRadius:
                                                                  BorderRadius.circular(10),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional.fromSTEB(
                                                                      10, 5, 10, 5),
                                                              child: Text(
                                                                shows[index].type.name,
                                                                style: Tema.of(context).subtitle3,
                                                              ),
                                                            )),
                                                        Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                              15, 5, 15, 15),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisSize: MainAxisSize.max,
                                                                children: [
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(24, 0, 24, 0),
                                                                      child: Text(
                                                                        shows[index].name,
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
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(24, 0, 24, 0),
                                                                      child: Text(
                                                                        shows[index].location,
                                                                        style: Tema.of(context)
                                                                            .bodyText1
                                                                            .override(
                                                                              fontFamily: 'Nunito',
                                                                              color: Tema.of(
                                                                                      context)
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
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(24, 0, 24, 0),
                                                                      child: Text(
                                                                        shows[index].type ==
                                                                                typeOfEvent.Festival
                                                                            ? DateFormat(
                                                                                    'dd/MM/yyyy')
                                                                                .format(shows[index]
                                                                                    .time)
                                                                            : DateFormat(
                                                                                    'HH:mm dd/MM/yyyy')
                                                                                .format(shows[index]
                                                                                    .time),
                                                                        style: Tema.of(context)
                                                                            .bodyText1
                                                                            .override(
                                                                              fontFamily: 'Nunito',
                                                                              color: Tema.of(
                                                                                      context)
                                                                                  .secondaryColor,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  shows[index].type ==
                                                                          typeOfEvent.Festival
                                                                      ? Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Padding(
                                                                                padding:
                                                                                    EdgeInsetsDirectional
                                                                                        .fromSTEB(
                                                                                            20,
                                                                                            0,
                                                                                            24,
                                                                                            0),
                                                                                child: TextButton(
                                                                                  onPressed:
                                                                                      () async {
                                                                                    await Navigator
                                                                                        .push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (context) => BlocProvider(
                                                                                              child:
                                                                                                  EventDetailsWidget(event: shows[index]),
                                                                                              bloc: EventDetailsBloc())),
                                                                                    );
                                                                                  },
                                                                                  child: Container(
                                                                                      decoration:
                                                                                          BoxDecoration(
                                                                                        color: Tema.of(
                                                                                                context)
                                                                                            .primaryColor,
                                                                                        boxShadow: const [
                                                                                          BoxShadow(
                                                                                            blurRadius:
                                                                                                0,
                                                                                            color: Color(
                                                                                                0xFFDBE2E7),
                                                                                            offset: Offset(
                                                                                                0,
                                                                                                2),
                                                                                          )
                                                                                        ],
                                                                                        borderRadius:
                                                                                            BorderRadius.circular(
                                                                                                10),
                                                                                      ),
                                                                                      child:
                                                                                          Padding(
                                                                                        padding: EdgeInsetsDirectional
                                                                                            .fromSTEB(
                                                                                                10,
                                                                                                5,
                                                                                                10,
                                                                                                5),
                                                                                        child: Text(
                                                                                            'Line Up',
                                                                                            style: Tema.of(context).subtitle1.override(
                                                                                                fontFamily:
                                                                                                    'Nunito',
                                                                                                color:
                                                                                                    Tema.of(context).white)),
                                                                                      )),
                                                                                )),
                                                                          ],
                                                                        )
                                                                      : GestureDetector(
                                                                          onTap: () async {
                                                                            final artists = await newsBloc
                                                                                    .searchArtist(
                                                                                        shows[index]
                                                                                                .lineUp[
                                                                                            0]) ??
                                                                                [];
                                                                            final id =
                                                                                await newsBloc
                                                                                    .getArtistId(
                                                                                        artists[0]
                                                                                            .name);
                                                                            if (id != null) {
                                                                              await Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder:
                                                                                        (context) =>
                                                                                            BlocProvider(
                                                                                              bloc:
                                                                                                  ArtistBloc(),
                                                                                              child: ArtistWidget(
                                                                                                  artist: artists[0],
                                                                                                  id: id),
                                                                                            )),
                                                                              );
                                                                            }
                                                                          },
                                                                          child: Padding(
                                                                              padding:
                                                                                  EdgeInsetsDirectional
                                                                                      .fromSTEB(
                                                                                          24,
                                                                                          10,
                                                                                          10,
                                                                                          10),
                                                                              child: Container(
                                                                                decoration:
                                                                                    BoxDecoration(
                                                                                  color: Tema.of(
                                                                                          context)
                                                                                      .white,
                                                                                  borderRadius:
                                                                                      BorderRadius
                                                                                          .circular(
                                                                                              10),
                                                                                ),
                                                                                child: Padding(
                                                                                    padding:
                                                                                        EdgeInsetsDirectional
                                                                                            .fromSTEB(
                                                                                                10,
                                                                                                10,
                                                                                                10,
                                                                                                10),
                                                                                    child: Column(
                                                                                      crossAxisAlignment:
                                                                                          CrossAxisAlignment
                                                                                              .start,
                                                                                      children: [
                                                                                        Text(
                                                                                          shows[index]
                                                                                              .lineUp[0],
                                                                                          style: Tema.of(context).subtitle1.override(
                                                                                              fontFamily:
                                                                                                  'Nunito',
                                                                                              color:
                                                                                                  Tema.of(context).primaryColor),
                                                                                        ),
                                                                                      ],
                                                                                    )),
                                                                              ))),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment.end,
                                                                    children: [
                                                                      TextButton(
                                                                          onPressed: () async {
                                                                            await Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => BlocProvider(
                                                                                      child: EventDetailsWidget(
                                                                                          event: shows[
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
                                                                              borderRadius:
                                                                                  BorderRadius
                                                                                      .circular(10),
                                                                            ),
                                                                            child: Padding(
                                                                                padding:
                                                                                    EdgeInsetsDirectional
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
                                                                                          color: Tema.of(
                                                                                                  context)
                                                                                              .white),
                                                                                )),
                                                                          ))
                                                                    ],
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            );
                                          },
                                        ))
                                      ]);
                                    } else {
                                      return Text('NO SHOWS');
                                    }
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                              child: FutureBuilder<List<Album>?>(
                                future: newsBloc.getMyNewReleases(),
                                builder:
                                    (BuildContext context, AsyncSnapshot<List<Album>?> snapshot) {
                                  if (!snapshot.hasData) {
                                    // while data is loading:
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Cargando novedades...',
                                          style: Tema.of(context).title3,
                                        ),
                                        Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                            child: CircularProgressIndicator(
                                              color: Tema.of(context).alternate,
                                            ))
                                      ],
                                    );
                                  } else {
                                    // data loaded:
                                    final songs = snapshot.data;
                                    if (songs != null) {
                                      return ListView.builder(
                                        itemCount: songs.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {},
                                            child: Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                                child: Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    decoration: BoxDecoration(
                                                      color: Tema.of(context).secondaryColor,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                            10, 10, 10, 10),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              child: songs[index].albumImage != null
                                                                  ? ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(10),
                                                                      child: CachedNetworkImage(
                                                                        imageUrl:
                                                                            songs[index].albumImage,
                                                                        width: 56,
                                                                        height: 56,
                                                                        fit: BoxFit.cover,
                                                                        placeholder: (context,
                                                                                url) =>
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
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(10, 0, 10, 0),
                                                                    child: Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                        children: [
                                                                          Text(
                                                                            songs[index].name,
                                                                            style: Tema.of(context)
                                                                                .subtitle1
                                                                                .override(
                                                                                    fontFamily:
                                                                                        'Nunito',
                                                                                    color: Tema.of(
                                                                                            context)
                                                                                        .primaryColor),
                                                                          ),
                                                                          Text(
                                                                            DateFormat('dd/MM/yyyy')
                                                                                .format(songs[index]
                                                                                    .releaseDate),
                                                                            style: Tema.of(context)
                                                                                .bodyText1
                                                                                .override(
                                                                                    fontFamily:
                                                                                        'Nunito',
                                                                                    color: Tema.of(
                                                                                            context)
                                                                                        .white),
                                                                          ),
                                                                          Wrap(
                                                                            children: songs[index]
                                                                                .artists
                                                                                .map((el) => GestureDetector(
                                                                                    onTap: () async {
                                                                                      final artists =
                                                                                          await newsBloc
                                                                                                  .searchArtist(el.name) ??
                                                                                              [];
                                                                                      final id = await newsBloc
                                                                                          .getArtistId(
                                                                                              el.name);
                                                                                      if (id !=
                                                                                          null) {
                                                                                        await Navigator
                                                                                            .push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) =>
                                                                                                  BlocProvider(
                                                                                                    bloc: ArtistBloc(),
                                                                                                    child: ArtistWidget(artist: artists[0], id: id),
                                                                                                  )),
                                                                                        );
                                                                                      }
                                                                                    },
                                                                                    child: Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 10, 0),
                                                                                        child: Container(
                                                                                          decoration:
                                                                                              BoxDecoration(
                                                                                            color: Tema.of(context)
                                                                                                .white,
                                                                                            borderRadius:
                                                                                                BorderRadius.circular(10),
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
                                                                          )
                                                                        ])))
                                                          ],
                                                        )))),
                                          );
                                        },
                                      );
                                    } else {
                                      return Text('NO SONGS');
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  List<Event> onlySpainSHows(List<Event> shows) {
    List<Event> spainEvents = [];
    for (var event in shows) {
      final loc = event.location.split(', ');
      final country = loc[1];
      if (country == 'Spain') {
        spainEvents.add(event);
      }
    }
    return spainEvents;
  }
}
