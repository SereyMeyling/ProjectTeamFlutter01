import 'package:get/get.dart';
import 'package:demo_sccess_refresh_token_app/data/local/token_store_local.dart';
import 'package:demo_sccess_refresh_token_app/routes/app_routes.dart';

class SplashController extends GetxController {
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkToken();
  }

  Future<void> _checkToken() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    Get.offAllNamed(
      TokenStoreLocal.hasValidSession() ? AppRoutes.home : AppRoutes.login,
    );
    isLoading.value = false;
  }
}