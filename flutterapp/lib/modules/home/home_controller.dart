import 'package:get/get.dart';
import 'package:demo_sccess_refresh_token_app/constants/constant_uri.dart';
import 'package:demo_sccess_refresh_token_app/core/services/api_service.dart';

class HomeController extends GetxController {
  HomeController({required this.apiService});
  final ApiService apiService;

  var isloading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getAllPost();
  }

  void _getAllPost() async {
    isloading.value = true;
    try {
      final response = await apiService.getApi(
        "${ConstantUri.baseUri}/api/app/post?page=0&size=10&status=ACT",
      );
      // response is already decoded JSON (Map/List) — parse into
      // PostResponse.fromJson(response) here when you're ready to use it.
    } finally {
      isloading.value = false;
    }
  }
}