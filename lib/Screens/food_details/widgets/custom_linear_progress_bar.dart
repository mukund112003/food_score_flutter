import 'package:flutter/material.dart';

class NutrientsBar extends StatelessWidget {
  const NutrientsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CustomLinearProgressIndicator extends StatelessWidget {
  final double value; // Progress value between 0.0 and 1.0
  final Color backgroundColor;
  final Color foregroundColor;
  final double backgroundHeight;
  final double foregroundHeight;
  final double radius;

  const CustomLinearProgressIndicator({
    super.key,
    required this.value,
    this.backgroundColor = Colors.grey,
    this.foregroundColor = Colors.blue,
    this.backgroundHeight = 10.0,
    this.foregroundHeight = 6.0, this.radius = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Background layer
        Container(
          height: backgroundHeight,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        // Foreground layer (progress)
        FractionallySizedBox(
          widthFactor: value, // Represents progress percentage
          child: Container(
            height: foregroundHeight,
            decoration: BoxDecoration(
              color: foregroundColor,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        ),
      ],
    );
  }
}
