import 'package:diatribapp/blocs/events_bloc.dart';
import 'package:diatribapp/models/Event.dart';
import 'package:diatribapp/tema.dart';
import 'package:diatribapp/widgets/shows_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class ShowsWishlistPageWidget extends StatefulWidget {
  const ShowsWishlistPageWidget({
    Key? key,
  }) : super(key: key);

  @override
  _ShowsWishlistPageWidgetState createState() => _ShowsWishlistPageWidgetState();
}

class _ShowsWishlistPageWidgetState extends State<ShowsWishlistPageWidget> {
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
              'Wishlist',
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
          body: FutureBuilder<List<Event>>(
              future: eventsBloc.getMyShowsWishlist(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  // while data is loading:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cargando shows...',
                        style: Tema.of(context).title3,
                      ),
                      Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: CircularProgressIndicator(
                            color: Tema.of(context).alternate,
                          ))
                    ],
                  );
                } else {
                  // data loaded:
                  List<Event>? shows = snapshot.data;
                  shows?.sort((a, b) => a.time.compareTo(b.time));
                  return ListView.builder(
                    itemCount: shows?.length,
                    itemBuilder: (context, index) {
                      final show = shows![index];
                      return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Tema.of(context).white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              generalInfoShow(show, context),
                              locationShow(show, context),
                              dateShow(show, context)
                            ]),
                          ));
                    },
                  );
                }
              })),
    );
  }
}
