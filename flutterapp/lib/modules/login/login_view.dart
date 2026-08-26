import 'package:demo_sccess_refresh_token_app/modules/login/login_controller.dart';
import 'package:demo_sccess_refresh_token_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_sccess_refresh_token_app/constants/colors.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<LoginController>();

    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 45,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "To Do List",
                    style: TextStyle(
                      color: AppColors.darkNavy,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Login to continue",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.usernameController.value,
                decoration: InputDecoration(
                  hint: Text("Username"),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.passwordController.value,
                obscureText: controller.isPasswordHidden.value,
                decoration: InputDecoration(
                  hintText: "Password",
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      controller.isPasswordHidden.toggle();
                    },
                  ),
                ),
              ),
              SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  controller.onLogin();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkNavy,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  child: Center(
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.red)
                        : Text("Login", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.register),
                child: const Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      );
    });
  }
}
