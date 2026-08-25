import 'package:get/get.dart';
import 'package:demo_sccess_refresh_token_app/core/services/api_service.dart';
import 'package:demo_sccess_refresh_token_app/core/services/api_service_impl.dart';
import 'package:demo_sccess_refresh_token_app/core/services/task_api_service.dart';
import 'package:demo_sccess_refresh_token_app/core/services/task_api_service_impl.dart';
import 'package:demo_sccess_refresh_token_app/modules/task/task_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiService>(ApiServiceImpl(), permanent: true);
    Get.put<TaskApiService>(TaskApiServiceImpl(), permanent: true);
    Get.put<TaskController>(
      TaskController(taskApiService: Get.find<TaskApiService>()),
      permanent: true,
    );
  }
}
