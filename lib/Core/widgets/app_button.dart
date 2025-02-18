import 'package:flutter/material.dart';
import 'package:food_score/core/colors/app_colors.dart';

class AppButton extends StatelessWidget {
  final double? width;
  final VoidCallback onPressed;
  final Widget text;
  final Widget? prefixIcon;
  final Color backgroundColor;
  final BorderSide? border;
  const AppButton({
    super.key,
    this.width,
    required this.onPressed,
    required this.text,
    this.prefixIcon,
    this.backgroundColor = AppColors.white,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            fixedSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: border ?? BorderSide.none),
            backgroundColor: backgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              prefixIcon ?? const SizedBox(),
              const SizedBox(width: 5),
              text
            ],
          )),
    );
  }
}
