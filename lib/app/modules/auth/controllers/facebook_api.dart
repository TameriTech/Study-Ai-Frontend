
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookApi{
  static var userinfo;
  static var accessToken;

  static facebookSignIn() async {
    final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile
// or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      accessToken = result.accessToken!;
      userinfo = await FacebookAuth.instance.getUserData();
    } else {
      print(result.status);
      print(result.message);
    }
  }


}