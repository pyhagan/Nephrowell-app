import 'package:flutter/material.dart';

class TextfieldInpute extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final IconData icon;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextStyle? hintStyle;

  const TextfieldInpute({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    this.onChanged,
    required this.icon,
    this.validator,
    this.hintStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        obscureText: isPass,
        onChanged: onChanged,
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintStyle ?? TextStyle(color: Colors.black45, fontSize: 14),
          prefixIcon: Icon(
            icon,
            color: Colors.black45,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          filled: true,
          fillColor: const Color(0xFFedf0f8),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 2,
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
