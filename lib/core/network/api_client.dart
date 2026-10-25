import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:tumpeng/core/network/secure_cookie_storage.dart';

/// Dio client that accepts Set-Cookie responses and attaches cookies to requests.
/// Configure the backend URL with --dart-define=API_BASE_URL=https://...
class ApiClient {
  ApiClient._(this.dio, this.cookieJar);

  final Dio dio;
  final PersistCookieJar cookieJar;

  static Future<ApiClient> create({String? baseUrl}) async {
    const configuredUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://api.example.com',
    );
    final jar = PersistCookieJar(
      persistSession: true,
      storage: SecureCookieStorage(),
    );
    await jar.forceInit();
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? configuredUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: const {'Accept': 'application/json'},
      ),
    );
    dio.interceptors.add(CookieManager(jar));
    return ApiClient._(dio, jar);
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? query}) =>
      dio.get<T>(path, queryParameters: query);

  Future<Response<T>> post<T>(String path, {Object? data}) =>
      dio.post<T>(path, data: data);

  Future<void> clearSession() => cookieJar.deleteAll();
}
