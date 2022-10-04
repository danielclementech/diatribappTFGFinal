import 'package:diatribapp/tema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/Playlist.dart';

class OtherUserPlaylitstsWidget extends StatefulWidget {
  const OtherUserPlaylitstsWidget({
    Key? key,
    required this.playlists,
  }) : super(key: key);

  final List<Playlist>? playlists;

  @override
  _OtherUserPlaylitstsWidgetState createState() => _OtherUserPlaylitstsWidgetState();
}

class _OtherUserPlaylitstsWidgetState extends State<OtherUserPlaylitstsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        backgroundColor: Tema.of(context).primaryBackground,
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 1,
            decoration: BoxDecoration(
              color: Tema.of(context).primaryColor,
            ),
            alignment: AlignmentDirectional(0, 0),
            child: ListView.builder(
              itemCount: widget.playlists!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "myRoute");
                  },
                  child: ListTile(
                    title: Text(
                      widget.playlists![index].id + '_' + widget.playlists![index].name,
                      style: Tema.of(context)
                          .subtitle1
                          .override(fontFamily: 'Nunito', color: Tema.of(context).white),
                    ),
                    subtitle: Text(
                      widget.playlists![index].ownerId,
                      style: Tema.of(context)
                          .bodyText1
                          .override(fontFamily: 'Nunito', color: Tema.of(context).white),
                    ),
                  ),
                );
              },
            )),
      ),
    );
  }
}
