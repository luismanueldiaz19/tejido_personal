// Widget para construir los campos de texto
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildTextField(String hintText, TextEditingController controller,
    {bool obscureText = false,
    final List<TextInputFormatter>? inputFormatters,
    TextInputType keyboardType = TextInputType.text}) {
  return Container(
    color: Colors.white,
    height: 50,
    width: 250,
    margin: const EdgeInsets.symmetric(vertical: 5),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(left: 15.0),
      ),
    ),
  );
}
