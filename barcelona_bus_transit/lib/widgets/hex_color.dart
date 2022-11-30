import 'package:flutter/material.dart';

/// Construct a color from a hex code string, of the format #RRGGBB.
Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

// extension HexToColor on String {
//   Color hexToColor() {
//     return Color(
//         int.parse(toLowerCase().substring(1, 7), radix: 16) + 0xFF000000);
//   }
// }