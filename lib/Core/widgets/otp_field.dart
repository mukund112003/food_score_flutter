import 'package:flutter/material.dart';

class ResponsiveOtpField extends StatefulWidget {
  final int fieldCount; // Number of OTP fields
  final ValueChanged<String?> onCompleted; // Callback when OTP is completed

  const ResponsiveOtpField({
    super.key,
    required this.fieldCount,
    required this.onCompleted,
  });

  @override
  State<ResponsiveOtpField> createState() => _ResponsiveOtpFieldState();
}

class _ResponsiveOtpFieldState extends State<ResponsiveOtpField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.fieldCount, (_) => TextEditingController());
    _focusNodes = List.generate(widget.fieldCount, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < widget.fieldCount - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Check if all fields are filled
    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
      final otp = _controllers.map((controller) => controller.text).join();
      widget.onCompleted(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.fieldCount,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SizedBox(
            width: 50,
            height: 50,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              onChanged: (value) => _onChanged(index, value),
              onSubmitted: (value) {
                // Check if any controller is empty
                bool isAnyFieldEmpty =
                    _controllers.any((controller) => controller.text.isEmpty);

                if (isAnyFieldEmpty) {
                  
                  widget.onCompleted(null); 
                  return;
                }
                String otp =
                    _controllers.map((controller) => controller.text).join();

                widget.onCompleted(otp); 
              },
              textAlign: TextAlign.center,
              maxLength: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                counterText: '',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
