import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:savour_and_soul/firebase_options.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ------------------------------------------------------------
  // INITIALIZE FIREBASE
  // ------------------------------------------------------------

  static Future<void> initialize() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  // ------------------------------------------------------------
  // SIGN UP WITH EMAIL AND PASSWORD
  // ------------------------------------------------------------

  static Future<UserCredential> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User? user = credential.user;

    if (user == null) {
      throw StateError('Account creation did not return a user.');
    }

    await user.updateDisplayName(fullName);

    await firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'fullName': fullName,
      'email': user.email ?? email,
      'photoUrl': user.photoURL ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  // ------------------------------------------------------------
  // SIGN IN WITH EMAIL AND PASSWORD
  // ------------------------------------------------------------

  static Future<UserCredential> signIn({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final UserCredential credential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User? user = credential.user;

    if (user != null) {
      final DocumentReference<Map<String, dynamic>> docRef = firestore
          .collection('users')
          .doc(user.uid);

      final DocumentSnapshot<Map<String, dynamic>> doc = await docRef.get();

      if (!doc.exists) {
        await docRef.set({
          'uid': user.uid,
          'fullName': user.displayName ?? '',
          'email': user.email ?? email,
          'photoUrl': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }

    return credential;
  }

  // ------------------------------------------------------------
  // GOOGLE SIGN IN
  // (google_sign_in v7+ API: GoogleSignIn.instance, .authenticate(),
  //  and access tokens come from authorizationClient, not from
  //  GoogleSignInAuthentication, which now only carries idToken.)
  // ------------------------------------------------------------

  static Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(
      clientId: '66545249642-im5q9ak7tjd7ba2d9glb9aek2m17vv0b.apps.googleusercontent.com',
    );

    final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final GoogleSignInClientAuthorization? authorization = await googleUser
        .authorizationClient
        .authorizationForScopes(['email', 'profile']);

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: authorization?.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential credentialResult = await auth.signInWithCredential(credential);

    final User? user = credentialResult.user;
    if (user != null) {
      final docRef = firestore.collection('users').doc(user.uid);
      final doc = await docRef.get();
      if (!doc.exists) {
        await docRef.set({
          'uid': user.uid,
          'fullName': user.displayName ?? '',
          'email': user.email ?? '',
          'photoUrl': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }
    return credentialResult;
  } catch (e, st) {
    print('GOOGLE SIGN-IN ERROR: $e');
    print(st);
    rethrow;
  }
}
