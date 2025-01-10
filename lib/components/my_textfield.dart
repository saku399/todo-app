import 'package:flutter/material.dart';
import 'package:to_do_app/constants/color.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode? focusNode;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.focusNode
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        focusNode:focusNode,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: tdBlack),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: tdBlack),
          ),
          fillColor: tdBGColor,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: tdGrey),
        ),
      ),
    );
  }
}
