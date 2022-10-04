import 'package:cached_network_image/cached_network_image.dart';
import 'package:diatribapp/tema.dart';
import 'package:diatribapp/widgets/song_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import 'blocs/user_bloc.dart';
import 'models/Song.dart';

class PostSongWidget extends StatefulWidget {
  const PostSongWidget({
    Key? key,
  }) : super(key: key);

  @override
  _PostSongWidgetState createState() => _PostSongWidgetState();
}

class _PostSongWidgetState extends State<PostSongWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late TextEditingController searchController;
  TextEditingController postController = TextEditingController(text: '');
  String descriptionPost = '';
  List<Song> songsResult = [];

  late UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
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
                'Comparte la canción',
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  labelText: 'Busca una canción',
                                  labelStyle: Tema.of(context).bodyText1.override(
                                        fontFamily: 'Lexend Deca',
                                        color: Color(0xFF95A1AC),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                  hintText: 'Busca una canción...',
                                ),
                                onChanged: (value) {
                                  if (value.length >= 3) {
                                    setState(() async {
                                      songsResult = await userBloc.searchSong(value) ?? [];
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
                              padding: EdgeInsetsDirectional.fromSTEB(10, 7, 10, 7),
                              child: Text(
                                'Tus canciones más escuchadas el último mes',
                                style: Tema.of(context)
                                    .subtitle2
                                    .override(fontFamily: 'Nunito', color: Tema.of(context).white),
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
                                            title: Text('Compartir esta canción'),
                                            content: Container(
                                                child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: songsResult[index].albumImage,
                                                  width: 200,
                                                  height: 200,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      new CircularProgressIndicator(),
                                                ),
                                                Text(
                                                  songsResult[index].name,
                                                  style: Tema.of(context).title3.override(
                                                      fontFamily: 'Nunito',
                                                      color: Tema.of(context).primaryColor),
                                                ),
                                                Text(
                                                  songsResult[index].artists.first.name,
                                                  style: Tema.of(context).subtitle1.override(
                                                      fontFamily: 'Nunito',
                                                      color: Tema.of(context).alternate),
                                                ),
                                                TextField(
                                                  controller: postController,
                                                  decoration: const InputDecoration(
                                                    labelText: 'Comentario',
                                                    hintText: 'Introduce algún comentario...',
                                                  ),
                                                  maxLines: 2,
                                                  onChanged: (String value) => setState(() {
                                                    descriptionPost = value;
                                                  }),
                                                ),
                                              ],
                                            )),
                                            actions: [
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          descriptionPost = '';
                                                        });
                                                        Navigator.pop(alertDialogContext);
                                                      },
                                                      child: Text('Cancelar'),
                                                    ),
                                                    TextButton(
                                                        onPressed: () async {
                                                          userBloc.newSongPost(
                                                              songsResult[index].id,
                                                              descriptionPost);
                                                          setState(() {
                                                            descriptionPost = '';
                                                          });
                                                          Navigator.pop(alertDialogContext);
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Tema.of(context).alternate,
                                                            borderRadius: BorderRadius.circular(5),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsetsDirectional.all(5),
                                                            child: Text(
                                                              'Publicar',
                                                              style: Tema.of(context)
                                                                  .bodyText1
                                                                  .override(
                                                                      fontFamily: 'Nunito',
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
                                    });
                              },
                            )
                          : FutureBuilder<List<Song>>(
                              future: userBloc.getTopSongsShort(),
                              builder: (context, snapshot) {
                                final songs = snapshot.data;
                                if (songs != null) {
                                  return Column(
                                    children: [
                                      ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: songs.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return SongWidget(
                                              song: songs[index],
                                              onPressed: () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (alertDialogContext) {
                                                    return AlertDialog(
                                                      title: Text('Compartir esta canción'),
                                                      content: Container(
                                                          child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl: songs[index].albumImage,
                                                            width: 200,
                                                            height: 200,
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) =>
                                                                new CircularProgressIndicator(),
                                                          ),
                                                          Padding(
                                                              padding: EdgeInsetsDirectional.all(5),
                                                              child: Text(
                                                                songs[index].name,
                                                                style: Tema.of(context)
                                                                    .title3
                                                                    .override(
                                                                        fontFamily: 'Nunito',
                                                                        color: Tema.of(context)
                                                                            .primaryColor),
                                                              )),
                                                          Text(
                                                            songs[index].artists.first.name,
                                                            style: Tema.of(context)
                                                                .subtitle1
                                                                .override(
                                                                    fontFamily: 'Nunito',
                                                                    color:
                                                                        Tema.of(context).alternate),
                                                          ),
                                                          TextField(
                                                            controller: postController,
                                                            decoration: const InputDecoration(
                                                              labelText: 'Comentario',
                                                              hintText:
                                                                  'Introduce algún comentario...',
                                                            ),
                                                            maxLines: 5,
                                                            onChanged: (String value) =>
                                                                setState(() {
                                                              descriptionPost = value;
                                                            }),
                                                          ),
                                                        ],
                                                      )),
                                                      actions: [
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              TextButton(
                                                                onPressed: () async {
                                                                  setState(() {
                                                                    descriptionPost = '';
                                                                  });
                                                                  Navigator.pop(alertDialogContext);
                                                                },
                                                                child: Text('Cancelar'),
                                                              ),
                                                              TextButton(
                                                                  onPressed: () async {
                                                                    userBloc.newSongPost(
                                                                        songs[index].id,
                                                                        descriptionPost);
                                                                    setState(() {
                                                                      descriptionPost = '';
                                                                    });
                                                                    Navigator.pop(
                                                                        alertDialogContext);
                                                                  },
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Tema.of(context)
                                                                          .alternate,
                                                                      borderRadius:
                                                                          BorderRadius.circular(5),
                                                                    ),
                                                                    child: Padding(
                                                                      padding:
                                                                          EdgeInsetsDirectional.all(
                                                                              5),
                                                                      child: Text(
                                                                        'Publicar',
                                                                        style: Tema.of(context)
                                                                            .subtitle2
                                                                            .override(
                                                                                fontFamily:
                                                                                    'Nunito',
                                                                                color:
                                                                                    Tema.of(context)
                                                                                        .white),
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
            )));
  }
}
