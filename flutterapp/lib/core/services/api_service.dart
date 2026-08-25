import 'package:demo_sccess_refresh_token_app/models/login/LoginRequest.dart';
import 'package:demo_sccess_refresh_token_app/models/register/RegisterRequest.dart';

import '../../models/login/LoginResponse.dart';

abstract class ApiService {
  Future<LoginResponse> login({LoginRequest? body});
  Future<LoginResponse> refreshToken(String token);
  Future<dynamic> getApi(String url, {String? param});
  Future<Map<String, dynamic>> register(RegisterRequest body);
}