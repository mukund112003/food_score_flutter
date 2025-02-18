import 'package:flutter/material.dart';
import 'package:food_score/core/colors/app_colors.dart';
import 'package:food_score/core/images/app_images.dart';
import 'package:food_score/core/widgets/app_button.dart';
import 'package:food_score/core/widgets/page_title.dart';
import 'package:food_score/Screens/food_details/widgets/circular_indicator.dart';
import 'package:food_score/Screens/food_details/widgets/nutrients_card.dart';
import 'package:food_score/Screens/scan/scan_screen.dart';

class FoodDetailsScreen extends StatelessWidget {
  const FoodDetailsScreen({super.key});

  static List<String> nutrientsName = [
    "Protien",
    "Fats",
    "Carbohydrates",
    "Fiber"
  ];
  static List<double> nutrientsValue = [0.3, 0.2, 0.7, 0.5];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(251, 224, 160, 0.2),
        title: const PageTitle(title: "Product Health Source"),
        centerTitle: true,
        elevation: 0,
        leading: Container(
          padding: const EdgeInsets.only(left: 12),
          alignment: Alignment.center,
          child: IconButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => ScanScreen())),
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
      ),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          children: [
            Positioned(
              bottom: 120,
              child: Image.asset(
                ScannerImages.scannerBackground,
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 416,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 3,
                            spreadRadius: 0.1,
                            offset: Offset(0, -0.1))
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(52),
                        topRight: Radius.circular(52),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const PageTitle(
                        title: "Nutrient Value",
                        size: 20,
                        weight: FontWeight.bold,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            height: 150,
                            width: 150,
                            child: CircularIndicator(progress: 75),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: nutrientsName.length,
                              itemBuilder: (context, index) {
                                return NutrientCard(
                                  nutrientsName: nutrientsName[index],
                                  nutrientsPercentage: nutrientsValue[index],
                                );
                              },
                            ),
                          )
                        ],
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 180),
                        child: AppButton(
                          onPressed: () {},
                          text: const Text(
                            "It's healthy",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: AppColors.buttonBackgroundGreen,
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
