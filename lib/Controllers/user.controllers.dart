import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:food_score/Core/widgets/app_snackbar.dart';
import 'package:food_score/Remote/api_client.dart';
import 'package:food_score/Remote/api_endpoints.dart';
import 'package:food_score/Remote/api_exception.dart';
import 'package:food_score/Screens/auth/view/sign_in_screen.dart';
import 'package:food_score/Utils/shared_prefrences.dart';
import 'package:food_score/model/user.model.dart';
import 'package:get/get.dart' hide Response;
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class UserController extends GetxController with ApiClientMixin {
  var isUserLoading = false.obs;
  var isPasswordReseting = false.obs;
  var user = UserModel().obs;
  var userProfileSelect = Rxn<XFile>();
  var userProfileImage = Rxn<Uint8List>();

  void _base64ToImage() {
    if (user.value.image != null) {
      userProfileImage(base64Decode(user.value.image!));
    }
  }

  Future<void> getUser() async {
    String? token = Utils.getToken();
    UserModel? currentUser = Utils.getUser();
    if (token == null || currentUser == null) return;

    isUserLoading(true);
    try {
      if (currentUser.image == null) {
        Response response = await getRequest(
            path: ApiEndPoints.getUser, body: {}, jwtToken: token);

        if (!response.data['status']) return;

        UserModel userInfo =
            UserModel.fromJson(response.data['data'] as Map<String, dynamic>);

        user.value = userInfo;
        _base64ToImage();

        return;
      } else {
        user.value = currentUser;
      }
    } catch (e) {
      Vx.log("Error while getting user: $e");
    } finally {
      isUserLoading(false);
    }
  }

  Future<void> updateUser(Map<String, dynamic> updateData) async {
    String? token = Utils.getToken();
    if (token == null) return;

    try {
      Response response = await putRequest(
          path: ApiEndPoints.updateUser, body: updateData, jwtToken: token);

      if (!response.data['status']) {
        throw "Unable to update\nresponse status is false";
      }
      UserModel userInfo =
          UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
      user.value = userInfo;
      _base64ToImage();
    } on ApiException catch (error) {
      appBar(text: error.message);
    } catch (e) {
      Vx.log("Error while updating User: $e ");
    }
  }

  Future<void> deleteUser({required String password}) async {
    String? token = Utils.getToken();
    if (token == null || token.isEmpty) return;

    Map<String, dynamic> body = {"password": password};

    try {
      isPasswordReseting(true);
      Response response = await deleteRequest(
          path: ApiEndPoints.deletesUser, body: body, jwtToken: token);
      if (!response.data['status']) throw "Delete User status false";
      await Utils.removeToken();
      await Utils.removeUser();
      userProfileImage.value = null;
      user.value = UserModel();
      appBar(text: response.data['message']);
    } catch (e) {
      Vx.log("Error while deleting user $e");
    } finally {
      isPasswordReseting(false);
    }
  }

  void logout() async {
    try {
      await Utils.removeToken();
      await Utils.removeUser();
      userProfileImage.value = null;
      user.value = UserModel();

      Get.offAll(() => SignInScreen());
    } catch (e) {
      appBar(text: "Log out failed $e");
    }
  }

  Future<void> resetPassword(
      {required String password, required String newPassword}) async {
    Map<String, dynamic> updatePassword = {
      "password": password,
      "newPassword": newPassword,
    };

    String? token = Utils.getToken();
    try {
      isPasswordReseting(true);
      Response response = await putRequest(
          path: ApiEndPoints.resetPassword,
          body: updatePassword,
          jwtToken: token);

      if (!response.data['status']) {
        appBar(text: response.data['message']);
        return;
      }

      appBar(text: response.data['message']);
    } on ApiException catch (e) {
      appBar(text: e.message);
    } catch (e) {
      Vx.log("Error while reseting password : $e");
      appBar(text: e.toString());
    } finally {
      isPasswordReseting(false);
    }
  }
}
