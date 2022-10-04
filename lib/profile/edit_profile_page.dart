import 'package:cached_network_image/cached_network_image.dart';
import 'package:diatribapp/tema.dart';
import 'package:diatribapp/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../blocs/profile_bloc.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({Key? key, required this.bloc}) : super(key: key);

  final ProfileBloc bloc;

  @override
  _EditProfileWidgetState createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController instagramController = TextEditingController();

  String? instagram;

  @override
  void initState() {
    super.initState();
    if (currentUserDocument?.instagramUrl != null) {
      instagramController = TextEditingController(text: currentUserDocument!.instagramUrl!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
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
            'Editar perfil',
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
        backgroundColor: Color(0xFFF1F4F8),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Tema.of(context).primaryColor,
                border: Border(
                  bottom: BorderSide(width: 2.0, color: Tema.of(context).secondaryColor),
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 0, 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: Tema.of(context).secondaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                          child: InkWell(
                            onTap: () async {},
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: currentUserDocument!.avatarUrl ?? '',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser!.name,
                              style: Tema.of(context).title3.override(
                                    fontFamily: 'Montserrat',
                                    color: Tema.of(context).turquesa,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Instagram Link',
                      style: Tema.of(context).subtitle1,
                    ),
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: TextField(
                                  controller: instagramController,
                                  decoration: InputDecoration(
                                    hintText: 'Instagram',
                                    hintStyle: Tema.of(context).bodyText1.override(
                                          fontFamily: 'Nunito',
                                          color: Color(0xFF95A1AC),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Tema.of(context).softBlue,
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Tema.of(context).primaryColor,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    filled: true,
                                    fillColor: Tema.of(context).white,
                                    contentPadding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      instagram = value;
                                    });
                                  }),
                            ),
                          ],
                        )),
                    InkWell(
                        onTap: () {
                          if (instagram != null) {
                            widget.bloc.updateInstagramUrl(instagram!);
                          }
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Tema.of(context).alternate,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Text(
                            'Guardar cambios',
                            style: Tema.of(context).subtitle3,
                          ),
                        )),
                  ],
                ),
              ),
            ])))
          ],
        ),
      ),
    );
  }
}
