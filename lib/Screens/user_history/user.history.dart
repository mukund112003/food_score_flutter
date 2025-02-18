import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:food_score/Controllers/scanner.controller.dart';
import 'package:food_score/Core/colors/app_colors.dart';
import 'package:food_score/Core/images/general.dart';
import 'package:food_score/model/userhistory.model.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';


class UserHistory extends StatefulWidget {
  const UserHistory({super.key});

  @override
  State<UserHistory> createState() => _UserHistoryState();
}

class _UserHistoryState extends State<UserHistory> {
  final ScannerController _scannerController = Get.put(ScannerController());

  @override
  void initState() {
    getUserHistory();
    super.initState();
  }

  void getUserHistory() async {
    await _scannerController.getHistory();
    }

  @override
  Widget build(BuildContext context) {
    getUserHistory();
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: ListView.builder(
        itemCount: _scannerController.userHistoryList.length,
        itemBuilder: (context, index) {

          FoodHistoryModel uh = _scannerController.userHistoryList[index];

          Vx.log(uh);
          Uint8List? img;
          if(uh.productImage != null){
          img= base64Decode(uh.productImage!);

          }
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.yellowShade),
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
               (img != null) ? Image.memory(img):   Image.asset(GeneralImage.defaultProfilePicture),
                SizedBox(width: 10),
                Expanded(
                  child:Obx(
                    ()=> _scannerController.userHistoryList.isNotEmpty ? 
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(uh.productName ?? " Test", style: TextStyle(fontSize: 22)),
                      Row(
                        children: [
                          Text("${uh.ingredients?[0].name} : ", style: TextStyle(fontSize: 18)),
                          Expanded(
                            // Wraps overflowing text properly
                            child: Text(
                              uh.ingredients?[0].healthiness ?? "no found",
                              style: TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1, // Set to control text wrapping
                            ),
                          ),
                        ],
                      ),
                    ],
                  ):
                  Text("History not Found")
                )
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
