import 'package:auto_size_text/auto_size_text.dart';
import 'package:diatribapp/services/spotify_auth_api.dart';
import 'package:diatribapp/tema.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import 'blocs/user_bloc.dart';
import 'main.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late UserBloc userBloc;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initialSignIn();
  }

  Future<void> _initialSignIn() async {
    setState(() => _isLoading = true);
    try {
      _signInFromSavedTokens();
      return;
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        backgroundColor: Tema.of(context).primaryBackground,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          decoration: BoxDecoration(
            color: Tema.of(context).primaryColor,
          ),
          alignment: AlignmentDirectional(0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(40, 0, 40, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/icono.png',
                        width: double.infinity,
                        height: 80,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, 1),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                                child: AutoSizeText(
                                  'Bienvenid@ a Ditaribapp',
                                  textAlign: TextAlign.center,
                                  style: Tema.of(context).title1.override(
                                        fontFamily: 'Nunito',
                                        color: Tema.of(context).white,
                                        fontSize: 28,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _isLoading
                  ? Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          color: Tema.of(context).alternate,
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Tema.of(context).white,
                          boxShadow: [
                            BoxShadow(
                              color: Tema.of(context).secondaryColor,
                              offset: Offset(0, 0),
                            )
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment: AlignmentDirectional(0, 0),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<Color>(
                                                              Tema.of(context).secondaryColor),
                                                      textStyle:
                                                          MaterialStateProperty.all<TextStyle>(
                                                              Tema.of(context).title2),
                                                    ),
                                                    onPressed: () async {
                                                      setState(() {
                                                        _isLoading = true;
                                                      });
                                                      await userBloc.authenticate();
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                      await Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              NavBarPage(initialPage: 'Profile'),
                                                        ),
                                                        (r) => false,
                                                      );
                                                    },
                                                    child: const Text('Log in con Spotify'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              Padding(
                  padding: EdgeInsetsDirectional.only(top: 20),
                  child: Text('Powered by',
                      style: Tema.of(context).subtitle2.override(
                          fontFamily: 'Nunito',
                          color: Tema.of(context).spotifyColor,
                          fontWeight: FontWeight.w800))),
              Padding(
                padding: EdgeInsetsDirectional.only(top: 5),
                child: Image.asset(
                  'assets/images/Spotify_Logo_RGB_Green.png',
                  height: 60,
                ),
              ),
              Padding(
                  padding: EdgeInsetsDirectional.only(top: 10),
                  child: Text('and',
                      style: Tema.of(context)
                          .subtitle2
                          .override(fontFamily: 'Nunito', color: Tema.of(context).spotifyColor))),
              Padding(
                padding: EdgeInsetsDirectional.only(top: 10),
                child: Image.asset(
                  'assets/images/powered-by-songkick-pink.png',
                  height: 60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(color: Tema.of(context).secondaryColor),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("Autenticando...",
                  style: Tema.of(context)
                      .subtitle2
                      .override(fontFamily: 'Nunito', color: Tema.of(context).secondaryColor))),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _signInFromSavedTokens() async {
    setState(() => _isLoading = true);
    try {
      await SpotifyAuthApi().signInFromSavedTokens();
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => NavBarPage(initialPage: 'Feed'),
        ),
        (r) => false,
      );
    } catch (_) {
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
