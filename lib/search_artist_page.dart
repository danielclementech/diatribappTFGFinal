import 'package:cached_network_image/cached_network_image.dart';
import 'package:diatribapp/artist_page.dart';
import 'package:diatribapp/tema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import 'blocs/artist_bloc.dart';
import 'models/Artist.dart';

class SearchArtistWidget extends StatefulWidget {
  const SearchArtistWidget({Key? key}) : super(key: key);

  @override
  _SearchArtistWidgetState createState() => _SearchArtistWidgetState();
}

class _SearchArtistWidgetState extends State<SearchArtistWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late TextEditingController searchController;
  List<Artist> artistsResult = [];

  late ArtistBloc artistBloc;

  @override
  void initState() {
    searchController = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    artistBloc = BlocProvider.of<ArtistBloc>(context);
    return MaterialApp(
        home: Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(0xFFF1F4F8),
            appBar: AppBar(
              backgroundColor: Tema.of(context).primaryColor,
              automaticallyImplyLeading: false,
              title: Text(
                'Buscar artista',
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            labelText: 'Buscar',
                            labelStyle: Tema.of(context).bodyText1.override(
                                  fontFamily: 'Lexend Deca',
                                  color: Color(0xFF95A1AC),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                            hintText: 'Busca un artista...',
                          ),
                          onChanged: (value) async {
                            final artists = await artistBloc.searchArtist(value) ?? [];
                            setState(() {
                              artistsResult = artists;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                              primary: true,
                              child: searchController.value.text.length >= 3
                                  ? ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: artistsResult.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            final id = await artistBloc
                                                .getArtistId(artistsResult[index].name);
                                            if (id != null) {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => BlocProvider(
                                                        child: ArtistWidget(
                                                            artist: artistsResult[index], id: id),
                                                        bloc: ArtistBloc())),
                                              );
                                            }
                                          },
                                          child: ListTile(
                                            leading: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: Image.asset(
                                                    'assets/images/user.png',
                                                    width: 56,
                                                    height: 56,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                artistsResult[index].image != null
                                                    ? ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: CachedNetworkImage(
                                                          imageUrl: artistsResult[index].image!,
                                                          width: 56,
                                                          height: 56,
                                                          fit: BoxFit.cover,
                                                          placeholder: (context, url) =>
                                                              new CircularProgressIndicator(),
                                                        ),
                                                      )
                                                    : ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: Image.asset(
                                                          'assets/images/user.png',
                                                          width: 56,
                                                          height: 56,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                            title: Text(
                                              artistsResult[index].name,
                                              style: Tema.of(context).subtitle1.override(
                                                  fontFamily: 'Nunito',
                                                  color: Tema.of(context).primaryColor),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Container())),
                    ],
                  )
                ],
              ),
            )));
  }
}
