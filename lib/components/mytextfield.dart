import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintext;
  final bool isObsecureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintext,
    required this.isObsecureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObsecureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        fillColor: Colors.grey[100],
        filled: true,
        hintText: hintext,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
