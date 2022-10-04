import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:diatribapp/services/api_path.dart';
import 'package:diatribapp/services/auth_tokens.dart';
import 'package:diatribapp/services/firebase_services.dart';
import 'package:diatribapp/services/spotify_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;

import '../models/user_record.dart';
import '../util.dart';
import 'auth_tokens.dart';
import 'keys.dart';

class SpotifyAuthApi {
  final _spotifyApi = SpotifyApi();

  static final base64Credential = utf8.fuse(base64).encode('$clientId:$clientSecret');

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseServices services = FirebaseServices();

  Future<void> authenticate() async {
    final redirectUri = 'diatribapp://callback';
    final state = _getRandomString(6);

    try {
      final result = await FlutterWebAuth.authenticate(
        url: APIPath.requestAuthorization(clientId, redirectUri, state),
        callbackUrlScheme: 'diatribapp',
      );

      final returnedState = Uri.parse(result).queryParameters['state'];
      if (state != returnedState) throw HttpException('Invalid access');

      final code = Uri.parse(result).queryParameters['code'];

      final tokens = await SpotifyAuthApi.getAuthTokens(code!, redirectUri);
      await tokens.saveToStorage();

      var resultado = await _spotifyApi.getCurrentUser(); // Uses token in storage

      if (resultado == null) {
        return;
      }

      HttpsCallable callable = FirebaseFunctions.instanceFor().httpsCallable('getToken');

      final resp = await callable.call(<String, dynamic>{'uid': resultado.id});

      var token = resp.data;

      try {
        await _auth.signInWithCustomToken(token);
        print("Sign-in successful.");
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "invalid-custom-token":
            print("The supplied token is not a Firebase custom auth token.");
            break;
          case "custom-token-mismatch":
            print("The supplied token is for a different Firebase project.");
            break;
          default:
            print("Unkown error.");
        }
      }
      currentUser = resultado;
      try {
        currentUserDocument = await services.getUser();
      } catch (error) {
        services.createUser(resultado);
        currentUserDocument = await services.createUser(resultado);
      }

    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  static String _getRandomString(int length) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(
        Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  Future<void> signInFromSavedTokens() async {
    try {
      await AuthTokens.updateTokenToLatest();
      currentUser = await _spotifyApi.getCurrentUser(); // Uses token in storage
      currentUserReference = firebaseFirestore.doc('/users/${currentUser?.id}');
      currentUserDocument = await UserRecord.getDocumentOnce(currentUserReference!);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<AuthTokens> getAuthTokens(String code, String redirectUri) async {
    final response = await http.post(
      Uri.parse(APIPath.requestToken),
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
      headers: {HttpHeaders.authorizationHeader: 'Basic $base64Credential'},
    );

    if (response.statusCode == 200) {
      return AuthTokens.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load token with status code ${response.statusCode}');
    }
  }

  static Future<AuthTokens> getNewTokens({required AuthTokens originalTokens}) async {
    final response = await http.post(
      Uri.parse(APIPath.requestToken),
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': originalTokens.refreshToken,
      },
      headers: {HttpHeaders.authorizationHeader: 'Basic $base64Credential'},
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['refresh_token'] == null)
        responseBody['refresh_token'] = originalTokens.refreshToken;

      return AuthTokens.fromJson(responseBody);
    } else {
      throw Exception('Failed to refresh token with status code ${response.statusCode}');
    }
  }
}
