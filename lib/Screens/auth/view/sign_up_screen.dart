import 'package:flutter/material.dart';
import 'package:food_score/Controllers/auth.controller.dart';
import 'package:food_score/Core/widgets/app_snackbar.dart';
import 'package:food_score/core/colors/app_colors.dart';
import 'package:food_score/core/images/app_images.dart';
import 'package:food_score/core/images/general.dart';
import 'package:food_score/core/widgets/app_button.dart';
import 'package:food_score/core/widgets/input_textfield.dart';
import 'package:food_score/core/widgets/page_title.dart';
import 'package:food_score/Screens/auth/view/sign_in_screen.dart';
import 'package:get/get.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;
  bool isEmailValid = true;
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final stopwatch = Stopwatch();

  final AuthController _authController = Get.put(AuthController());

  void handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
       await  _authController.registerUser(
          email: _emailTextController.text.toLowerCase().trim(),
          password: _passwordTextController.text.trim(),
          name: _nameTextController.text.trim(),
        );
      } catch (e) {
        appBar(text: e.toString());
      }
    }
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _nameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            right: 60,
            top: 0,
            child: Image.asset(
              SignUpImages.top,
            ),
          ),
          Positioned(
            left: 0,
            top: 100,
            child: Image.asset(
              SignUpImages.topLeft,
            ),
          ),
          Positioned(
            right: 0,
            top: 70,
            child: Image.asset(
              SignUpImages.topRight,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              SignUpImages.bottomRight,
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              SignUpImages.bottomLeft,
            ),
          ),
          ListView(

            children: [
              const SizedBox(height: 150),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const PageTitle(title: "Sign Up"),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Create your new account to get started!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.lightBrown,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InputTextFilled(
                        controller: _nameTextController,
                        fieldName: "Full name",
                        hintText: "Enter your name",
                        prefixIcon: Icon(
                          Icons.person,
                          size: 18,
                          color: AppColors.lightBrown,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your name";
                          }
                          if (value.length < 4) {
                            return "Name must be atleast 4 char";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputTextFilled(
                        controller: _emailTextController,
                        textInputType: TextInputType.emailAddress,
                        fieldName: "Email address",
                        hintText: "name@xyz.com",
                        prefixIcon: const Icon(Icons.mail,
                            size: 18, color: AppColors.lightBrown),
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
                        hintText: "********",
                        controller: _passwordTextController,
                        prefixIcon: const Icon(Icons.lock,
                            size: 18, color: AppColors.lightBrown),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() {
                            isVisible = !isVisible;
                          }),
                          icon: Icon(
                            isVisible ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.lightBrown,
                            size: 20,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: AppButton(
                            onPressed: () => handleRegister(),
                            backgroundColor: AppColors.buttonBackgroundGreen,
                            text: Obx(() => _authController.isLoading.value
                                ? CircularProgressIndicator.adaptive(
                                    valueColor:
                                        AlwaysStoppedAnimation(AppColors.white),
                                  )
                                : Text(
                                    "Submit",
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
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
                          "Sign up with google ",
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
                            "Already have an account? ",
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
                                      builder: (_) => const SignInScreen()));
                            },
                            child: const Text(
                              "Log In",
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
