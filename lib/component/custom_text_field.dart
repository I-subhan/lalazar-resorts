
import 'package:flutter/material.dart';



class CustomTextField extends StatelessWidget {


  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final  Color? color;
  final VoidCallback? onTap;
  final bool obscure;
  final bool isNumber;
  final String? Function(String?)? validator;



  const CustomTextField({super.key,
  required this.controller,
    this.isNumber = false,
    this.onTap,
    this.validator,
  required this.hint,
  required this.icon,
    this.color,
  this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number:TextInputType.text,
      obscureText: obscure,
      style: TextStyle(color: Colors.black),
      validator: validator,
      readOnly: onTap != null,
      onTap: onTap,
      decoration: InputDecoration(

        hintText: hint,
        hintStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(icon,color: color,),
        contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),



        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white),
        ),

      ),


    );
  }
}



