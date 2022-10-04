import 'package:diatribapp/models/friend_request_record.dart';
import 'package:diatribapp/services/firebase_services.dart';
import 'package:diatribapp/tema.dart';
import 'package:diatribapp/util.dart';
import 'package:flutter/material.dart';

import 'blocs/profile_bloc.dart';

class FriendRequestsWidget extends StatefulWidget {
  const FriendRequestsWidget({Key? key, required this.bloc}) : super(key: key);

  final ProfileBloc bloc;

  @override
  _FriendRequestsWidgetState createState() => _FriendRequestsWidgetState();
}

class _FriendRequestsWidgetState extends State<FriendRequestsWidget> {
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
                'Solicitudes de amistad',
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
            body: StreamBuilder<List<FriendRequestRecord?>>(
              stream: widget.bloc.getMyFriendRequests(),
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
                List<FriendRequestRecord?> list = snapshot.data!;
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: list.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, listViewIndex) {
                    final request = list[listViewIndex];
                    return Container(
                      decoration: BoxDecoration(
                        color: Tema.of(context).white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      padding: EdgeInsetsDirectional.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(request!.from.id, style: Tema.of(context).subtitle1,),
                          InkWell(
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder:
                              (alertDialogContext) {
                                return AlertDialog(
                                  title: Text(
                                      '¿Aceptas la solicitud?'),
                                  content: Container(
                                      child: Column(
                                        mainAxisSize:
                                        MainAxisSize.min,
                                        children: [
                                          Text(
                                            request.from.id + ' desea ser tu amig@',
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
                                                    widget.bloc.acceptFriendRequest(
                                                      request.reference, request.from,request.to);
                                                    Navigator.pop(alertDialogContext);
                                                    currentUserDocument = await FirebaseServices().getUser();
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
                                                    'Sí, aceptar',
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
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Tema.of(context).spotifyColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              padding: EdgeInsetsDirectional.all(10),
                              child: Icon(Icons.done, color: Tema.of(context).darkGreen,),
                            )
                          )
                        ],
                      )


                    );
                  },
                );
              },
            )));
  }
}
