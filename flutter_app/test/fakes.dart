import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:udhar_khata_flutter/data/auth/auth_service.dart';

/// A stand-in for AuthService that never touches the real Supabase client,
/// so LedgerState/LedgerRepository can be unit tested without a live
/// project. Real sign-in flows (phone OTP, Google) are exercised manually
/// against a real Supabase project instead (see supabase/README).
class FakeAuthService extends AuthService {
  String? testUserId;

  @override
  Session? get currentSession => null;

  @override
  String? get currentUserId => testUserId;

  @override
  Stream<AuthState> get onAuthStateChange => const Stream.empty();

  @override
  Future<void> sendPhoneOtp(String e164Phone) async {}

  @override
  Future<AuthResponse> verifyPhoneOtp(String e164Phone, String token) {
    throw UnimplementedError('Not exercised by unit tests.');
  }

  @override
  Future<AuthResponse> signInWithGoogle() {
    throw UnimplementedError('Not exercised by unit tests.');
  }

  @override
  Future<void> signOut() async {}
}
