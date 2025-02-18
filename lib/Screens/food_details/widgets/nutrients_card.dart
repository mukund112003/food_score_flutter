import 'package:flutter/material.dart';
import 'package:food_score/core/colors/app_colors.dart';
import 'package:food_score/Screens/food_details/widgets/custom_linear_progress_bar.dart';

class NutrientCard extends StatelessWidget {
  final String nutrientsName;
  final double nutrientsPercentage;

  const NutrientCard(
      {super.key,
      required this.nutrientsName,
      required this.nutrientsPercentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.sizeOf(context).width / 2) - 20,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      color: Colors.transparent,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nutrientsName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              const Spacer(),
              Text("${nutrientsPercentage * 100} gm/100gm",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ))
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          CustomLinearProgressIndicator(
            value: nutrientsPercentage,
            backgroundColor: AppColors.linearProgressBackground,
            foregroundColor: AppColors.buttonBackgroundGreen,
            backgroundHeight: 2,
            foregroundHeight: 4,
          )
        ],
      ),
    );
  }
}
