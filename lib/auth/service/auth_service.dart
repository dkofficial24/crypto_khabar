import 'package:firebase_auth/firebase_auth.dart';
//Testing
class AuthService {

  factory AuthService() {
    return _authService;
  }
//test naresh
  AuthService._internal();
  UserCredential _userCredential;

  static final AuthService _authService = AuthService._internal();

  UserCredential get userCredential => _userCredential;

  Future loginAnonymously() async {
    _userCredential = await FirebaseAuth.instance.signInAnonymously();
  }


}
