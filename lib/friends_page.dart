import 'package:cached_network_image/cached_network_image.dart';
import 'package:diatribapp/blocs/profile_bloc.dart';
import 'package:diatribapp/models/user_record.dart';
import 'package:diatribapp/profile/other_profile_page.dart';
import 'package:diatribapp/tema.dart';
import 'package:diatribapp/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendsPageWidget extends StatefulWidget {
  const FriendsPageWidget({Key? key, required this.bloc}) : super(key: key);

  final ProfileBloc bloc;

  @override
  _FriendsPageWidgetState createState() => _FriendsPageWidgetState();
}

class _FriendsPageWidgetState extends State<FriendsPageWidget> {
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
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              TextEditingController controller = TextEditingController();
              await showDialog(
                context: context,
                builder: (alertDialogContext) {
                  String? searchKey;
                  return AlertDialog(
                    title: Text('Buscar usuario'),
                    content: StatefulBuilder(
                        // You need this, notice the parameters below:
                        builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.only(top: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: Tema.of(context).turquesa,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    controller: controller,
                                    decoration: const InputDecoration(
                                      label: Center(
                                        child: Text(
                                          'ID o Nombre de Usuario',
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        searchKey = value;
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                    width: 250,
                                    height: 500,
                                    child: StreamBuilder<List<UserRecord?>>(
                                      stream: widget.bloc.getAllUsers(),
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
                                        if (searchKey != null) {
                                          if (snapshot.data != null && searchKey!.length >= 3) {
                                            List<UserRecord?> users = snapshot.data!;
                                            users = users
                                                .where((user) =>
                                                    user!.reference.id.contains(searchKey ?? '') ||
                                                    user.name!.contains(searchKey ?? ''))
                                                .toList();
                                            users = users
                                                .where((user) =>
                                                    user!.reference !=
                                                    currentUserDocument!.reference)
                                                .toList();
                                            return ListView.builder(
                                              itemCount: users.length,
                                              itemBuilder: (context, index) {
                                                if (users.isNotEmpty) {
                                                  return Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                          10, 10, 10, 10),
                                                      child: InkWell(
                                                        onTap: () async {
                                                          await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  OtherProfileWidget(
                                                                user: users[index]!,
                                                                bloc: widget.bloc,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                              color: Tema.of(context).white,
                                                              boxShadow: const [
                                                                BoxShadow(
                                                                  blurRadius: 0,
                                                                  color: Color(0xFFDBE2E7),
                                                                  offset: Offset(0, 2),
                                                                )
                                                              ],
                                                              borderRadius:
                                                                  BorderRadius.circular(10),
                                                            ),
                                                            padding: EdgeInsetsDirectional.all(10),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.circular(8),
                                                                  child: CachedNetworkImage(
                                                                    imageUrl: users[index]!.avatarUrl ?? '',
                                                                    width: 80,
                                                                    height: 80,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(10, 0, 0, 0),
                                                                    child: Text(
                                                                      users[index]?.name != null
                                                                          ? users[index]!.name!
                                                                          : '',
                                                                      style:
                                                                          Tema.of(context).title1,
                                                                    ))
                                                              ],
                                                            )),
                                                      ));
                                                } else {
                                                  return Text('No hay usuarios');
                                                }
                                              },
                                            );
                                          } else {
                                            return Text('No hay usuarios');
                                          }
                                        } else {
                                          return Container();
                                        }
                                      },
                                    )),
                              ],
                            ),
                          )
                        ],
                      );
                    }),
                    actions: [
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(alertDialogContext);
                          },
                          child: Text('Cancelar'),
                        ),
                      ]),
                    ],
                  );
                },
              );
            },
            backgroundColor: Tema.of(context).primaryColor,
            elevation: 8,
            label: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.search,
                  color: Tema.of(context).white,
                  size: 30,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                  child: Text(
                    'Buscar usuario',
                    style: Tema.of(context).subtitle1.override(
                          fontFamily: 'Nunito',
                          color: Tema.of(context).white,
                        ),
                  ),
                ),
              ],
            ),
          ),
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
              'Amigos',
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
            itemCount: currentUserDocument!.friends?.length,
            itemBuilder: (context, index) {
              final friend = currentUserDocument!.friends![index];
              return StreamBuilder<UserRecord>(
                stream: UserRecord.getDocument(friend),
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
                  UserRecord? user = snapshot.data;
                  return Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtherProfileWidget(
                                user: user!,
                                bloc: widget.bloc,
                              ),
                            ),
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: Tema.of(context).white,
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 0,
                                  color: Color(0xFFDBE2E7),
                                  offset: Offset(0, 2),
                                )
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsetsDirectional.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: user!.avatarUrl ?? '',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                    child: Text(
                                      user.name != null ? user.name! : '',
                                      style: Tema.of(context).title1,
                                    ))
                              ],
                            )),
                      ));
                },
              );
            },
          )),
    );
  }
}
