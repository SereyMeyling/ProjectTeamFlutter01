import 'dart:convert';
import 'package:demo_sccess_refresh_token_app/constants/constant_uri.dart';
import 'package:demo_sccess_refresh_token_app/core/services/api_service.dart';
import 'package:demo_sccess_refresh_token_app/data/local/token_store_local.dart';
import 'package:demo_sccess_refresh_token_app/models/login/LoginRequest.dart';
import 'package:demo_sccess_refresh_token_app/modules/login/login_view.dart';
import 'package:get/get.dart';
import '../../models/login/LoginResponse.dart';
import 'package:http/http.dart' as httpClient;

class ApiServiceImpl extends ApiService {
  var headers={
    "Content-Type":"application/json"
  };
  @override
  Future<LoginResponse> login({LoginRequest? body}) async {
    var url = Uri.parse(ConstantUri.login);
    var response = await httpClient.post(
      url,
      headers:headers,
      body: jsonEncode(body!.toJson()),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    }

    throw Exception("Login failed: ${response.body}");
  }

  @override
  Future<LoginResponse> refreshToken(String token) async {
    var url = Uri.parse(ConstantUri.refreshToken);
    var responseTokenBody = new RefreshTokenRequest(refreshToken: token);
    var response = await httpClient.post(
      url,
      body.JsonEncode(responseTokenBody!.toJson()),
      headers: headers
    );
    if (response.statusCode == 200) {
      var loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
      return loginResponse;
    }
    return LoginResponse();
  }

  @override
  Future<dynamic> getApi(String url,{String? param}) async {
   dynamic responseBody;
   headers["Authorization"]="Bearer ${TokenStoreLocal.getAccessToken()}";
   var response = await httpClient.get(Uri.parse(url),headers: headers);
   if(response.statusCode==200){
     responseBody=response.body;
   }else if(response.statusCode==401){
     var refreshResponse = await refreshToken(TokenStoreLocal.getRefreshToken());
     if(refreshResponse.accessToken==null){
       Get.offAll(LoginView());
       return;
     }else{
       responseBody=await getApiRetry(url,param:param);
     }
   }
   return reponseBody;
  }
  dynamic getApiRetry(String url,{String? param}) async {
    headers["Authorization"]="Bearer ${TokenStoreLocal.getAccessToken()}";
    var response=await httpClient.get(Uri.parse(url),headers: headers);
    return response.body;
  }
}
