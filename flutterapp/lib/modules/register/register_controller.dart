import 'package:demo_sccess_refresh_token_app/models/register/RegisterRequest.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_sccess_refresh_token_app/core/services/api_service.dart';
import 'package:demo_sccess_refresh_token_app/constants/colors.dart';

class RegisterController extends GetxController {
  RegisterController({required this.apiService});

  final ApiService apiService;

  // Text Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Loading state
  final isLoading = false.obs;

  Future<void> onRegister() async {
    // =========================
    // Validation
    // =========================

    if (usernameController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Username is required",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Password is required",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please confirm your password",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Prevent double click
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      // =========================
      // Register Request
      // =========================

      final result = await apiService.register(
        RegisterRequest(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          username: usernameController.text.trim(),
          email: emailController.text.trim(),
          phoneNumber: phoneController.text.trim(),
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text,
        ),
      );

      // Debug
      debugPrint("REGISTER RESULT: $result");
      debugPrint("REGISTER TYPE: ${result.runtimeType}");

      // =========================
      // Success
      // =========================

      final message =
          result['message']?.toString() ?? "Account created successfully";

      Get.snackbar(
        "Success",
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.darkNavy,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Give snackbar a little time to appear
      await Future.delayed(const Duration(milliseconds: 500));

      // Go back to Login
      Get.back();
    } on DioException catch (e) {
      // =========================
      // Backend Error
      // =========================

      debugPrint("REGISTER ERROR: ${e.response?.data}");

      String message = "Registration failed. Please try again.";

      if (e.response?.data is Map) {
        final data = e.response!.data as Map;

        if (data['message'] != null) {
          message = data['message'].toString();
        }
      }

      Get.snackbar(
        "Registration Failed",
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      // =========================
      // Unknown Error
      // =========================

      debugPrint("REGISTER UNKNOWN ERROR: $e");

      Get.snackbar(
        "Error",
        "Registration failed. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}
