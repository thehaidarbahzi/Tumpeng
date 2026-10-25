import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tumpeng/core/network/api_client.dart';

/// Returns a Google ID token for the backend to exchange for its own session.
/// The backend should respond with an HttpOnly Set-Cookie session cookie.
class GoogleAuthService {
  GoogleAuthService({GoogleSignIn? googleSignIn})
    : _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final GoogleSignIn _googleSignIn;
  Future<void>? _initialization;

  Future<String> signInForIdToken() async {
    const serverClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
    _initialization ??= _googleSignIn.initialize(
      serverClientId: serverClientId.isEmpty ? null : serverClientId,
    );
    await _initialization;
    final account = await _googleSignIn.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw StateError(
        'Google tidak mengembalikan ID token. Periksa konfigurasi OAuth.',
      );
    }
    return idToken;
  }

  /// Exchanges Google's ID token with the app backend, which should set the
  /// application's session using Set-Cookie (ideally HttpOnly and Secure).
  Future<Response<dynamic>> signInAndExchange(
    ApiClient api, {
    String endpoint = '/auth/google',
    String? role,
  }) async {
    final idToken = await signInForIdToken();
    return api.post<dynamic>(
      endpoint,
      data: {'idToken': idToken, if (role != null) 'role': role},
    );
  }

  Future<void> signOut() => _googleSignIn.signOut();
}
