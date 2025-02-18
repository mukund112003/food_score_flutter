import 'package:dio/dio.dart';
import 'package:food_score/Core/widgets/app_snackbar.dart';
import 'package:food_score/Remote/api_client.dart';
import 'package:food_score/Remote/api_endpoints.dart';
import 'package:food_score/Remote/api_exception.dart';
import 'package:food_score/Screens/auth/view/sign_in_screen.dart';
import 'package:food_score/Screens/auth/view/verification_screen.dart';
import 'package:food_score/Screens/scan/scan_screen.dart';
import 'package:food_score/Utils/shared_prefrences.dart';
import 'package:food_score/model/user.model.dart';
import 'package:get/get.dart' hide Response;
import 'package:velocity_x/velocity_x.dart';

class AuthController extends GetxController with ApiClientMixin {
  var isLoading = false.obs;
  var isUserLogin = false.obs;

  @override
  void onInit() {
    checkAuthStatus();
    super.onInit();
  }

  void checkAuthStatus() {
    String? token = Utils.getToken();
    isUserLogin.value = (token != null && token.isNotEmpty) ? true : false;
  }

  Future<void> loginUser(
      {required String email, required String password}) async {
    Map<String, dynamic> loginBody = {
      "email": email,
      'password': password,
    };
    try {
      isLoading(true);
      Response response =
          await postRequest(path: ApiEndPoints.login, body: loginBody);

      if (!response.data['status']) return;

      if (response.data['userInfo']['token'] != null) {
        await Utils.saveToken(response.data['userInfo']['token']);
      }

      UserModel userInfo =
          UserModel.fromJson(response.data['userInfo'] as Map<String, dynamic>);
      await Utils.saveUser(userInfo);
      Get.offAll(ScanScreen());
      appBar(text: "Login successfull");
      return;
    } on ApiException catch (e) {
      Vx.log("API Error: ${e.statusCode} - ${e.message}");
      throw e.message; // Let the UI handle the error message
    } on DioException catch (e) {
      Vx.log("Network Error: ${e.message}");
      throw "Network error, please try again.";
    } catch (e) {
      Vx.log("Unexpected Error: $e");
      throw "Something went wrong, please try again.";
    } finally {
      isLoading(false);
    }
  }

  Future<void> registerUser(
      {required String email,
      required String password,
      required String name}) async {
    Map<String, dynamic> registerBody = {
      "fullName": name,
      "email": email,
      "phonenumber": "12389454734",
      'password': password,
    };

    try {
      isLoading(true);

      Response response =
          await postRequest(path: ApiEndPoints.register, body: registerBody);

      if (response.data != null && response.data['status']) {
        appBar(text: response.data['message']);
      }
      Get.offAll(VerificationScreen());
    } on ApiException catch (e) {
      Vx.log("API Error: ${e.statusCode} - ${e.message}");
      throw e.message; // Let the UI handle the error message
    } on DioException catch (e) {
      Vx.log("Network Error: ${e.message}");
      throw "Network error, please try again.";
    } catch (e) {
      Vx.log("Unexpected Error: $e");
      throw "Something went wrong, please try again.";
    } finally {
      isLoading(false);
    }
  }

  void sendOtp({required String phNumber}) async {
    try {
      Map<String, dynamic> otpBody = {
        "phoneNumber": phNumber,
      };

      Response response =
          await postRequest(path: ApiEndPoints.sendOTP, body: otpBody);

      if (!response.data['status']) {
        throw ApiException(500, "OTP didn't send, Try again");
      }
      appBar(text: response.data['message']);
    } on ApiException catch (e) {
      Vx.log("API Error: ${e.statusCode} - ${e.message}");
      throw e.message; // Let the UI handle the error message
    } on DioException catch (e) {
      Vx.log("Network Error: ${e.message}");
      throw "Network error, please try again.";
    } catch (e) {
      Vx.log("Unexpected Error: $e");
      throw "Something went wrong, please try again.";
    } finally {}
  }

  Future verifyOtp({required String phNumber, required String otp}) async {
    try {
      Map<String, dynamic> otpBody = {
        "phoneNumber": phNumber,
        "otp": otp,
      };
      Response response =
          await postRequest(path: ApiEndPoints.verifyOTP, body: otpBody);

      if (!response.data['status']) throw ApiException(500, "OTP didn't send, Try again");

      appBar(text: response.data['message']);
      Get.offAll(SignInScreen());
    } on ApiException catch (e) {
      Vx.log("API Error: ${e.statusCode} - ${e.message}");
      throw e.message; // Let the UI handle the error message
    } on DioException catch (e) {
      Vx.log("Network Error: ${e.message}");
      throw "Network error, please try again.";
    } catch (e) {
      Vx.log("Unexpected Error: $e");
      throw "Something went wrong, please try again.";
    } finally {}
  }
}
