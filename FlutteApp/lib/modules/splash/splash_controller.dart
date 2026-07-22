import 'package:demo_sccess_refresh_token_app/data/local/token_store_local.dart';
import 'package:demo_sccess_refresh_token_app/modules/home/home_view.dart';
import 'package:demo_sccess_refresh_token_app/modules/login/login_view.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  var isLoading = false.obs;

  @override
  void onInit() {
    _checkToken();
    super.onInit();
  }

  Future<void> _checkToken() async {
    isLoading.value=true;
    await Future.delayed(Duration(seconds: 2));
    if (TokenStoreLocal.getAccessToken().isNotEmpty) {
      Get.offAll(HomeView());
    } else {
      Get.offAll(LoginView());
    }
    isLoading.value=false;
  }
}
