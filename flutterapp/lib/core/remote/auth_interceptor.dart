import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:demo_sccess_refresh_token_app/constants/constant_uri.dart';
import 'package:demo_sccess_refresh_token_app/data/local/token_store_local.dart';
import 'package:demo_sccess_refresh_token_app/models/login/LoginResponse.dart';
import 'package:demo_sccess_refresh_token_app/models/login/RefreshTokenRequest.dart';
import 'package:demo_sccess_refresh_token_app/routes/app_routes.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._dio);

  final Dio _dio;

  // Bare Dio instance (no interceptors) used only for the refresh call,
  // so a failed refresh can never trigger itself recursively.
  final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: ConstantUri.baseUri,
      headers: {"Content-Type": "application/json"},
    ),
  );

  bool _isRefreshing = false;
  final List<Completer<void>> _waiters = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = TokenStoreLocal.getAccessToken();
    if (token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final is401 = err.response?.statusCode == 401;
    final isRefreshCall = err.requestOptions.path == ConstantUri.refreshToken;

    if (!is401 || isRefreshCall) {
      handler.next(err);
      return;
    }

    try {
      await _refreshTokens();

      final newAccessToken = TokenStoreLocal.getAccessToken();
      final retryOptions = err.requestOptions
        ..headers["Authorization"] = "Bearer $newAccessToken";

      final response = await _dio.fetch(retryOptions);
      handler.resolve(response);
    } catch (_) {
      _forceLogout();
      handler.next(err);
    }
  }

  Future<void> _refreshTokens() async {
    if (_isRefreshing) {
      final completer = Completer<void>();
      _waiters.add(completer);
      return completer.future;
    }

    _isRefreshing = true;
    try {
      final refreshToken = TokenStoreLocal.getRefreshToken();
      if (refreshToken.isEmpty) {
        throw Exception("No refresh token stored");
      }

      final response = await _refreshDio.post(
        ConstantUri.refreshToken,
        data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
      );

      final loginResponse = LoginResponse.fromJson(response.data);
      if (loginResponse.accessToken == null) {
        throw Exception("Refresh response missing access token");
      }

      TokenStoreLocal.setAcessToken(loginResponse.accessToken!);
      if (loginResponse.refreshToken != null) {
        TokenStoreLocal.setRefreshToken(loginResponse.refreshToken!);
      }

      for (final w in _waiters) {
        w.complete();
      }
      _waiters.clear();
    } catch (e) {
      for (final w in _waiters) {
        w.completeError(e);
      }
      _waiters.clear();
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }

  void _forceLogout() {
    TokenStoreLocal.removeToken();
    Get.offAllNamed(AppRoutes.login);
  }
}