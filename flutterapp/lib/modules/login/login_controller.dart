import 'package:demo_sccess_refresh_token_app/modules/task/task_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:demo_sccess_refresh_token_app/core/services/api_service.dart';
import 'package:demo_sccess_refresh_token_app/data/local/token_store_local.dart';
import 'package:demo_sccess_refresh_token_app/models/login/LoginRequest.dart';
import 'package:demo_sccess_refresh_token_app/routes/app_routes.dart';

class LoginController extends GetxController {
  final isPasswordHidden = true.obs;
  LoginController({required this.apiService});
  final ApiService apiService;

  var usernameController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var isLoading = false.obs;

  void onLogin() async {
    final username = usernameController.value.text.trim();
    final password = passwordController.value.text.trim();

    if (username.isEmpty) {
      Get.snackbar("Error", "Username is required!");
      return;
    }
    if (password.isEmpty) {
      Get.snackbar("Error", "Password is required!");
      return;
    }

    isLoading.value = true;
    try {
      final loginResponse = await apiService.login(
        body: LoginRequest(phoneNumber: username, password: password),
      );

      if (loginResponse.accessToken != null) {
        TokenStoreLocal.setAcessToken(loginResponse.accessToken ?? "");
        TokenStoreLocal.setRefreshToken(loginResponse.refreshToken ?? "");
        await Get.find<TaskController>().fetchTasks();
        Get.snackbar("Success", "Login Successfully");
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.snackbar("Error", "Invalid response");
      }
    } catch (e) {
      Get.snackbar("Error", "Login failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.value.dispose();
    passwordController.value.dispose();
    super.onClose();
  }
}
