import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:savour_and_soul/firebase_options.dart';
import 'package:savour_and_soul/services/firebase_service.dart';

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

  /// Sign in or Register using Google Account
  static Future<UserCredential?> signInWithGoogle() async {
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
      idToken: googleAuth?.idToken,
    );

    // 4. Sign in to Firebase
    final UserCredential credentialResult =
        await auth.signInWithCredential(credential);

    // 5. Store user information in Firestore if first-time user
    final user = credentialResult.user;
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
  }
}
