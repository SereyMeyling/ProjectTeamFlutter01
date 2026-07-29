import 'package:dio/dio.dart';
import 'package:demo_sccess_refresh_token_app/constants/constant_uri.dart';
import 'package:demo_sccess_refresh_token_app/core/remote/auth_interceptor.dart';

class DioClient {
  DioClient._internal();
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late final Dio dio = _build();

  Dio _build() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ConstantUri.baseUri,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {"Content-Type": "application/json"},
      ),
    );
    dio.interceptors.add(AuthInterceptor(dio));
    return dio;
  }
}