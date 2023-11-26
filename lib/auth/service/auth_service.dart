import 'package:firebase_auth/firebase_auth.dart';

//Testing
class AuthService {
  factory AuthService() {
    return _authService;
  }

  AuthService._internal();

  late UserCredential _userCredential;

  static final AuthService _authService = AuthService._internal();

  UserCredential get userCredential => _userCredential;

  Future<void> loginAnonymously() async {
    _userCredential = await FirebaseAuth.instance.signInAnonymously();
  }
}
