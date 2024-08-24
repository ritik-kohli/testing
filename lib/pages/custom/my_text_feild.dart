import 'package:flutter/material.dart';

class MyTextFeild extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final FormFieldValidator<String> validator;
  final Function(String) onChanged;

 const MyTextFeild({super.key,required this.controller,required this.hintText, required this.maxLines, required this.validator, required this.onChanged,});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 12,bottom: 12,left: 16,right: 16),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 0.6),
          borderRadius: BorderRadius.circular(4),
        ),
        labelText: null,
      ),
      
      validator: validator,
      onChanged: onChanged,
    );
  }
}
