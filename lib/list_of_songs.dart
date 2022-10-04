import 'package:diatribapp/tema.dart';
import 'package:diatribapp/widgets/song_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/Song.dart';

class ListOfSongsWidget extends StatefulWidget {
  const ListOfSongsWidget({Key? key, required this.songs, required this.title}) : super(key: key);

  final List<Song> songs;
  final String title;

  @override
  _ListOfSongsWidgetState createState() => _ListOfSongsWidgetState();
}

class _ListOfSongsWidgetState extends State<ListOfSongsWidget> {
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
            itemCount: widget.songs.length,
            itemBuilder: (context, index) {
              return SongWidget(song: widget.songs[index], onPressed: () {});
            },
          )),
    );
  }
}
