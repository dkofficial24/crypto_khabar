import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  UserCredential _userCredential;

  AuthService._internal();

  static AuthService _authService = AuthService._internal();

  factory AuthService() {
    return _authService;
  }

  UserCredential get userCredential => _userCredential;

  Future loginAnonymously() async {
    _userCredential = await FirebaseAuth.instance.signInAnonymously();
  }


}
