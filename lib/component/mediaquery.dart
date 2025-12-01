import 'package:flutter/material.dart';


class mediaquery{
  static late MediaQueryData _mediaQueryData;
  static late double screenwidth;
  static late double screenheight;

  static void init(BuildContext context){

_mediaQueryData = MediaQuery.of(context);
screenheight = _mediaQueryData.size.height;
screenwidth = _mediaQueryData.size.width;





  }






}