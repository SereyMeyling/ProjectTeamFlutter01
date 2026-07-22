import 'package:demo_sccess_refresh_token_app/core/services/api_service.dart';
import 'package:demo_sccess_refresh_token_app/core/services/api_service_impl.dart';
import 'package:demo_sccess_refresh_token_app/data/local/token_store_local.dart';
import 'package:demo_sccess_refresh_token_app/models/login/LoginRequest.dart';
import 'package:demo_sccess_refresh_token_app/modules/home/home_view.dart';
import 'package:demo_sccess_refresh_token_app/modules/splash/splash_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var apiService = ApiServiceImpl();
  var usernameController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var isLoading=false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void onLogin() async {
    String username = usernameController.value.text.trim();
    String password = passwordController.value.text.trim();

    if (username.isEmpty) {
      Get.snackbar("Error", "Username is required!");
      return;
    }
    if (password.isEmpty) {
      Get.snackbar("Error", "Password is required!");
      return;
    }
    isLoading.value = true;

      var loginResponse = await apiService.login(
        body: LoginRequest(
          phoneNumber: username,
          password: password,
        ),
      );
      if (loginResponse.accessToken != null) {
        Get.snackbar("Success", "Login Successfully");
        TokenStoreLocal.setAcessToken(loginResponse.accessToken??"");
        TokenStoreLocal.setRefreshToken(loginResponse.refreshToken??"");
        Get.offAll(HomeView());
      } else {
        Get.snackbar("Error", "Invalid response");
      }
     isLoading.value = false;
  }


}

//admin
//Admin@1234
