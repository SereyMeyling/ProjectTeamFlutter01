import 'package:demo_sccess_refresh_token_app/modules/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_sccess_refresh_token_app/constants/colors.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller.firstNameController,
                decoration: const InputDecoration(labelText: "First Name"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.lastNameController,
                decoration: const InputDecoration(labelText: "Last Name"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.usernameController,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkNavy,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.onRegister,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
