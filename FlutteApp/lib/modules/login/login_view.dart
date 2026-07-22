import 'package:demo_sccess_refresh_token_app/modules/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(LoginController());
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  textAlign: TextAlign.center,
                  "Login App",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.usernameController.value,
                decoration: InputDecoration(
                  hint: Text("Username"),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.passwordController.value,
                decoration: InputDecoration(
                  hint: Text("Password"),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 50),
              GestureDetector(
                onTap: (){
                  controller.onLogin();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  child: Center(
                    child:controller.isLoading.value  ?
                    CircularProgressIndicator(color: Colors.red,):
                      Text("Login", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
