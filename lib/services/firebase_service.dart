import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:savour_and_soul/firebase_options.dart';
import 'package:savour_and_soul/services/firebase_service.dart' as auth;

class FirebaseService {
  FirebaseService._();

  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> initialize(dynamic DefaultFirebaseOptions) async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  /// Sign up a new user with email & password, and save their info to Firestore.
   static Future<UserCredential> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('Account creation did not return a user.');
    }

    await user.updateDisplayName(fullName);
    await firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'fullName': fullName,
      'email': user.email ?? email,
      'createdAt': FieldValue.serverTimestamp(),
  );
  }
    
     Null get credential => null;

  static void signUp({required String email, required String password, required String fullName}) {}

  static Future<void> signIn({required String email, required String password, required String fullName}) async {}
  }

  /// Sign in an existing user with email & password.
  Future<signInWithEmailAndPassword> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user != null) {
      var firestore;
      final docRef = firestore.collection('users').doc(user.uid);
      final doc = await docRef.get();
      if (!doc.exists) {
        await docRef.set({
          'uid': user.uid,
          'fullName': user.displayName ?? '',
          'email': user.email ?? email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }

    return credential;
  }

extension on Object {
  String? get displayName => null;

  String? get email => null;

  get uid => null;
}

  /// Sign in or Register using Google Account
  Future<UserCredential?> signInWithGoogle() async {
    // 1. Trigger the native Google login dialog
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // User canceled the sign-in prompt
    if (googleUser == null) return null;

    // 2. Fetch auth details (tokens) from the Google account
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    // 3. Pass credentials to Firebase
    
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth??.idToken2,
    );

    // 4. Sign in to Firebase
    var auth;
    final UserCredential credentialResult =
        await auth.signInWithCredential(credential);

    // 5. Store user information in Firestore if first-time user
    final user = credentialResult.user;
    if (user != null) {
      var firestore;
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
  }

  /// Sign out from both Firebase and Google
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await auth.signOut();
  }
}

class GoogleSignInAuthentication {
  String? accessToken;

  String? idToken;
}

class GoogleSignInAccount {
  Future<GoogleSignInAuthentication>? get authentication => null;
}

GoogleSignIn() {
}

class signInWithEmailAndPassword {
  Object? get user => null;
}