import 'package:get/get.dart';
import 'package:demo_sccess_refresh_token_app/middleware/auth_middleware.dart';
import 'package:demo_sccess_refresh_token_app/modules/home/home_binding.dart';
import 'package:demo_sccess_refresh_token_app/modules/home/home_view.dart';
import 'package:demo_sccess_refresh_token_app/modules/login/login_binding.dart';
import 'package:demo_sccess_refresh_token_app/modules/login/login_view.dart';
import 'package:demo_sccess_refresh_token_app/modules/splash/splash_binding.dart';
import 'package:demo_sccess_refresh_token_app/modules/splash/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashView(), binding: SplashBinding()),
    GetPage(name: AppRoutes.login, page: () => const LoginView(), binding: LoginBinding()),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}