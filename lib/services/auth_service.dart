import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirestoreService _firestoreService = FirestoreService();

  Future<UserCredential> login(
      String email,
      String password,
      ) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signup(
      String name,
      String email,
      String password,
      ) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user!;

    await _firestoreService.createUser(
      UserModel(
        id: user.uid,
        name: name,
        email: email,
      ),
    );

    await user.sendEmailVerification();

    return result;
  }

  Future<UserCredential> googleLogin() async {
    await _googleSignIn.initialize();

    final googleUser = await _googleSignIn.authenticate();

    final credential = GoogleAuthProvider.credential(
      idToken: googleUser.authentication.idToken,
    );

    final result = await _auth.signInWithCredential(credential);

    final user = result.user!;

    await _firestoreService.createUser(
      UserModel(
        id: user.uid,
        name: user.displayName ?? 'Campus User',
        email: user.email ?? '',
        photoUrl: user.photoURL ?? '',
      ),
    );

    return result;
  }

  Future<void> logout() {
    return _auth.signOut();
  }
}