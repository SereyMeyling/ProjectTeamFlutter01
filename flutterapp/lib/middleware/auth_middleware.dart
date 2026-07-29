import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_sccess_refresh_token_app/data/local/token_store_local.dart';
import 'package:demo_sccess_refresh_token_app/routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (!TokenStoreLocal.hasValidSession()) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}