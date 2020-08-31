import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isLong;
  final bool isHintFloating;
  final TextInputType inputType;

  InputField({
    @required this.controller,
    this.hint,
    this.isLong = false,
    this.isHintFloating = true,
    this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: isHintFloating ? hint : null,
        hintText: !isHintFloating ? hint : null,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        isDense: true,
        border: OutlineInputBorder(),
        counterText: "",
      ),
      keyboardType: inputType,
      maxLength: isLong ? 200 : 50,
      minLines: isLong ? 3 : 1,
      maxLines: isLong ? 5 : 1,
    );
  }
}
