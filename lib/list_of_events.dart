import 'package:diatribapp/tema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:intl/intl.dart';

import 'artist_page.dart';
import 'blocs/artist_bloc.dart';
import 'blocs/event_details_bloc.dart';
import 'blocs/events_bloc.dart';
import 'event_details_page.dart';
import 'models/Event.dart';

class ListOfEventsWidget extends StatefulWidget {
  const ListOfEventsWidget({Key? key, required this.events, required this.title}) : super(key: key);

  final List<String> events;
  final String title;

  @override
  _ListOfEventsWidgetState createState() => _ListOfEventsWidgetState();
}

class _ListOfEventsWidgetState extends State<ListOfEventsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late EventsBloc eventsBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    eventsBloc = BlocProvider.of<EventsBloc>(context);
    return MaterialApp(
      home: Scaffold(
          key: scaffoldKey,
          backgroundColor: Tema.of(context).primaryBackground,
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
              widget.title,
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
          body: ListView.builder(
            itemCount: widget.events.length,
            itemBuilder: (context, index) {
              return FutureBuilder<Event>(
                future: eventsBloc.getEvent(widget.events[index]),
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
                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
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
                              Padding(
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
                                            padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
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
                                            padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
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
                                            padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                                            child: Text(
                                              event.type == typeOfEvent.Festival
                                                  ? DateFormat('dd/MM/yyyy').format(event.time)
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        event.type == typeOfEvent.Festival
                                            ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                          20, 0, 24, 0),
                                                      child: TextButton(
                                                        onPressed: () async {
                                                          await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => BlocProvider(
                                                                    child: EventDetailsWidget(
                                                                        event: event),
                                                                    bloc: EventDetailsBloc())),
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
                                                              borderRadius:
                                                                  BorderRadius.circular(10),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional.fromSTEB(
                                                                      10, 5, 10, 5),
                                                              child: Text('Line Up',
                                                                  style: Tema.of(context)
                                                                      .subtitle1
                                                                      .override(
                                                                          fontFamily: 'Nunito',
                                                                          color: Tema.of(context)
                                                                              .white)),
                                                            )),
                                                      )),
                                                ],
                                              )
                                            : GestureDetector(
                                                onTap: () async {
                                                  final artists = await eventsBloc
                                                          .searchArtist(event.lineUp[0]) ??
                                                      [];
                                                  final id =
                                                      await eventsBloc.getArtistId(artists[0].name);
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
                                                          padding: EdgeInsetsDirectional.fromSTEB(
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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                                onPressed: () async {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => BlocProvider(
                                                            child: EventDetailsWidget(event: event),
                                                            bloc: EventDetailsBloc())),
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Tema.of(context).primaryColor,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                          10, 5, 10, 5),
                                                      child: Text(
                                                        '+ info',
                                                        style: Tema.of(context).bodyText1.override(
                                                            fontFamily: 'Nunito',
                                                            color: Tema.of(context).white),
                                                      )),
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 10),
                                        child: Image.asset(
                                          'assets/images/powered-by-songkick-pink.png',
                                          height: 22,
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                  );
                },
              );
            },
          )),
    );
  }
}
