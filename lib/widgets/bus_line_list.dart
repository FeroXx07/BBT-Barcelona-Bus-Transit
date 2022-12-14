import 'package:barcelona_bus_transit/model/bus_line.dart';
import 'package:barcelona_bus_transit/utilities/hex_color.dart';
import 'package:barcelona_bus_transit/widgets/bus_line_tile.dart';
import 'package:flutter/material.dart';

class LinesTileBuilder extends StatelessWidget {
  final List<BusLine> linesList;
  const LinesTileBuilder({super.key, 
    required this.linesList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: Container(
          color: myColor3,
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: linesList.length,
            itemBuilder: (context, index) {
              return LineTile(busLine: linesList[index]);
            },
          ),
        ),
      ),
    );
  }
}