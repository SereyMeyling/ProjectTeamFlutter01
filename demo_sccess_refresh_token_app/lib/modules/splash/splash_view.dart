import 'package:demo_sccess_refresh_token_app/modules/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SplashController());
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.cyan,
        body: controller.isLoading.value
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : Text(""),
      );
    });
  }
}
