import 'dart:io';

import 'package:diatribapp/models/Event.dart';
import 'package:diatribapp/tema.dart';
import 'package:diatribapp/util.dart';
import 'package:diatribapp/widgets/shows_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:open_file/open_file.dart';

import 'blocs/events_bloc.dart';

class ShowslistPageWidget extends StatefulWidget {
  const ShowslistPageWidget({
    Key? key,
  }) : super(key: key);

  @override
  _ShowslistPageWidgetState createState() => _ShowslistPageWidgetState();
}

class _ShowslistPageWidgetState extends State<ShowslistPageWidget> {
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
              'Que nervios!',
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
          body: FutureBuilder<List<Map<String, dynamic>>>(
              future: eventsBloc.getMyShowsList(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  // while data is loading:
                  return Center(
                      child: Column(
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
                  ));
                } else {
                  // data loaded:
                  final shows = snapshot.data;
                  shows?.sort((a, b) => a['show'].time.compareTo(b['show'].time));
                  return ListView.builder(
                    itemCount: shows!.length,
                    itemBuilder: (context, index) {
                      Event show = shows[index]['show'];
                      return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Tema.of(context).white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                          child: Text(
                                            show.name,
                                            style: Tema.of(context).title3.override(
                                                fontFamily: 'Nunito',
                                                color: Tema.of(context).primaryColor),
                                          ))
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Tema.of(context).alternate,
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
                                        padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                                        child: Text(
                                          show.type.name,
                                          style: Tema.of(context).subtitle3,
                                        ),
                                      )),
                                ],
                              ),
                              locationShow(show, context),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  dateShow(show, context),
                                  shows[index]['ticket'] != null &&
                                          shows[index]['ticket'].isNotEmpty
                                      ? TextButton(
                                          onPressed: () async {
                                            String fileName = FirebaseStorage.instance
                                                .ref()
                                                .child(shows[index]['ticket'])
                                                .name;
                                            var array = fileName.split('?alt=');
                                            fileName = array.first;
                                            array = fileName.split('%2F');
                                            fileName = array.last;
                                            final file = await eventsBloc.downloadFile(
                                                shows[index]['ticket'], fileName);
                                            if (file == null) {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text('No has subido ticket'),
                                                    content: Text('Tonto'),
                                                    actions: [
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () async {
                                                                Navigator.pop(alertDialogContext);
                                                              },
                                                              child: Text('OK'),
                                                            ),
                                                          ]),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              OpenFile.open(file.path);
                                            }
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Tema.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.insert_drive_file_rounded,
                                                    color: Tema.of(context).white,
                                                    size: 20,
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                          5, 0, 0, 0),
                                                      child: Text(
                                                        'Ticket',
                                                        style: Tema.of(context).subtitle2.override(
                                                            fontFamily: 'Nunito',
                                                            color: Tema.of(context).white),
                                                      ))
                                                ],
                                              )),
                                        )
                                      : TextButton(
                                          onPressed: () async {
                                            FilePickerResult? result;
                                            String? downloadUrl;
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: Text('Sube tu ticket'),
                                                  content: Container(
                                                      child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'Para tener tus entradas accesibles desde la app, sube el archivo PDF de la entrada (tranquilo, tu entrada está protegida y no es accesible desde ningún otro usuario)',
                                                        style: Tema.of(context).subtitle1.override(
                                                            fontFamily: 'Nunito',
                                                            color: Tema.of(context).primaryColor),
                                                      ),
                                                      TextButton(
                                                          onPressed: () async {
                                                            result =
                                                                await FilePicker.platform.pickFiles(
                                                              allowMultiple: false,
                                                            );

                                                            if (result == null) {
                                                              ScaffoldMessenger.of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  content:
                                                                      Text('Nada seleccionado.'),
                                                                ),
                                                              );
                                                            } else {
                                                              ScaffoldMessenger.of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                      'Subiendo archivo...',
                                                                      style: Tema.of(context)
                                                                          .title2
                                                                          .override(
                                                                            fontFamily: 'Nunito',
                                                                            color: Colors.white,
                                                                            fontSize: 16,
                                                                          )),
                                                                  backgroundColor:
                                                                      Tema.of(context).primaryColor,
                                                                ),
                                                              );
                                                              File file =
                                                                  File(result!.files.single.path!);
                                                              downloadUrl =
                                                                  await eventsBloc.uploadFile(
                                                                      'users/' +
                                                                          currentUser!.id +
                                                                          '/tickets/' +
                                                                          shows[index]['show']
                                                                              .id
                                                                              .toString() +
                                                                          '/' +
                                                                          (result!
                                                                              .files.single.name),
                                                                      file);
                                                            }
                                                          },
                                                          child: Container(
                                                              child: Row(
                                                            children: [
                                                              Icon(Icons.upload_file),
                                                              Text('Sube tu entrada')
                                                            ],
                                                          ))),
                                                      result != null
                                                          ? Text(result!.files.first.name)
                                                          : Container()
                                                    ],
                                                  )),
                                                  actions: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () async {
                                                              Navigator.pop(alertDialogContext);
                                                            },
                                                            child: Text('No, cancelar'),
                                                          ),
                                                          TextButton(
                                                              onPressed: () async {
                                                                eventsBloc.addTicketToShow(
                                                                    shows[index]['show']
                                                                        .id
                                                                        .toString(),
                                                                    downloadUrl);
                                                                setState(() {});
                                                                Navigator.pop(alertDialogContext);
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: Tema.of(context).alternate,
                                                                  borderRadius:
                                                                      BorderRadius.circular(5),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsetsDirectional.all(5),
                                                                  child: Text(
                                                                    'Subir entrada',
                                                                    style: Tema.of(context)
                                                                        .bodyText1
                                                                        .override(
                                                                            fontFamily: 'Nunito',
                                                                            color: Tema.of(context)
                                                                                .white),
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
                                                color: Tema.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.upload_file,
                                                    color: Tema.of(context).white,
                                                    size: 20,
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                          5, 0, 0, 0),
                                                      child: Text(
                                                        'Subir ticket',
                                                        style: Tema.of(context).subtitle2.override(
                                                            fontFamily: 'Nunito',
                                                            color: Tema.of(context).white),
                                                      ))
                                                ],
                                              )),
                                        )
                                ],
                              ),
                            ]),
                          ));
                    },
                  );
                }
              })),
    );
  }
}
