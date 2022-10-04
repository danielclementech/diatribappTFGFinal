import 'package:cached_network_image/cached_network_image.dart';
import 'package:diatribapp/models/post_record.dart';
import 'package:diatribapp/tema.dart';
import 'package:diatribapp/util.dart';
import 'package:diatribapp/widgets/user_post_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import '../artist_page.dart';
import '../blocs/artist_bloc.dart';
import '../blocs/song_bloc.dart';
import '../blocs/user_bloc.dart';
import '../models/Song.dart';

class SongPostWidget extends StatefulWidget {
  const SongPostWidget({
    Key? key,
    required this.post,
    this.function,
  }) : super(key: key);

  final PostRecord post;
  final Function? function;

  @override
  _SongPostWidgetState createState() => _SongPostWidgetState();
}

class _SongPostWidgetState extends State<SongPostWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLiked = false;
  int likes = 0;

  late SongBloc songBloc;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.likes!.contains(currentUserReference);
    likes = widget.post.likes?.length ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    songBloc = BlocProvider.of<SongBloc>(context);
    return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Tema.of(context).white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              setState(() {});
            },
            child: Column(
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
                            padding: EdgeInsetsDirectional.fromSTEB(5, 5, 10, 5),
                            child: Text(timeago.format(widget.post.fecha!, locale: 'es'),
                                style: Tema.of(context).bodyText1)),
                      ],
                    )),
                Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Tema.of(context).secondaryColor.withOpacity(0.5),
                          Tema.of(context).secondaryColor.withOpacity(0.8),
                        ],
                        stops: [0, 1],
                        begin: AlignmentDirectional(0, -1),
                        end: AlignmentDirectional(0, 1),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FutureBuilder<Song>(
                      future: songBloc.getSong(widget.post.song!),
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
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(15, 10, 0, 5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: song!.albumImage,
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
                                        final artists =
                                            await songBloc.searchArtist(song.artists[0].name) ?? [];
                                        final id = await songBloc.getArtistId(artists[0].name);
                                        if (id != null) {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => BlocProvider(
                                                    child: ArtistWidget(artist: artists[0], id: id),
                                                    bloc: ArtistBloc())),
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Tema.of(context).white,
                                          borderRadius:
                                              BorderRadius.horizontal(right: Radius.circular(5)),
                                        ),
                                        child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                                            child: Text(song.artists.first.name,
                                                style: Tema.of(context).subtitle1)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(15, 15, 10, 5),
                                      child: SizedBox(
                                        width: 180,
                                        child: Text(song.name, style: Tema.of(context).title1),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            widget.post.comment != null && widget.post.comment!.isNotEmpty
                                ? Row(
                                    children: [
                                      Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(15, 10, 10, 0),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Tema.of(context).white,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(
                                                      10, 10, 10, 10),
                                                  child: Text(widget.post.comment!))))
                                    ],
                                  )
                                : Container(),
                            Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(15, 10, 10, 15),
                                child: InkWell(
                                  onTap: () {
                                    if (song.spotifyUrl != null) {
                                      launchUrl(Uri.parse('spotify:track:' + song.id));
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Tema.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              'assets/images/spotify.png',
                                              width: 20,
                                            ),
                                            Text('  ABRIR EN SPOTIFY',
                                                style: Tema.of(context).subtitle2.override(
                                                    fontFamily: 'Nunito',
                                                    color: Tema.of(context).spotifyColor))
                                          ],
                                        )),
                                  ),
                                ))
                          ],
                        );
                      },
                    )),
                Container(
                    decoration: BoxDecoration(
                      color: Tema.of(context).white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        isLiked
                            ? Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isLiked = false;
                                          --likes;
                                        });
                                        if (widget.function != null) {
                                          widget.function!();
                                        }
                                        songBloc.unlikeASongPost(widget.post.reference);
                                      },
                                      icon: Icon(Icons.favorite))
                                ],
                              )
                            : Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isLiked = true;
                                          ++likes;
                                        });
                                        if (widget.function != null) {
                                          widget.function!();
                                        }

                                        songBloc.likeASongPost(widget.post.reference);
                                      },
                                      icon: Icon(Icons.favorite_border_outlined))
                                ],
                              ),
                        Text((widget.post.likes != null
                            ? widget.post.likes!.length.toString()
                            : '0'))
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}
