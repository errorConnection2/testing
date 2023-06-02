import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

const Color isabelleClr = Color(0XFFf4f0ec);
const Color vividPinkClr = Color(0XFFFF2E63);
const Color cyanClr = Color(0XFF08D9D6);
const Color white = Colors.white;
const primaryClr = bataClr;
const Color darkGreyClr = Color(0XFF252A34);
const darkHeaderClr = Color(0XFF595260);
const Color bataClr = Color(0XFF202d3d);

class Themes {
  static final light = ThemeData(
      backgroundColor: Colors.white,
      primaryColor: primaryClr,
      brightness: Brightness.light);

  static final dark = ThemeData(
      backgroundColor: darkGreyClr,
      primaryColor: darkGreyClr,
      brightness: Brightness.dark);
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
      color: Get.isDarkMode?Colors.grey[400]:Colors.grey));
}

TextStyle get HeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,      
      color: Get.isDarkMode?Colors.white:Colors.black));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,      
      color: Get.isDarkMode?Colors.white:Colors.black87));
}
TextStyle get subtitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,      
      color: Get.isDarkMode?Colors.grey[100]:Colors.grey[600]));
}