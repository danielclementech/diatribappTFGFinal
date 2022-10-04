import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:diatribapp/artist_page.dart';
import 'package:diatribapp/blocs/event_details_bloc.dart';
import 'package:diatribapp/profile/other_profile_page.dart';
import 'package:diatribapp/tema.dart';
import 'package:diatribapp/util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'blocs/artist_bloc.dart';
import 'blocs/profile_bloc.dart';
import 'models/Artist.dart';
import 'models/Event.dart';
import 'models/user_record.dart';

class EventDetailsWidget extends StatefulWidget {
  const EventDetailsWidget({
    Key? key,
    required this.event,
  }) : super(key: key);

  final Event event;

  @override
  _EventDetailsWidgetState createState() => _EventDetailsWidgetState();
}

class _EventDetailsWidgetState extends State<EventDetailsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late EventDetailsBloc eventDetailsBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    eventDetailsBloc = BlocProvider.of<EventDetailsBloc>(context);
    return FutureBuilder<bool>(
        future: eventDetailsBloc.isInMyWishlist(widget.event.id.toString()),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (snapshot.hasData) {
            if (data == null) {
              return Text('No hay posts');
            } else {
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
                          widget.event.name,
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
                          child: widget.event.type == typeOfEvent.Festival
                              ? Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Tema.of(context).white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                widget.event.locationLngLat != null
                                                    ? IconButton(
                                                        onPressed: () async {
                                                          double latitude =
                                                              widget.event.locationLngLat!.latitude;
                                                          double longitude = widget
                                                              .event.locationLngLat!.longitude;
                                                          final googleUrl = Uri.parse(
                                                              'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
                                                          await launchUrl(googleUrl);
                                                        },
                                                        icon: Icon(
                                                          Icons.location_on_rounded,
                                                          color: Tema.of(context).primaryColor,
                                                        ),
                                                      )
                                                    : Container(),
                                                Text(
                                                  widget.event.location,
                                                  style: Tema.of(context).subtitle1.override(
                                                      fontFamily: 'Nunito',
                                                      color: Tema.of(context).primaryColor),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                                child: Image.asset(
                                                  'assets/images/powered-by-songkick-pink.png',
                                                  height: 22,
                                                ))
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                widget.event.locationLngLat != null
                                                    ? IconButton(
                                                        onPressed: () async {},
                                                        icon: Icon(
                                                          Icons.calendar_today_outlined,
                                                          color: Tema.of(context).primaryColor,
                                                        ),
                                                      )
                                                    : Container(),
                                                Text(
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(widget.event.time),
                                                  style: Tema.of(context).subtitle2.override(
                                                      fontFamily: 'Nunito',
                                                      color: Tema.of(context).primaryColor),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                !eventDetailsBloc.isInList
                                                    ? Row(
                                                        children: [
                                                          IconButton(
                                                              onPressed: () async {
                                                                FilePickerResult? result;
                                                                String? downloadUrl;
                                                                await showDialog(
                                                                  context: context,
                                                                  builder: (alertDialogContext) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          '¿Asistirás a este evento?'),
                                                                      content: Container(
                                                                          child: Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Text(
                                                                            'Para confirmar que asistirás y tener tus entradas accesibles desde la app, sube el archivo PDF de la entrada (tranquilo, tu entrada está protegida y no es accesible desde ningún otro usuario)',
                                                                            style: Tema.of(context)
                                                                                .subtitle1
                                                                                .override(
                                                                                    fontFamily:
                                                                                        'Nunito',
                                                                                    color: Tema.of(
                                                                                            context)
                                                                                        .primaryColor),
                                                                          ),
                                                                          TextButton(
                                                                              onPressed: () async {
                                                                                final res =
                                                                                    await FilePicker
                                                                                        .platform
                                                                                        .pickFiles(
                                                                                  allowMultiple:
                                                                                      false,
                                                                                );
                                                                                setState(() {
                                                                                  result = res;
                                                                                });
                                                                                if (result ==
                                                                                    null) {
                                                                                  ScaffoldMessenger
                                                                                          .of(context)
                                                                                      .showSnackBar(
                                                                                    const SnackBar(
                                                                                      content: Text(
                                                                                          'Nada seleccionado.'),
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  showDialog(
                                                                                    barrierDismissible:
                                                                                        false,
                                                                                    context:
                                                                                        context,
                                                                                    builder:
                                                                                        (alertDialogcontext) {
                                                                                      return AlertDialog(
                                                                                        content:
                                                                                            Row(
                                                                                          children: [
                                                                                            CircularProgressIndicator(
                                                                                                color:
                                                                                                    Tema.of(context).secondaryColor),
                                                                                            Container(
                                                                                                margin:
                                                                                                    EdgeInsets.only(left: 10),
                                                                                                child: Text("Cargando...", style: Tema.of(context).subtitle2.override(fontFamily: 'Nunito', color: Tema.of(context).secondaryColor))),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  );

                                                                                  File file = File(
                                                                                      result!
                                                                                          .files
                                                                                          .single
                                                                                          .path!);
                                                                                  downloadUrl = await eventDetailsBloc.uploadFile(
                                                                                      'users/' +
                                                                                          currentUser!
                                                                                              .id +
                                                                                          '/tickets/' +
                                                                                          widget
                                                                                              .event
                                                                                              .id
                                                                                              .toString() +
                                                                                          '/' +
                                                                                          (result!
                                                                                              .files
                                                                                              .single
                                                                                              .name),
                                                                                      file);
                                                                                  Navigator.pop(
                                                                                      alertDialogContext);
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                  child: Row(
                                                                                children: [
                                                                                  Icon(Icons
                                                                                      .upload_file),
                                                                                  Text(
                                                                                      'Sube tu entrada')
                                                                                ],
                                                                              ))),
                                                                          result != null
                                                                              ? Text(result!
                                                                                  .files.first.name)
                                                                              : Container()
                                                                        ],
                                                                      )),
                                                                      actions: [
                                                                        Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment
                                                                                    .spaceBetween,
                                                                            children: [
                                                                              TextButton(
                                                                                onPressed:
                                                                                    () async {
                                                                                  Navigator.pop(
                                                                                      alertDialogContext);
                                                                                },
                                                                                child: Text(
                                                                                    'No, cancelar'),
                                                                              ),
                                                                              TextButton(
                                                                                  onPressed:
                                                                                      () async {
                                                                                    eventDetailsBloc
                                                                                        .newShowOnlist(
                                                                                            widget
                                                                                                .event
                                                                                                .id
                                                                                                .toString(),
                                                                                            downloadUrl);
                                                                                    Navigator.pop(
                                                                                        alertDialogContext);
                                                                                  },
                                                                                  child: Container(
                                                                                    decoration:
                                                                                        BoxDecoration(
                                                                                      color: Tema.of(
                                                                                              context)
                                                                                          .alternate,
                                                                                      borderRadius:
                                                                                          BorderRadius
                                                                                              .circular(
                                                                                                  5),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding:
                                                                                          EdgeInsetsDirectional
                                                                                              .all(
                                                                                                  5),
                                                                                      child: Text(
                                                                                        'Sí, asistiré',
                                                                                        style: Tema.of(
                                                                                                context)
                                                                                            .bodyText1
                                                                                            .override(
                                                                                                fontFamily:
                                                                                                    'Nunito',
                                                                                                color:
                                                                                                    Tema.of(context).white),
                                                                                      ),
                                                                                    ),
                                                                                  )),
                                                                            ]),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              icon: Icon(
                                                                Icons.loupe_outlined,
                                                                color:
                                                                    Tema.of(context).primaryColor,
                                                              ))
                                                        ],
                                                      )
                                                    : Container(
                                                        child: Text('Asistiré!'),
                                                      ),
                                                eventDetailsBloc.isInWishList
                                                    ? Row(
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  eventDetailsBloc.isInWishList =
                                                                      false;
                                                                });
                                                                eventDetailsBloc
                                                                    .deleteShowOnWishlist(
                                                                        widget.event.id.toString());
                                                              },
                                                              icon: Icon(Icons.favorite))
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  eventDetailsBloc.isInWishList =
                                                                      true;
                                                                });
                                                                eventDetailsBloc.addShowOnWishlist(
                                                                    widget.event.id.toString());
                                                              },
                                                              icon: Icon(
                                                                  Icons.favorite_border_outlined))
                                                        ],
                                                      ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ]),
                                    ),
                                    Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Line Up:',
                                              style: Tema.of(context).title3.override(
                                                  fontFamily: 'Nunito',
                                                  color: Tema.of(context).primaryColor),
                                            ),
                                          ],
                                        )),
                                    Expanded(
                                        child: SingleChildScrollView(
                                            child: Column(children: [
                                      Wrap(
                                        children: widget.event.lineUp
                                            .map((el) => GestureDetector(
                                                onTap: () async {
                                                  final artists =
                                                      await eventDetailsBloc.searchArtist(el) ?? [];
                                                  final id = await eventDetailsBloc.getArtistId(el);
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
                                                        10, 0, 0, 10),
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
                                                                el,
                                                                style: Tema.of(context)
                                                                    .subtitle1
                                                                    .override(
                                                                        fontFamily: 'Nunito',
                                                                        color: Tema.of(context)
                                                                            .primaryColor),
                                                              ),
                                                            ],
                                                          )),
                                                    ))))
                                            .toList(),
                                      )
                                    ])))
                                  ],
                                )
                              : FutureBuilder<Artist>(
                                  future: getArtist(),
                                  builder: (BuildContext context, AsyncSnapshot<Artist> snapshot) {
                                    if (!snapshot.hasData) {
                                      // while data is loading:
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'No result',
                                            style: Tema.of(context).title3,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                              child: CircularProgressIndicator(
                                                color: Tema.of(context).alternate,
                                              ))
                                        ],
                                      );
                                    } else {
                                      // data loaded:
                                      final artist = snapshot.data;
                                      if (artist != null) {
                                        return Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Tema.of(context).white,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Column(children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                15, 10, 0, 5),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(10),
                                                              child: CachedNetworkImage(
                                                                imageUrl: artist.image!,
                                                                width: 150,
                                                                height: 150,
                                                                fit: BoxFit.cover,
                                                                placeholder: (context, url) =>
                                                                    const CircularProgressIndicator(),
                                                                errorWidget: (context, url,
                                                                        error) =>
                                                                    const Icon(Icons.question_mark),
                                                              ),
                                                            )),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional.fromSTEB(
                                                                        0, 20, 0, 0),
                                                                child: InkWell(
                                                                  onTap: () async {
                                                                    final id =
                                                                        await eventDetailsBloc
                                                                            .getArtistId(
                                                                                artist.name);
                                                                    if (id != null) {
                                                                      await Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                BlocProvider(
                                                                                    child: ArtistWidget(
                                                                                        artist:
                                                                                            artist,
                                                                                        id: id),
                                                                                    bloc:
                                                                                        ArtistBloc())),
                                                                      );
                                                                    }
                                                                  },
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Tema.of(context)
                                                                          .primaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.horizontal(
                                                                              right:
                                                                                  Radius.circular(
                                                                                      5)),
                                                                    ),
                                                                    child: Padding(
                                                                        padding:
                                                                            EdgeInsetsDirectional
                                                                                .fromSTEB(
                                                                                    10, 5, 10, 5),
                                                                        child: Text(artist.name,
                                                                            style: Tema.of(context)
                                                                                .subtitle1
                                                                                .override(
                                                                                    fontFamily:
                                                                                        'Nunito',
                                                                                    color: Tema.of(
                                                                                            context)
                                                                                        .white))),
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                            10, 20, 10, 10),
                                                        child: Image.asset(
                                                          'assets/images/powered-by-songkick-pink.png',
                                                          height: 22,
                                                        ))
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    widget.event.locationLngLat != null
                                                        ? IconButton(
                                                            onPressed: () async {
                                                              double latitude = widget
                                                                  .event.locationLngLat!.latitude;
                                                              double longitude = widget
                                                                  .event.locationLngLat!.longitude;
                                                              final googleUrl = Uri.parse(
                                                                  'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
                                                              await launchUrl(googleUrl);
                                                            },
                                                            icon: Icon(
                                                              Icons.location_on_rounded,
                                                              color: Tema.of(context).primaryColor,
                                                            ),
                                                          )
                                                        : Container(),
                                                    Text(
                                                      widget.event.location,
                                                      style: Tema.of(context).subtitle1.override(
                                                          fontFamily: 'Nunito',
                                                          color: Tema.of(context).primaryColor),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional.only(start: 10),
                                                      child: IconButton(
                                                        onPressed: () async {},
                                                        icon: Icon(
                                                          Icons.calendar_today_outlined,
                                                          color: Tema.of(context).primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(widget.event.time),
                                                      style: Tema.of(context).subtitle2.override(
                                                          fontFamily: 'Nunito',
                                                          color: Tema.of(context).primaryColor),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.only(start: 10),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          !eventDetailsBloc.isInList
                                                              ? InkWell(
                                                                  onTap: () async {
                                                                    FilePickerResult? result;
                                                                    String? downloadUrl;
                                                                    await showDialog(
                                                                      context: context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title: Text(
                                                                              '¿Asistirás a este evento?'),
                                                                          content: Container(
                                                                              child: Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Text(
                                                                                'Para confirmar que asistirás y tener tus entradas accesibles desde la app, sube el archivo PDF de la entrada (tranquilo, tu entrada está protegida y no es accesible desde ningún otro usuario)',
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
                                                                              TextButton(
                                                                                  onPressed:
                                                                                      () async {
                                                                                    final res =
                                                                                        await FilePicker
                                                                                            .platform
                                                                                            .pickFiles(
                                                                                      allowMultiple:
                                                                                          false,
                                                                                    );
                                                                                    setState(() {
                                                                                      result = res;
                                                                                    });
                                                                                    if (result ==
                                                                                        null) {
                                                                                      ScaffoldMessenger.of(
                                                                                              context)
                                                                                          .showSnackBar(
                                                                                        const SnackBar(
                                                                                          content: Text(
                                                                                              'Nada seleccionado.'),
                                                                                        ),
                                                                                      );
                                                                                    } else {
                                                                                      showDialog(
                                                                                        barrierDismissible:
                                                                                            false,
                                                                                        context:
                                                                                            context,
                                                                                        builder:
                                                                                            (alertDialogcontext) {
                                                                                          return AlertDialog(
                                                                                            content:
                                                                                                Row(
                                                                                              children: [
                                                                                                CircularProgressIndicator(color: Tema.of(context).secondaryColor),
                                                                                                Container(
                                                                                                    margin: EdgeInsets.only(left: 10),
                                                                                                    child: Text("Cargando...", style: Tema.of(context).subtitle2.override(fontFamily: 'Nunito', color: Tema.of(context).secondaryColor))),
                                                                                              ],
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      );

                                                                                      File file =
                                                                                          File(result!
                                                                                              .files
                                                                                              .single
                                                                                              .path!);
                                                                                      downloadUrl = await eventDetailsBloc.uploadFile(
                                                                                          'users/' +
                                                                                              currentUser!
                                                                                                  .id +
                                                                                              '/tickets/' +
                                                                                              widget
                                                                                                  .event
                                                                                                  .id
                                                                                                  .toString() +
                                                                                              '/' +
                                                                                              (result!
                                                                                                  .files
                                                                                                  .single
                                                                                                  .name),
                                                                                          file);
                                                                                      Navigator.pop(
                                                                                          alertDialogContext);
                                                                                    }
                                                                                  },
                                                                                  child: Container(
                                                                                      child: Row(
                                                                                    children: [
                                                                                      Icon(Icons
                                                                                          .upload_file),
                                                                                      Text(
                                                                                          'Sube tu entrada')
                                                                                    ],
                                                                                  ))),
                                                                              result != null
                                                                                  ? Text(result!
                                                                                      .files
                                                                                      .first
                                                                                      .name)
                                                                                  : Container()
                                                                            ],
                                                                          )),
                                                                          actions: [
                                                                            Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment
                                                                                        .spaceBetween,
                                                                                children: [
                                                                                  TextButton(
                                                                                    onPressed:
                                                                                        () async {
                                                                                      Navigator.pop(
                                                                                          alertDialogContext);
                                                                                    },
                                                                                    child: Text(
                                                                                        'No, cancelar'),
                                                                                  ),
                                                                                  TextButton(
                                                                                      onPressed:
                                                                                          () async {
                                                                                        eventDetailsBloc.newShowOnlist(
                                                                                            widget
                                                                                                .event
                                                                                                .id
                                                                                                .toString(),
                                                                                            downloadUrl);
                                                                                        Navigator.pop(
                                                                                            alertDialogContext);
                                                                                      },
                                                                                      child:
                                                                                          Container(
                                                                                        decoration:
                                                                                            BoxDecoration(
                                                                                          color: Tema.of(
                                                                                                  context)
                                                                                              .alternate,
                                                                                          borderRadius:
                                                                                              BorderRadius.circular(
                                                                                                  5),
                                                                                        ),
                                                                                        child:
                                                                                            Padding(
                                                                                          padding:
                                                                                              EdgeInsetsDirectional.all(
                                                                                                  5),
                                                                                          child:
                                                                                              Text(
                                                                                            'Sí, asistiré',
                                                                                            style: Tema.of(context).bodyText1.override(
                                                                                                fontFamily:
                                                                                                    'Nunito',
                                                                                                color:
                                                                                                    Tema.of(context).white),
                                                                                          ),
                                                                                        ),
                                                                                      )),
                                                                                ]),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons.loupe_outlined,
                                                                        color: Tema.of(context)
                                                                            .primaryColor,
                                                                      ),
                                                                      Padding(
                                                                          padding:
                                                                              EdgeInsetsDirectional
                                                                                  .only(start: 5),
                                                                          child: Text(
                                                                            'Asistiré',
                                                                            style: Tema.of(context)
                                                                                .bodyText1,
                                                                          ))
                                                                    ],
                                                                  ),
                                                                )
                                                              : Container(
                                                                  child: Text('Asistiré!'),
                                                                ),
                                                          Padding(
                                                              padding: EdgeInsetsDirectional.only(
                                                                  start: 10),
                                                              child: eventDetailsBloc.isInWishList
                                                                  ? Row(
                                                                      children: [
                                                                        IconButton(
                                                                            padding:
                                                                                EdgeInsets.all(0),
                                                                            onPressed: () {
                                                                              setState(() {
                                                                                eventDetailsBloc
                                                                                        .isInWishList =
                                                                                    false;
                                                                              });
                                                                              eventDetailsBloc
                                                                                  .deleteShowOnWishlist(
                                                                                      widget
                                                                                          .event.id
                                                                                          .toString());
                                                                            },
                                                                            icon: Icon(
                                                                                Icons.favorite)),
                                                                        Text(
                                                                            'Quitar de la Wishlist')
                                                                      ],
                                                                    )
                                                                  : Row(
                                                                      children: [
                                                                        IconButton(
                                                                            padding:
                                                                                EdgeInsets.all(3),
                                                                            onPressed: () async {
                                                                              setState(() {
                                                                                eventDetailsBloc
                                                                                        .isInWishList =
                                                                                    true;
                                                                              });

                                                                              eventDetailsBloc
                                                                                  .addShowOnWishlist(
                                                                                      widget
                                                                                          .event.id
                                                                                          .toString());
                                                                              await showDialog(
                                                                                context: context,
                                                                                builder:
                                                                                    (alertDialogContext) {
                                                                                  return AlertDialog(
                                                                                    title: Text(
                                                                                        '¿Quieres compartirlo con tus amigos?'),
                                                                                    content:
                                                                                        Container(
                                                                                            child:
                                                                                                Column(
                                                                                      mainAxisSize:
                                                                                          MainAxisSize
                                                                                              .min,
                                                                                      children: [
                                                                                        Text(
                                                                                          'Comparte para que tus amigos vean que estás interesado en asitir a este evento ;)',
                                                                                          style: Tema.of(context).subtitle1.override(
                                                                                              fontFamily:
                                                                                                  'Nunito',
                                                                                              color:
                                                                                                  Tema.of(context).primaryColor),
                                                                                        ),
                                                                                      ],
                                                                                    )),
                                                                                    actions: [
                                                                                      Row(
                                                                                          mainAxisAlignment:
                                                                                              MainAxisAlignment
                                                                                                  .spaceBetween,
                                                                                          children: [
                                                                                            TextButton(
                                                                                              onPressed:
                                                                                                  () async {
                                                                                                Navigator.pop(alertDialogContext);
                                                                                              },
                                                                                              child:
                                                                                                  Text('No'),
                                                                                            ),
                                                                                            TextButton(
                                                                                                onPressed:
                                                                                                    () async {
                                                                                                  eventDetailsBloc.newEventPost(widget.event.id.toString(), true);
                                                                                                  Navigator.pop(alertDialogContext);
                                                                                                },
                                                                                                child:
                                                                                                    Container(
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: Tema.of(context).alternate,
                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                  ),
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsetsDirectional.all(5),
                                                                                                    child: Text(
                                                                                                      'Sí, compartir',
                                                                                                      style: Tema.of(context).bodyText1.override(fontFamily: 'Nunito', color: Tema.of(context).white),
                                                                                                    ),
                                                                                                  ),
                                                                                                )),
                                                                                          ]),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                            icon: Icon(Icons
                                                                                .favorite_border_outlined)),
                                                                        Text('Añadir a la Wishlist')
                                                                      ],
                                                                    )),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ]),
                                            ),
                                            FutureBuilder<List<UserRecord>>(
                                                future: eventDetailsBloc
                                                    .friendsWishlist(widget.event.id.toString()),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<List<UserRecord>> snapshot) {
                                                  if (snapshot.hasData) {
                                                    final friends = snapshot.data;
                                                    return Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                              10, 10, 0, 0),
                                                          child: Text(
                                                            'Amigos con este concierto en su Wishlist:',
                                                            style: Tema.of(context).subtitle3,
                                                          ),
                                                        ),
                                                        friends != null
                                                            ? ListView.builder(
                                                                padding: EdgeInsets.zero,
                                                                scrollDirection: Axis.vertical,
                                                                shrinkWrap: true,
                                                                itemCount: friends.length,
                                                                itemBuilder:
                                                                    (context, listViewIndex) {
                                                                  final friend =
                                                                      friends[listViewIndex];
                                                                  return Padding(
                                                                      padding:
                                                                          EdgeInsetsDirectional.all(
                                                                              10),
                                                                      child: InkWell(
                                                                          onTap: () async {
                                                                            await Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) =>
                                                                                    BlocProvider(
                                                                                        child: OtherProfileWidget(
                                                                                            user:
                                                                                                friend),
                                                                                        bloc:
                                                                                            ProfileBloc()),
                                                                              ),
                                                                            );
                                                                          },
                                                                          child: Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Container(
                                                                                  decoration: BoxDecoration(
                                                                                      color: Tema.of(
                                                                                              context)
                                                                                          .white,
                                                                                      borderRadius:
                                                                                          BorderRadius
                                                                                              .circular(
                                                                                                  10)),
                                                                                  child: Row(
                                                                                    mainAxisSize:
                                                                                        MainAxisSize
                                                                                            .min,
                                                                                    children: [
                                                                                      Padding(
                                                                                          padding: EdgeInsetsDirectional
                                                                                              .fromSTEB(
                                                                                                  10,
                                                                                                  10,
                                                                                                  10,
                                                                                                  10),
                                                                                          child:
                                                                                              ClipRRect(
                                                                                            borderRadius:
                                                                                                BorderRadius.circular(10),
                                                                                            child:
                                                                                                CachedNetworkImage(
                                                                                              imageUrl:
                                                                                                  friend.avatarUrl ?? '',
                                                                                              width:
                                                                                                  50,
                                                                                              height:
                                                                                                  50,
                                                                                              fit: BoxFit
                                                                                                  .cover,
                                                                                              placeholder: (context, url) =>
                                                                                                  const CircularProgressIndicator(),
                                                                                              errorWidget: (context, url, error) =>
                                                                                                  const Icon(Icons.question_mark),
                                                                                            ),
                                                                                          )),
                                                                                      SizedBox(
                                                                                        width: 200,
                                                                                        child: Text(
                                                                                            friend
                                                                                                .name!,
                                                                                            style: Tema.of(context)
                                                                                                .title3),
                                                                                      ),
                                                                                    ],
                                                                                  ))
                                                                            ],
                                                                          )));
                                                                },
                                                              )
                                                            : Container()
                                                      ],
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                })
                                          ],
                                        );
                                      } else {
                                        return Text('No info');
                                      }
                                    }
                                  },
                                ))));
            }
          } else {
            if (snapshot.hasError && data == null) {
              return Text('No hay posts');
            } else {
              return CircularProgressIndicator();
            }
          }
        });
  }

  Future<Artist>? getArtist() async {
    final result = await eventDetailsBloc.searchArtist(widget.event.lineUp[0]);
    if (result != null) {
      return result[0];
    } else {
      throw Exception('Mo encontrado');
    }
  }
}
