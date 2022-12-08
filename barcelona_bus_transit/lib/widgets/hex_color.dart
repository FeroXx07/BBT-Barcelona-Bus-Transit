import 'package:flutter/material.dart';

/// Construct a color from a hex code string, of the format #RRGGBB.
Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

const myColor1 = Color(0xFFB80C09);
const myColor2 = Color(0xFF2B2D42);
const myColor3 = Color(0xFF8D99AE);
const myColor4 = Color(0xFFEDF2F4);
const myColor5 = Color(0xFF668F80);