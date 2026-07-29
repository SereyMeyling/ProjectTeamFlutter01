import 'package:get_storage/get_storage.dart';

class TokenStoreLocal {
  static final storage=GetStorage();
  static String _accessToken = "ACCESS_TOKEN";
  static String _refreshToken="REFRESH_TOKEN";

  static void setAcessToken(String token){
    storage.write(_accessToken, token);
  }
  static void setRefreshToken(String token){
    storage.write(_refreshToken, token);
  }
  static String getAccessToken(){
    return storage.read(_accessToken) ?? "";
  }
  static String getRefreshToken(){
    return storage.read(_refreshToken) ?? "";
  }
  static void removeToken(){
    storage.remove(_refreshToken);
    storage.remove(_accessToken);
  }
  static bool hasValidSession() => getAccessToken().isNotEmpty;

}