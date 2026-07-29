import 'package:get/get.dart';
import 'package:demo_sccess_refresh_token_app/core/services/api_service.dart';
import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
          () => LoginController(apiService: Get.find<ApiService>()),
      fenix: true,
    );
  }
}