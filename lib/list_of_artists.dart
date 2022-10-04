import 'package:cached_network_image/cached_network_image.dart';
import 'package:diatribapp/blocs/artist_bloc.dart';
import 'package:diatribapp/tema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import 'models/Artist.dart';

class ListOfArtistsWidget extends StatefulWidget {
  const ListOfArtistsWidget({Key? key, required this.artists, required this.title})
      : super(key: key);

  final List<String> artists;
  final String title;

  @override
  _ListOfArtistsWidgetState createState() => _ListOfArtistsWidgetState();
}

class _ListOfArtistsWidgetState extends State<ListOfArtistsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late ArtistBloc artistBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    artistBloc = BlocProvider.of<ArtistBloc>(context);
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
            itemCount: widget.artists.length,
            itemBuilder: (context, index) {
              return FutureBuilder<Artist>(
                future: artistBloc.getArtist(widget.artists[index]),
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
                  Artist? artist = snapshot.data;
                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: Container(
                        width: double.infinity,
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
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  GestureDetector(
                                    onTap: () async {},
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Tema.of(context).alternate,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: Image.asset(
                                            'assets/images/user.png',
                                          ).image,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: Image.asset(
                                              'assets/images/user.png',
                                              width: 56,
                                              height: 56,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          artist!.image != null
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(50),
                                                  child: CachedNetworkImage(
                                                    imageUrl: artist.image!,
                                                    width: 56,
                                                    height: 56,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) =>
                                                        new CircularProgressIndicator(),
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius: BorderRadius.circular(50),
                                                  child: Image.asset(
                                                    'assets/images/user.png',
                                                    width: 56,
                                                    height: 56,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          artist.name,
                                          style: Tema.of(context).title3.override(
                                                fontFamily: 'Nunito',
                                                fontSize: 24,
                                              ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          )),
    );
  }
}
