import 'package:demo_sccess_refresh_token_app/data/local/token_store_local.dart';
import 'package:demo_sccess_refresh_token_app/modules/home/home_controller.dart';
import 'package:demo_sccess_refresh_token_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text("home"),
          actions: [
            IconButton(
              onPressed: () {
                TokenStoreLocal.removeToken();
                Get.offAllNamed(AppRoutes.login);
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: controller.isloading.value
            ? CircularProgressIndicator(color: Colors.cyan)
            : Container(),
      );
    });
  }
}