import 'package:flutter/material.dart';
import 'package:food_score/Controllers/scanner.controller.dart';
import 'package:food_score/Core/colors/app_colors.dart';
import 'package:get/get.dart';

class FoodInfo extends StatelessWidget {
  FoodInfo({super.key});
  final ScannerController _scannerController = Get.put(ScannerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        appBar: AppBar(
          leading: IconButton(onPressed: ()=> Get.back(), icon: Icon(Icons.arrow_left)),
          backgroundColor: AppColors.buttonBackgroundGreen,
          title: Text(
            "Food Ingredients",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.white),
          ),
        ),
        body: Obx(
          () {
         return (_scannerController.foodDetails.value.ingredients!.isNotEmpty) ? 
           CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _scannerController.foodDetails.value.productName ?? "Not found",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _scannerController.foodDetails.value.ingredients![index].name ?? "not found",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Text(
                                _scannerController.foodDetails.value.ingredients![index].healthiness ?? "not found",),
                        ],
                      ),
                    );
                  },
                  childCount:    _scannerController.foodDetails.value.ingredients!.length,
                ),
              ),
            ],
          )
            :Text("Ingredients not found");
          }
        ));
  }
}
