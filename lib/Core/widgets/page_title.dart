
import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final double size;
  final FontWeight weight;
  const PageTitle({super.key, required this.title, this.size = 24, this.weight = FontWeight.bold});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: size, fontWeight: weight),
    );
  }
}
