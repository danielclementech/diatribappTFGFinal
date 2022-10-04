import 'package:diatribapp/services/firebase_services.dart';
import 'package:diatribapp/services/spotify_auth_api.dart';

import '../models/user_record.dart';

class AuthRepository {
  final _spotifyAuthAPI = SpotifyAuthApi();
  final _firebaseServices = FirebaseServices();

  authenticate() => _spotifyAuthAPI.authenticate();
  Future<void> signInFromSavedTokens() => _spotifyAuthAPI.signInFromSavedTokens();

  Future<UserRecord?>? getUser() => _firebaseServices.getUser();
}
