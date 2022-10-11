import 'package:cached_network_image/cached_network_image.dart';
import 'package:diatribapp/models/chat_messages_record.dart';
import 'package:diatribapp/models/user_record.dart';
import 'package:diatribapp/tema.dart';
import 'package:diatribapp/util.dart';
import 'package:diatribapp/widgets/song_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'blocs/chat_bloc.dart';
import 'models/Song.dart';
import 'models/chat_record.dart';

class ChatPageWidget extends StatefulWidget {
  const ChatPageWidget({Key? key, required this.chat, required this.user, this.bloc}) : super(key: key);

  final ChatRecord chat;
  final UserRecord user;
  final ChatBloc? bloc;

  @override
  _ChatPageWidgetState createState() => _ChatPageWidgetState();
}

class _ChatPageWidgetState extends State<ChatPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late ChatBloc chatBloc;
  TextEditingController messageController = TextEditingController(text: '');
  String messageComment = '';

  ScrollController controller = ScrollController(initialScrollOffset: 10000);

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    chatBloc = widget.bloc ?? BlocProvider.of<ChatBloc>(context);
    return MaterialApp(
        home: Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(0xFFF1F4F8),
            appBar: AppBar(
              backgroundColor: Tema.of(context).secondaryColor,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Tema.of(context).primaryColor,
                  size: 30,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                widget.user.name!,
                style: Tema.of(context).title2.override(
                      fontFamily: 'Nunito',
                      color: Tema.of(context).primaryColor,
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
                Expanded(
                  child: StreamBuilder<List<ChatMessagesRecord?>>(
                    stream: chatBloc.getMessages(widget.chat.reference),
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
                      } else {
                        final messages = snapshot.data;
                        return ListView.builder(
                          itemCount: messages?.length,
                          shrinkWrap: true,
                          reverse: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final message = messages![index];
                            return FutureBuilder<Song>(
                                future: chatBloc.getSong(message!.song),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final song = snapshot.data;
                                    return Column(
                                      children: [
                                        message.from == currentUserDocument!.reference
                                            ? Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  10, 10, 10, 0),
                                              child: Text(
                                                timeago.format(message.time, locale: 'es'),
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(
                                                    10, 10, 10, 0),
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                      currentUserDocument!.avatarUrl ??
                                                          '',
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                    )))
                                          ],
                                        )
                                            : Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(
                                                      10, 10, 10, 0),
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: CachedNetworkImage(
                                                        imageUrl: widget.user.avatarUrl ?? '',
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                      ))),
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(
                                                    10, 10, 10, 0),
                                                child: Text(
                                                  timeago.format(message.time, locale: 'es'),
                                                ),
                                              ),
                                            ]),
                                        Padding(
                                            padding: message.from == currentUserDocument!.reference
                                                ? EdgeInsetsDirectional.fromSTEB(50, 2, 10, 10)
                                                : EdgeInsetsDirectional.fromSTEB(10, 2, 50, 10),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Tema.of(context).primaryColor,
                                                  borderRadius: BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 0,
                                                      color: Color(0xFFDBE2E7),
                                                      offset: Offset(0, 2),
                                                    )
                                                  ],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: message.from == currentUserDocument!.reference
                                                      ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:  message.from == currentUserDocument!.reference
                                                          ? EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0)
                                                          : EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                                      child: SongWidget(song: song!),
                                                    ),
                                                    message.comment != null ?
                                                    Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(15, 10, 15, 15),
                                                        child: Text(message.comment!,
                                                          style: Tema.of(context).subtitle3.override(
                                                              fontFamily: 'Nunito',
                                                              color: Tema.of(context).white
                                                          ),)
                                                    ) : Container()
                                                  ],
                                                )
                                            )
                                        )
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                });
                          },
                        );
                      }
                    },
                  )
                ),
                InkWell(
                    child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                      onTap: () async {
                        TextEditingController searchController = TextEditingController();
                        List<Song> songsResult = [];
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return StatefulBuilder(builder: (context, setState) {
                              return AlertDialog(
                                title: Text('Enviar canción'),
                                content: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 500,
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: 230,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional.fromSTEB(10, 0, 20, 0),
                                                    child: TextField(
                                                      controller: searchController,
                                                      decoration: InputDecoration(
                                                        labelText: 'Busca una canción',
                                                        labelStyle:
                                                            Tema.of(context).bodyText1.override(
                                                                  fontFamily: 'Lexend Deca',
                                                                  color: Color(0xFF95A1AC),
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.normal,
                                                                ),
                                                        hintText: 'Busca una canción...',
                                                      ),
                                                      onSubmitted: (value) {
                                                        if(value.length >= 3) {
                                                          setState(() async {
                                                            songsResult =
                                                                await chatBloc.searchSong(value) ??
                                                                    [];
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          searchController.value.text.length < 3
                                              ? Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  decoration: BoxDecoration(
                                                    color: Tema.of(context).primaryColor,
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(
                                                        10, 7, 10, 7),
                                                    child: Text(
                                                      'Tus canciones más escuchadas el último mes',
                                                      style: Tema.of(context).subtitle2.override(
                                                          fontFamily: 'Nunito',
                                                          color: Tema.of(context).white),
                                                    ),
                                                  ))
                                              : Container()
                                        ],
                                      ),
                                      Expanded(
                                          child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            searchController.value.text.length >= 3
                                                ? ListView.builder(
                                                    scrollDirection: Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount: songsResult.length,
                                                    itemBuilder: (context, index) {
                                                      return SongWidget(
                                                          song: songsResult[index],
                                                          onPressed: () async {
                                                            await showDialog(
                                                              context: context,
                                                              builder: (alertDialogContext) {
                                                                return AlertDialog(
                                                                  title:
                                                                      Text('Enviar esta canción'),
                                                                  content: Container(
                                                                      child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      CachedNetworkImage(
                                                                        imageUrl: songsResult[index]
                                                                            .albumImage,
                                                                        width: 200,
                                                                        height: 200,
                                                                        fit: BoxFit.cover,
                                                                        placeholder: (context,
                                                                                url) =>
                                                                            new CircularProgressIndicator(),
                                                                      ),
                                                                      Text(
                                                                        songsResult[index].name,
                                                                        style: Tema.of(context)
                                                                            .title3
                                                                            .override(
                                                                                fontFamily:
                                                                                    'Nunito',
                                                                                color: Tema.of(
                                                                                        context)
                                                                                    .primaryColor),
                                                                      ),
                                                                      Text(
                                                                        songsResult[index]
                                                                            .artists
                                                                            .first
                                                                            .name,
                                                                        style: Tema.of(context)
                                                                            .subtitle1
                                                                            .override(
                                                                                fontFamily:
                                                                                    'Nunito',
                                                                                color:
                                                                                    Tema.of(context)
                                                                                        .alternate),
                                                                      ),
                                                                      TextField(
                                                                        controller: messageController,
                                                                        decoration: const InputDecoration(
                                                                          labelText: 'Comentario',
                                                                          hintText: 'Introduce algún comentario...',
                                                                        ),
                                                                        maxLines: 2,
                                                                        onChanged: (String value) => setState(() {
                                                                          messageComment = value;
                                                                        }),
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
                                                                            onPressed: () async {
                                                                              Navigator.pop(
                                                                                  alertDialogContext);
                                                                            },
                                                                            child: Text('Cancelar'),
                                                                          ),
                                                                          TextButton(
                                                                              onPressed: () async {
                                                                                chatBloc.newChatMessage(
                                                                                    currentUserDocument!
                                                                                        .reference,
                                                                                    widget.user
                                                                                        .reference,
                                                                                    widget.chat
                                                                                        .reference,
                                                                                    songsResult[
                                                                                            index]
                                                                                        .id,
                                                                                messageComment);
                                                                                setState(() {
                                                                                  messageComment = '';
                                                                                });
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
                                                                                          .all(5),
                                                                                  child: Text(
                                                                                    'Enviar',
                                                                                    style: Tema.of(
                                                                                            context)
                                                                                        .bodyText1
                                                                                        .override(
                                                                                            fontFamily:
                                                                                                'Nunito',
                                                                                            color: Tema.of(context)
                                                                                                .white),
                                                                                  ),
                                                                                ),
                                                                              )),
                                                                        ]),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                            Navigator.pop(alertDialogContext);
                                                          });
                                                    },
                                                  )
                                                : FutureBuilder<List<Song>>(
                                                    future: chatBloc.getTopSongsShort(),
                                                    builder: (context, snapshot) {
                                                      final songs = snapshot.data;
                                                      if (songs != null) {
                                                        return Column(
                                                          children: [
                                                            ListView.builder(
                                                              scrollDirection: Axis.vertical,
                                                              shrinkWrap: true,
                                                              itemCount: songs.length,
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              itemBuilder: (context, index) {
                                                                return SongWidget(
                                                                    song: songs[index],
                                                                    onPressed: () async {
                                                                      int index2 = 0;
                                                                      String artistsString = '';
                                                                      for (var artist
                                                                          in songs[index].artists) {
                                                                        artistsString =
                                                                            artistsString +
                                                                                artist.name;
                                                                        if (index2 + 1 <
                                                                            songs[index]
                                                                                .artists
                                                                                .length) {
                                                                          artistsString =
                                                                              artistsString + ', ';
                                                                        }
                                                                        ++index2;
                                                                      }
                                                                      await showDialog(
                                                                        context: context,
                                                                        builder:
                                                                            (alertDialogContext) {
                                                                          return AlertDialog(
                                                                            title: Text(
                                                                                'Enviar esta canción'),
                                                                            content: Container(
                                                                                child: Column(
                                                                              mainAxisSize:
                                                                                  MainAxisSize.min,
                                                                              children: [
                                                                                CachedNetworkImage(
                                                                                  imageUrl: songs[
                                                                                          index]
                                                                                      .albumImage,
                                                                                  width: 200,
                                                                                  height: 200,
                                                                                  fit: BoxFit.cover,
                                                                                  placeholder: (context,
                                                                                          url) =>
                                                                                      new CircularProgressIndicator(),
                                                                                ),
                                                                                Padding(
                                                                                    padding:
                                                                                        EdgeInsetsDirectional
                                                                                            .all(5),
                                                                                    child: Text(
                                                                                      songs[index]
                                                                                          .name,
                                                                                      style: Tema.of(
                                                                                              context)
                                                                                          .title3
                                                                                          .override(
                                                                                              fontFamily:
                                                                                                  'Nunito',
                                                                                              color:
                                                                                                  Tema.of(context).primaryColor),
                                                                                    )),
                                                                                Text(
                                                                                  artistsString,
                                                                                  style: Tema.of(
                                                                                          context)
                                                                                      .subtitle1
                                                                                      .override(
                                                                                          fontFamily:
                                                                                              'Nunito',
                                                                                          color: Tema.of(
                                                                                                  context)
                                                                                              .alternate),
                                                                                ),
                                                                                TextField(
                                                                                  controller: messageController,
                                                                                  decoration: const InputDecoration(
                                                                                    labelText: 'Comentario',
                                                                                    hintText: 'Introduce algún comentario...',
                                                                                  ),
                                                                                  maxLines: 2,
                                                                                  onChanged: (String value) => setState(() {
                                                                                    messageComment = value;
                                                                                  }),
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
                                                                                        Navigator.pop(
                                                                                            alertDialogContext);
                                                                                      },
                                                                                      child: Text(
                                                                                          'Cancelar'),
                                                                                    ),
                                                                                    TextButton(
                                                                                        onPressed:
                                                                                            () async {
                                                                                          chatBloc.newChatMessage(
                                                                                              currentUserDocument!
                                                                                                  .reference,
                                                                                              widget
                                                                                                  .user
                                                                                                  .reference,
                                                                                              widget
                                                                                                  .chat
                                                                                                  .reference,
                                                                                              songs[index]
                                                                                                  .id,
                                                                                              messageComment);
                                                                                          setState(() {
                                                                                            messageComment = '';
                                                                                          });
                                                                                          Navigator.pop(
                                                                                              alertDialogContext);
                                                                                        },
                                                                                        child:
                                                                                            Container(
                                                                                          decoration:
                                                                                              BoxDecoration(
                                                                                            color: Tema.of(context)
                                                                                                .alternate,
                                                                                            borderRadius:
                                                                                                BorderRadius.circular(5),
                                                                                          ),
                                                                                          child:
                                                                                              Padding(
                                                                                            padding:
                                                                                                EdgeInsetsDirectional.all(5),
                                                                                            child:
                                                                                                Text(
                                                                                              'Enviar',
                                                                                              style: Tema.of(context).subtitle2.override(
                                                                                                  fontFamily: 'Nunito',
                                                                                                  color: Tema.of(context).white),
                                                                                            ),
                                                                                          ),
                                                                                        )),
                                                                                  ]),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    });
                                                              },
                                                            )
                                                          ],
                                                        );
                                                      } else {
                                                        return Container(
                                                          child: Text('No hay canciones'),
                                                        );
                                                      }
                                                    }),
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                                actions: [],
                              );
                            });
                          },
                        );
                        setState(() {
                          controller.animateTo(
                            controller.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 1),
                            curve: Curves.easeOut,
                          );
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Tema.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsetsDirectional.all(15),
                        child: Text('Enviar canción', style: Tema.of(context).subtitle2),
                      )),
                ))
              ],
            ))));
  }
}
