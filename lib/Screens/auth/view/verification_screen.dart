import 'package:flutter/material.dart';
import 'package:food_score/Controllers/auth.controller.dart';
import 'package:food_score/Core/widgets/app_snackbar.dart';
import 'package:food_score/core/colors/app_colors.dart';
import 'package:food_score/core/images/general.dart';
import 'package:food_score/core/widgets/app_button.dart';
import 'package:food_score/core/widgets/otp_field.dart';
import 'package:food_score/core/widgets/page_title.dart';
import 'package:get/get.dart';


class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final AuthController _authController = Get.put(AuthController());

  @override
  void initState() {
    sendOTP();
    super.initState();
  }

  void sendOTP(){
    try {
      _authController.sendOtp(phNumber: "9879074498");
    } catch (e) {
      appBar(text: e.toString());
    }
  }

  void verifyOTP(String oTP)async{
    try {
      await _authController.verifyOtp(phNumber: "9879074498", otp:oTP );
    } catch (e) {
        appBar(text: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const PageTitle(title: "Verification"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          // onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonBackgroundGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(
            Icons.arrow_back_ios_new_sharp,
            size: 18,
            color: AppColors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        clipBehavior: Clip.hardEdge,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset(GeneralImage.verification),
              const SizedBox(height: 50),
              const PageTitle(
                title: "Verification Code",
                size: 32,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 10),
              const Text(
                "We have to send the code verification to your \nmobile number",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightBrown,
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 60,
                child: ResponsiveOtpField(
                  fieldCount: 6,
                  onCompleted: (otp) {
                    if(otp == null) return;
                    verifyOTP(otp.toString());
                  },
                ),
              ),
              const SizedBox(height: 50),
              AppButton(
                onPressed: () {
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (_) => const ScanScreen()));
                },
                text: const Text(
                  "Submit",
                  style: TextStyle(color: AppColors.white, fontSize: 16),
                ),
                backgroundColor: AppColors.buttonBackgroundGreen,
              ),
              const SizedBox(height: 20),
              AppButton(
                onPressed: () {
                  appBar(
                    text: "OTP sent again",
                  );
                },
                text: const Text(
                  "Send again",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(91, 91, 91, 1),
                  ),
                ),
                backgroundColor: AppColors.white,
                border: const BorderSide(
                  color: Color.fromRGBO(91, 91, 91, 1),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
