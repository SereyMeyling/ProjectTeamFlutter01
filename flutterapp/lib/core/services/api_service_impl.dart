import 'package:demo_sccess_refresh_token_app/models/register/RegisterRequest.dart';
import 'package:dio/dio.dart';
import 'package:demo_sccess_refresh_token_app/constants/constant_uri.dart';
import 'package:demo_sccess_refresh_token_app/core/remote/dio_client.dart';
import 'package:demo_sccess_refresh_token_app/core/services/api_service.dart';
import 'package:demo_sccess_refresh_token_app/models/login/LoginRequest.dart';
import 'package:demo_sccess_refresh_token_app/models/login/LoginResponse.dart';
import 'package:demo_sccess_refresh_token_app/models/login/RefreshTokenRequest.dart';

class ApiServiceImpl extends ApiService {
  ApiServiceImpl({Dio? dio}) : _dio = dio ?? DioClient().dio;
  final Dio _dio;

  @override
  Future<LoginResponse> login({LoginRequest? body}) async {
    final response = await _dio.post(ConstantUri.login, data: body?.toJson());
    return LoginResponse.fromJson(response.data);
  }

  @override
  Future<LoginResponse> refreshToken(String token) async {
    final response = await _dio.post(
      ConstantUri.refreshToken,
      data: RefreshTokenRequest(refreshToken: token).toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }

  @override
  Future<dynamic> getApi(String url, {String? param}) async {
    final response = await _dio.get(url);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> register(RegisterRequest body) async {
    final response = await _dio.post(ConstantUri.register, data: body.toJson());
    return response.data;
  }
}
