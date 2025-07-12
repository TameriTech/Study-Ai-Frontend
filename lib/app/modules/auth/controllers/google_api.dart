//class for google signin
import 'package:google_sign_in/google_sign_in.dart';

class GoogleApi {
  static final _googleSignIn = GoogleSignIn(
    scopes: [
    'email',
    'profile',
    'openid',
  ],
    serverClientId: "117771072114-2tm3ecj8ct4k1jqc530t9uqisqo8909e.apps.googleusercontent.com"
  );
  static Future<GoogleSignInAccount?> signIn() => _googleSignIn.signIn();
  static GoogleSignInAccount? userinfo() => _googleSignIn.currentUser;
  static Future<void> signOut() => _googleSignIn.signOut();

}