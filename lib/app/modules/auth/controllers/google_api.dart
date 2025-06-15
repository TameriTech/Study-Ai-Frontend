//class for google signin
import 'package:google_sign_in/google_sign_in.dart';

class GoogleApi {
  static final _googleSignIn = GoogleSignIn();
  static Future<GoogleSignInAccount?> signIn() => _googleSignIn.signIn();
  static GoogleSignInAccount? userinfo() => _googleSignIn.currentUser;
  static Future<void> signOut() => _googleSignIn.signOut();
}