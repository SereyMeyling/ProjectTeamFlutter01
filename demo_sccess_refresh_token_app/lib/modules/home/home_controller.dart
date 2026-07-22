import 'package:demo_sccess_refresh_token_app/constants/constant_uri.dart';
import 'package:demo_sccess_refresh_token_app/core/services/api_service_impl.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var isloading = false.obs;
  var apiService = ApiServiceImpl();
  @override
  void onInit() {
    super.onInit();
  }

  void _getAllPost() async {
    var response = await apiService.getApi(
      "${ConstantUri.baseUri}/api/app/post?page=0&size=10&status=ACT",
    );
  }
}
