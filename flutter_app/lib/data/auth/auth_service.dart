import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../env.dart';

/// Wraps Supabase Auth for the two real sign-in methods this app supports:
/// phone OTP (SMS, via a provider configured in the Supabase dashboard) and
/// native Google sign-in exchanged for a Supabase session.
class AuthService {
  GoTrueClient get _auth => Supabase.instance.client.auth;

  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;

  Session? get currentSession => _auth.currentSession;

  String? get currentUserId => _auth.currentUser?.id;

  /// Sends an OTP SMS to [e164Phone] (must already be in E.164 form, e.g. `+91XXXXXXXXXX`).
  Future<void> sendPhoneOtp(String e164Phone) {
    return _auth.signInWithOtp(phone: e164Phone);
  }

  Future<AuthResponse> verifyPhoneOtp(String e164Phone, String token) {
    return _auth.verifyOTP(type: OtpType.sms, phone: e164Phone, token: token);
  }

  bool _googleSignInInitialized = false;

  Future<AuthResponse> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn.instance;
    if (!_googleSignInInitialized) {
      await googleSignIn.initialize(serverClientId: googleWebClientId);
      _googleSignInInitialized = true;
    }
    final account = await googleSignIn.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw Exception('Google sign-in did not return an ID token.');
    }
    return _auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );
  }

  Future<void> signOut() => _auth.signOut();
}
