import 'package:cached_network_image/cached_network_image.dart';
import 'package:diatribapp/blocs/profile_bloc.dart';
import 'package:diatribapp/services/index.dart';
import 'package:diatribapp/tema.dart';
import 'package:diatribapp/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '../blocs/user_bloc.dart';
import '../models/user_record.dart';
import '../profile/other_profile_page.dart';

class UserPostWidget extends StatefulWidget {
  const UserPostWidget({Key? key, required this.userReference}) : super(key: key);

  final DocumentReference userReference;

  @override
  _UserPostWidgetState createState() => _UserPostWidgetState();
}

class _UserPostWidgetState extends State<UserPostWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late UserBloc userBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    return FutureBuilder<UserRecord>(
        future: UserRecord.getDocumentOnce(widget.userReference),
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
          return InkWell(
              onTap: () async {
                if (widget.userReference != currentUserDocument?.reference) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                          child: OtherProfileWidget(
                            user: user!,
                          ),
                          bloc: ProfileBloc()),
                    ),
                  );
                }
              },
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
                    width: 150,
                    child: Text(user.name!, style: Tema.of(context).title1),
                  ),
                ],
              ));
        });
  }
}
