import 'package:cached_network_image/cached_network_image.dart';
import 'package:diatribapp/blocs/event_details_bloc.dart';
import 'package:diatribapp/blocs/song_bloc.dart';
import 'package:diatribapp/blocs/user_bloc.dart';
import 'package:diatribapp/tema.dart';
import 'package:diatribapp/widgets/user_post_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import '../artist_page.dart';
import '../blocs/artist_bloc.dart';
import '../event_details_page.dart';
import '../models/Artist.dart';
import '../models/Event.dart';
import '../models/post_record.dart';

class EventPostWidget extends StatefulWidget {
  const EventPostWidget({Key? key, required this.post}) : super(key: key);

  final PostRecord post;

  @override
  _EventPostWidgetState createState() => _EventPostWidgetState();
}

class _EventPostWidgetState extends State<EventPostWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late SongBloc songBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    songBloc = BlocProvider.of<SongBloc>(context);
    return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        child: Container(
          decoration: BoxDecoration(
            color: Tema.of(context).white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              setState(() {});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Tema.of(context).white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocProvider(
                            bloc: UserBloc(),
                            child: UserPostWidget(userReference: widget.post.user!)),
                        Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(5, 5, 15, 5),
                            child: Text(timeago.format(widget.post.fecha!, locale: 'es'),
                                style: Tema.of(context).bodyText1)),
                      ],
                    )),
                widget.post.typeOfPost == 'wishlist_event'
                    ? Container(
                        decoration: BoxDecoration(
                          color: Tema.of(context).primaryColor,
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
                        ),
                        child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(15, 5, 5, 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Ha añadido este evento en su Wishlist',
                                    style: Tema.of(context).bodyText1.override(
                                        fontFamily: 'Nunito', color: Tema.of(context).white)),
                                Padding(
                                    padding: EdgeInsetsDirectional.only(start: 5),
                                    child: Icon(Icons.favorite, color: Tema.of(context).white))
                              ],
                            )),
                      )
                    : Container(),
                FutureBuilder<Event>(
                  future: songBloc.getEvent(widget.post.event!),
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
                    Event? event = snapshot.data;
                    return GestureDetector(
                      onTap: () {},
                      child: Padding(
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
                                      padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                                      child: Text(
                                        event!.type.name,
                                        style: Tema.of(context).subtitle3,
                                      ),
                                    )),
                                event.type == typeOfEvent.Festival
                                    ? Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(15, 5, 15, 15),
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
                                                    padding: EdgeInsetsDirectional.fromSTEB(
                                                        24, 0, 24, 0),
                                                    child: Text(
                                                      event.name,
                                                      style: Tema.of(context).title3.override(
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
                                                    padding: EdgeInsetsDirectional.fromSTEB(
                                                        24, 0, 24, 0),
                                                    child: Text(
                                                      event.location,
                                                      style: Tema.of(context).bodyText1.override(
                                                            fontFamily: 'Nunito',
                                                            color: Tema.of(context).secondaryColor,
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
                                                    padding: EdgeInsetsDirectional.fromSTEB(
                                                        24, 0, 24, 0),
                                                    child: Text(
                                                      event.type == typeOfEvent.Festival
                                                          ? DateFormat('dd/MM/yyyy')
                                                              .format(event.time)
                                                          : DateFormat('HH:mm dd/MM/yyyy')
                                                              .format(event.time),
                                                      style: Tema.of(context).bodyText1.override(
                                                            fontFamily: 'Nunito',
                                                            color: Tema.of(context).secondaryColor,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            event.type == typeOfEvent.Festival
                                                ? Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                              20, 0, 24, 0),
                                                          child: Column(
                                                            children: [
                                                              TextButton(
                                                                onPressed: () async {
                                                                  await Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => BlocProvider(
                                                                            child:
                                                                                EventDetailsWidget(
                                                                                    event: event),
                                                                            bloc:
                                                                                EventDetailsBloc())),
                                                                  );
                                                                },
                                                                child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Tema.of(context)
                                                                          .primaryColor,
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
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(10, 5, 10, 5),
                                                                      child: Text('Line Up',
                                                                          style: Tema.of(context)
                                                                              .subtitle1
                                                                              .override(
                                                                                  fontFamily:
                                                                                      'Nunito',
                                                                                  color: Tema.of(
                                                                                          context)
                                                                                      .white)),
                                                                    )),
                                                              ),
                                                              Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(10, 10, 10, 0),
                                                                  child: Image.asset(
                                                                    'assets/images/powered-by-songkick-pink.png',
                                                                    height: 22,
                                                                  )),
                                                            ],
                                                          )),
                                                      Expanded(
                                                        child: Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                10, 10, 10, 10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.end,
                                                              children: [
                                                                TextButton(
                                                                    onPressed: () async {
                                                                      await Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => BlocProvider(
                                                                                child:
                                                                                    EventDetailsWidget(
                                                                                        event:
                                                                                            event),
                                                                                bloc:
                                                                                    EventDetailsBloc())),
                                                                      );
                                                                    },
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        color: Tema.of(context)
                                                                            .primaryColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10),
                                                                      ),
                                                                      child: Padding(
                                                                          padding:
                                                                              EdgeInsetsDirectional
                                                                                  .fromSTEB(
                                                                                      10, 5, 10, 5),
                                                                          child: Text(
                                                                            '+ info',
                                                                            style: Tema.of(context)
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
                                                            )),
                                                      )
                                                    ],
                                                  )
                                                : GestureDetector(
                                                    onTap: () async {
                                                      final artists = await songBloc
                                                              .searchArtist(event.lineUp[0]) ??
                                                          [];
                                                      final id = await songBloc
                                                          .getArtistId(artists[0].name);
                                                      if (id != null) {
                                                        await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => BlocProvider(
                                                                  child: ArtistWidget(
                                                                      artist: artists[0], id: id),
                                                                  bloc: ArtistBloc())),
                                                        );
                                                      }
                                                    },
                                                    child: Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                            24, 10, 10, 10),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Tema.of(context).white,
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional.fromSTEB(
                                                                      10, 10, 10, 10),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    event.lineUp[0],
                                                                    style: Tema.of(context)
                                                                        .subtitle1
                                                                        .override(
                                                                            fontFamily: 'Nunito',
                                                                            color: Tema.of(context)
                                                                                .primaryColor),
                                                                  ),
                                                                ],
                                                              )),
                                                        ))),
                                          ],
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FutureBuilder<List<Artist>?>(
                                            future: songBloc.searchArtist(event.lineUp[0]),
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
                                              List<Artist>? artists = snapshot.data;
                                              Artist artist = artists![0];
                                              return Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(0, 5, 15, 10),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                            15, 10, 0, 5),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(10),
                                                          child: CachedNetworkImage(
                                                            imageUrl: artist.image!,
                                                            width: 150,
                                                            height: 150,
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) =>
                                                                const CircularProgressIndicator(),
                                                            errorWidget: (context, url, error) =>
                                                                const Icon(Icons.question_mark),
                                                          ),
                                                        )),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {
                                                            final id = await songBloc
                                                                .getArtistId(artist.name);
                                                            if (id != null) {
                                                              await Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        BlocProvider(
                                                                            child: ArtistWidget(
                                                                                artist: artist,
                                                                                id: id),
                                                                            bloc: ArtistBloc())),
                                                              );
                                                            }
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: Tema.of(context).white,
                                                              borderRadius: BorderRadius.horizontal(
                                                                  right: Radius.circular(5)),
                                                            ),
                                                            child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional.fromSTEB(
                                                                        10, 5, 10, 5),
                                                                child: Text(artist.name,
                                                                    style: Tema.of(context)
                                                                        .subtitle1)),
                                                          ),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                0, 10, 10, 0),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                double latitude =
                                                                    event.locationLngLat!.latitude;
                                                                double longitude =
                                                                    event.locationLngLat!.longitude;
                                                                final googleUrl = Uri.parse(
                                                                    'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
                                                                await launchUrl(googleUrl);
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                      Tema.of(context).primaryColor,
                                                                  borderRadius:
                                                                      BorderRadius.horizontal(
                                                                          right:
                                                                              Radius.circular(5)),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(10, 7, 10, 7),
                                                                  child: Row(
                                                                    children: [
                                                                      event.locationLngLat != null
                                                                          ? Icon(
                                                                              Icons
                                                                                  .location_on_rounded,
                                                                              color:
                                                                                  Tema.of(context)
                                                                                      .white,
                                                                            )
                                                                          : Container(),
                                                                      Text(
                                                                        event.location,
                                                                        style: Tema.of(context)
                                                                            .subtitle1
                                                                            .override(
                                                                                fontFamily:
                                                                                    'Nunito',
                                                                                color:
                                                                                    Tema.of(context)
                                                                                        .white),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            )),
                                                        Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                0, 10, 10, 0),
                                                            child: InkWell(
                                                              onTap: () async {},
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                      Tema.of(context).primaryColor,
                                                                  borderRadius:
                                                                      BorderRadius.horizontal(
                                                                          right:
                                                                              Radius.circular(5)),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(0, 0, 10, 0),
                                                                  child: Row(
                                                                    children: [
                                                                      event.locationLngLat != null
                                                                          ? IconButton(
                                                                              onPressed:
                                                                                  () async {},
                                                                              icon: Icon(
                                                                                Icons
                                                                                    .calendar_today_outlined,
                                                                                color:
                                                                                    Tema.of(context)
                                                                                        .white,
                                                                              ),
                                                                            )
                                                                          : Container(),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                        children: [
                                                                          Text(
                                                                            DateFormat('dd/MM/yyyy')
                                                                                .format(event.time),
                                                                            style: Tema.of(context)
                                                                                .subtitle1
                                                                                .override(
                                                                                    fontFamily:
                                                                                        'Nunito',
                                                                                    color: Tema.of(
                                                                                            context)
                                                                                        .white),
                                                                          ),
                                                                          Text(
                                                                            DateFormat('HH:mm')
                                                                                    .format(event
                                                                                        .time) +
                                                                                'h',
                                                                            style: Tema.of(context)
                                                                                .subtitle2
                                                                                .override(
                                                                                    fontFamily:
                                                                                        'Nunito',
                                                                                    color: Tema.of(
                                                                                            context)
                                                                                        .white),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(
                                                        10, 10, 10, 10),
                                                    child: Image.asset(
                                                      'assets/images/powered-by-songkick-pink.png',
                                                      height: 22,
                                                    )),
                                                Container(
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
                                                    child: Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                          10, 5, 10, 5),
                                                      child: InkWell(
                                                          onTap: () async {
                                                            await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      BlocProvider(
                                                                          child:
                                                                              EventDetailsWidget(
                                                                                  event: event),
                                                                          bloc:
                                                                              EventDetailsBloc())),
                                                            );
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: Tema.of(context).primaryColor,
                                                              borderRadius:
                                                                  BorderRadius.circular(10),
                                                            ),
                                                            child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional.fromSTEB(
                                                                        10, 5, 10, 5),
                                                                child: Text(
                                                                  '+ info',
                                                                  style: Tema.of(context)
                                                                      .subtitle2
                                                                      .override(
                                                                          fontFamily: 'Nunito',
                                                                          color: Tema.of(context)
                                                                              .white),
                                                                )),
                                                          )),
                                                    )),
                                              ]),
                                        ],
                                      ),
                              ],
                            )),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}
