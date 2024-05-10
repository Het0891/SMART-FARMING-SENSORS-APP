import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //Google Sign in
  Future<User?> signInWithGoogle() async {
    //begin sign in process
    try {
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
      if (gUser != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await gUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
        await _auth.signInWithCredential(credential);

        final User? user = authResult.user;
        return user;
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
    return null;
      }
}