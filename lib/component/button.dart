import 'package:flutter/material.dart';


class Button extends StatelessWidget {

  final String title;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  final Color? textColor;
  final double? textSize;

  final bool loading ;



  const Button({super.key,
  required this.title,
    this.textSize,
  required this.onTap,
    this.textColor,
    this.height,
    this.width,
  this.loading = false,
  });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: height ?? 50,
          width: width ?? 250,

          decoration: BoxDecoration(
            color: Colors.green[900],
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),

          child: Center(child: loading ? CircularProgressIndicator(strokeWidth: 3,color: Colors.white,):
          Text(title,style: TextStyle(fontSize:  textSize ?? 20,color: textColor ?? Colors.white,fontWeight: FontWeight.bold),))
      ),
    );
  }
}



