import 'package:barcelona_bus_transit/model/bus_line.dart';
import 'package:barcelona_bus_transit/utilities/hex_color.dart';
import 'package:flutter/material.dart';

class CircleIconFromBusLine extends StatelessWidget {
  const CircleIconFromBusLine({
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

class CircleIconFromColor extends StatelessWidget {
  const CircleIconFromColor({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
