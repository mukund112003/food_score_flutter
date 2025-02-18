import 'package:flutter/material.dart';
import 'package:food_score/Core/colors/app_colors.dart';
import 'package:get/get.dart';

appBar(
    {required String text,
    Duration duration = const Duration(seconds: 2),
    Color color = AppColors.buttonBackgroundGreen,
    Color textColor = const Color.fromRGBO(255, 255, 255, 1)}) {
  return Get.snackbar(
    "",
    '',
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
    margin: EdgeInsets.symmetric(horizontal: 20),
    duration: duration,
    backgroundColor: color,
    titleText: Text(
      text,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
    ),
    snackPosition: SnackPosition.BOTTOM,
  );
}

// appSnackBar(
//     {required BuildContext context,
//     required String text,
//     Duration duration = const Duration(seconds: 2),
//     Color color = const Color.fromRGBO(32, 201, 151, 1),
//     Color textColor = const Color.fromRGBO(255, 255, 255, 1)}) {
//   return ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       behavior: SnackBarBehavior.floating,
//       showCloseIcon: true,
//       duration: duration,
//       content: Text(
//         text,
//         style: TextStyle(
//             color: textColor, fontSize: 16, fontWeight: FontWeight.w400),
//       ),
//       backgroundColor: color,
//     ),
//   );
// }
