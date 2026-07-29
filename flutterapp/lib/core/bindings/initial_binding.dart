import 'package:get/get.dart';
import 'package:demo_sccess_refresh_token_app/core/services/api_service.dart';
import 'package:demo_sccess_refresh_token_app/core/services/api_service_impl.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiService>(ApiServiceImpl(), permanent: true);
  }
}