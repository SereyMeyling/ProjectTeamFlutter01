class ConstantUri {
  static const baseUri = "http://10.0.2.2:30033";
  static const login = "$baseUri/api/oauth/token";
  static const register = "$baseUri/api/oauth/register";
  static const refreshToken = "$baseUri/api/oauth/refresh";

  static const taskBase = "$baseUri/api/app/task";
  static String taskById(int id) => "$taskBase/$id";
  static String taskComplete(int id) => "$taskBase/$id/complete";
}

