
import 'package:barcelona_bus_transit/model/bus_line.dart';
import 'package:barcelona_bus_transit/utilities/hex_color.dart';
import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  const CircleIcon({
    Key? key,
    required this.busLine,
  }) : super(key: key);

  final BusLine busLine;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        color: hexToColor(busLine.primaryColor),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          busLine.name,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
