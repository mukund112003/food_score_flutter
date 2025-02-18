import 'package:flutter/material.dart';
import 'package:food_score/Controllers/auth.controller.dart';
import 'package:food_score/Core/widgets/app_snackbar.dart';
import 'package:food_score/core/colors/app_colors.dart';
import 'package:food_score/core/images/app_images.dart';
import 'package:food_score/core/images/general.dart';
import 'package:food_score/core/widgets/app_button.dart';
import 'package:food_score/core/widgets/input_textfield.dart';
import 'package:food_score/core/widgets/page_title.dart';
import 'package:food_score/Screens/auth/view/sign_up_screen.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;
  bool isEmailValid = true;
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());


  void handleLogin(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _authController.loginUser(
            email: _emailTextController.text.trim(),
            password: _passwordTextController.text.trim());
        // Get.to(ScanScreen());
      } catch (e) {
        appBar(text: e.toString());
      }
    }
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            left: 70,
            top: 0,
            child: Image.asset(
              SignInImages.top,
            ),
          ),
          Positioned(
            left: 0,
            top: 110,
            child: Image.asset(
              SignInImages.topLeft,
            ),
          ),
          Positioned(
            right: 0,
            top: 70,
            child: Image.asset(
              SignInImages.topRight,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              SignInImages.bottomRight,
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              SignInImages.bottomLeft,
            ),
          ),
          ListView(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 160),
                      const PageTitle(title: "Log In"),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Access your account now",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.lightBrown),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      InputTextFilled(
                        controller: _emailTextController,
                        textInputType: TextInputType.emailAddress,
                        fieldName: "Email address",
                        hintText: "name@xyz.com",
                        prefixIcon:
                            const Icon(Icons.mail, color: AppColors.lightBrown),
                        suffixIcon: (isEmailValid)
                            ? const Icon(Icons.check_circle,
                                color: AppColors.buttonBackgroundGreen)
                            : const Icon(Icons.close,
                                color: AppColors.errorColor),
                        onChanged: (val) {
                          isEmailValid = false;
                          if (RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(val)) {
                            isEmailValid = true;
                          }
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputTextFilled(
                        isPassword: !isVisible,
                        fieldName: "Password",
                        controller: _passwordTextController,
                        hintText: "********",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                        prefixIcon:
                            const Icon(Icons.lock, color: AppColors.lightBrown),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() {
                            isVisible = !isVisible;
                          }),
                          icon: Icon(
                            isVisible ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.lightBrown,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Forget your password?",
                          style: TextStyle(
                              color: AppColors.darkBrown,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        // width: 120,
                        child: AppButton(
                            onPressed: () => handleLogin(context),
                            backgroundColor: AppColors.buttonBackgroundGreen,
                            text: Obx(
                              () => _authController.isLoading.value
                                  ? CircularProgressIndicator.adaptive(
                                      valueColor: AlwaysStoppedAnimation(
                                          AppColors.white),
                                    )
                                  : Text(
                                      "Submit",
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                            )),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "— Or —",
                        style: TextStyle(
                            fontSize: 14, color: AppColors.lightBrown),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppButton(
                        onPressed: () {},
                        backgroundColor: AppColors.black,
                        prefixIcon: Image.asset(GeneralImage.google),
                        text: const Text(
                          "Login with google",
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Create your new account? ",
                            style: TextStyle(
                                color: AppColors.lightBrown,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const SignUpScreen()));
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                  color: AppColors.darkBrown,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
