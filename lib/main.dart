import 'package:flutter/material.dart';
import 'package:food_score/Controllers/auth.controller.dart';
import 'package:food_score/Screens/scan/scan_screen.dart';
import 'package:food_score/Utils/shared_prefrences.dart';
import 'package:get/get.dart';

import 'Screens/auth/view/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Utils.init();
  Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AuthController authService = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: "NotoSansThaiLooped",
          useMaterial3: true,
        ),
        home: Obx(
          () => authService.isUserLogin.value
              ? const ScanScreen()
              : const SignInScreen(),
        ));
  }
}
