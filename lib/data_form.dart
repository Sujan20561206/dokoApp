import 'package:flutter/material.dart';

class DataForm extends StatelessWidget {
  const DataForm({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.isPass,
    required this.keyboardtype,
    required this.icondata,
    this.maxLength,
    required this.textinputaction,
    this.validator,
  }) : super(key: key);
  final String hintText;
  final TextEditingController controller;
  final bool isPass;
  final TextInputType keyboardtype;
  final TextInputAction textinputaction;
  final IconData icondata;
  final String? Function(String? value)? validator;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: const Color(0xFFCECECE), width: 0)),
      child: Container(
        margin: const EdgeInsets.only(left: 16, bottom: 0, right: 4.0),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          enabled: true,
          textInputAction: textinputaction,
          keyboardType: keyboardtype,
          cursorColor: Colors.black,
          obscureText: isPass ? true : false,
          controller: controller,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1C1C1C).withOpacity(0.7)),
          decoration: InputDecoration(
            errorBorder: InputBorder.none,
            suffixIcon: Icon(icondata),
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: 14,
                color: const Color(0xFF1C1C1C).withOpacity(0.3),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600),
            border: InputBorder.none,
          ),
          // validator: validator,
          maxLength: maxLength,
        ),
      ),
    );
  }
}
