import 'package:cached_network_image/cached_network_image.dart';
import 'package:diatribapp/tema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Song.dart';

class SongWidget extends StatefulWidget {
  const SongWidget({Key? key, required this.song, this.onPressed}) : super(key: key);

  final Song song;
  final Function? onPressed;

  @override
  _SongWidgetState createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final Image noImage = Image.asset("assets/images/icono.png");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 5),
        child: Container(
          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Tema.of(context).white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                blurRadius: 2,
                color: Color(0xFFDBE2E7),
                offset: Offset(0, 2),
              )
            ],
          ),
          child: InkWell(
            onTap: () async {
              if (widget.onPressed != null) {
                widget.onPressed!();
              }
            },
            child: Row(
              children: [
                widget.song.albumImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: widget.song.albumImage,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => new CircularProgressIndicator(),
                          errorWidget: (context, error, stackTrace) => noImage,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Icon(Icons.question_mark),
                      ),
                Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 250,
                          child: Text(
                            widget.song.name,
                            style: Tema.of(context).subtitle1,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 250,
                              child: Text(
                                getArtistsString(),
                                style: Tema.of(context).bodyText1.override(
                                    fontFamily: 'Nunito', color: Tema.of(context).secondaryText),
                              ),
                            )
                          ],
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
  String getArtistsString() {
    String artistsString = '';
    int index = 0;
    for (var artist in widget.song.artists) {
      artistsString = artistsString + artist.name;
      if (index + 1 < widget.song.artists.length) {
        artistsString = artistsString + ', ';
      }
      ++index;
    }
    return artistsString;
  }
}
