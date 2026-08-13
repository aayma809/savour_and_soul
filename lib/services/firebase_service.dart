import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:savour_and_soul/firebase_options.dart';

/// Central access point for this app's Firebase services.
class FirebaseService {
  FirebaseService._();

  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> initialize() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

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
    });
    return credential;
  }

  static Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> signOut() => auth.signOut();
}
