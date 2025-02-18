import 'package:flutter/material.dart';
import 'package:food_score/core/colors/app_colors.dart';
class InputTextFilled extends StatelessWidget {
  final String fieldName;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final bool isPassword;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const InputTextFilled(
      {super.key,
      required this.fieldName,
      this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.isPassword = false,
      this.textInputType,
      this.controller,
      this.onChanged, this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldName,
          style: const TextStyle(
              color: AppColors.lightBrown,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          constraints: const BoxConstraints(maxHeight: 80),
          child: TextFormField(
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            controller: controller,
            keyboardType: textInputType,
            obscureText: isPassword,
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                    fontSize: 16,
                    color: AppColors.lightBrown,
                    fontWeight: FontWeight.w400),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.black),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.lightBrown),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                )),
          ),
        )
      ],
    );
  }
}
