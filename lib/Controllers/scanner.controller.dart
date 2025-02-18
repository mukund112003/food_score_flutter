import 'package:dio/dio.dart';
import 'package:food_score/Core/widgets/app_snackbar.dart';
import 'package:food_score/Remote/api_client.dart';
import 'package:food_score/Remote/api_endpoints.dart';
import 'package:food_score/Utils/shared_prefrences.dart';
import 'package:food_score/model/food_details.model.dart';
import 'package:food_score/model/userhistory.model.dart';
import 'package:get/get.dart' hide Response;
import 'package:velocity_x/velocity_x.dart';

class ScannerController extends GetxController with ApiClientMixin {
  var isImageScanning = false.obs;
  var foodDetails = FoodDetails().obs;
  var userHistoryList = <FoodHistoryModel>[].obs;

  Future<void> scanImage({required String base64Image}) async {
    Map<String, dynamic> body = {"base64Image": base64Image};

    String? token = Utils.getToken();

    if (token == null || token.isEmpty) return;

    try {
      isImageScanning(true);
      Response response = await postRequest(
          path: ApiEndPoints.scanProduct, body: body, jwtToken: token);

      if (!response.data['status']) return;
      foodDetails.value = FoodDetails.fromJson(response.data["data"]);

      appBar(text: response.data['message']);
    } catch (e) {
      Vx.log("Error while Scanning Image $e");
    } finally {
      isImageScanning(false);
    }
  }

  Future<void> getHistory() async {
    String? token = Utils.getToken();
    if (token == null || token.isEmpty) return;
    try {
      Response response = await getRequest(
          path: ApiEndPoints.getUserHistory, body: {}, jwtToken: token);

      if (!response.data['status']) return;

      if (response.data['data'] == null) throw "History not found";
      var data = response.data['data']['foodDetails'];

      // userHistoryList.value = List<FoodHistoryModel>.from(
      //     data.map((e) => FoodHistoryModel.fromJson(e)));

    userHistoryList.value = data.map<FoodHistoryModel>((e) {
      return FoodHistoryModel.fromJson(e);
    }).toList();      
    } catch (e) {
      Vx.log("Error while getting user history ${e.toString()}");
    }
  }
}
