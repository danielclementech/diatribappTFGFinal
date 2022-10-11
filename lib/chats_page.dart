import 'package:cached_network_image/cached_network_image.dart';
import 'package:diatribapp/chat_page.dart';
import 'package:diatribapp/models/user_record.dart';
import 'package:diatribapp/tema.dart';
import 'package:diatribapp/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import 'blocs/chat_bloc.dart';
import 'models/chat_record.dart';

class ChatsPageWidget extends StatefulWidget {
  const ChatsPageWidget({Key? key}) : super(key: key);


  @override
  _ChatsPageWidgetState createState() => _ChatsPageWidgetState();
}

class _ChatsPageWidgetState extends State<ChatsPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late ChatBloc chatBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    return MaterialApp(
        home: Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(0xFFF1F4F8),
            appBar: AppBar(
              backgroundColor: Tema.of(context).secondaryColor,
              automaticallyImplyLeading: false,
              title: Text(
               'Chats',
                style: Tema.of(context).title2.override(
                      fontFamily: 'Nunito',
                      color: Tema.of(context).primaryColor,
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
                Expanded(
                  child: SingleChildScrollView(
                      child: FutureBuilder<List<ChatRecord?>>(
                    future: chatBloc.getChats(),
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
                      } else {
                        final chats = snapshot.data;
                        return ListView.builder(
                          itemCount: chats?.length,
                          shrinkWrap: true,
                          reverse: true,
                          itemBuilder: (context, index) {
                            final chat = chats![index];
                            return FutureBuilder<UserRecord>(
                                future: UserRecord.getDocumentOnce(chat!.user_a == currentUserDocument!.reference ? chat.user_b : chat.user_a),
                                builder: (context, snapshot) {
                                  final user = snapshot.data;
                                  return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                                      child: InkWell(
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatPageWidget(chat: chat, user: user!, bloc: chatBloc),
                                            ),
                                          );
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Tema.of(context).white,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 0,
                                                  color: Color(0xFFDBE2E7),
                                                  offset: Offset(0, 2),
                                                )
                                              ],
                                            ),
                                            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                            child: Row(
                                              children: [
                                                Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 10),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: CachedNetworkImage(
                                                        imageUrl: user!.avatarUrl ?? '',
                                                        width: 60,
                                                        height: 60,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context, url) => const CircularProgressIndicator(),
                                                        errorWidget: (context, url, error) => const Icon(Icons.question_mark),
                                                      ),
                                                    )),

                                                SizedBox(
                                                  child: Text(user.name ?? '', style: Tema.of(context).title1),
                                                ),
                                              ],
                                            )
                                        )
                                      )


                                  );
                                  
                                });
                          },
                        );
                      }
                    },
                  )),
                ),
              ],
            ))));
  }
}
