import 'package:barcelona_bus_transit/model/bus_line.dart';
import 'package:barcelona_bus_transit/widgets/appbar.dart';
import 'package:barcelona_bus_transit/widgets/bus_line_tile.dart';
import 'package:barcelona_bus_transit/model/hex_color.dart';
import 'package:flutter/material.dart';

class LinesListScreen extends StatelessWidget {
  const LinesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          //Here is the preferred height.
          preferredSize: Size.fromHeight(100),
          child: CustomAppbar(
            title: "Bus Lines",
          )),
      body: _busLinesFutureBuilder(),
    );
  }

  FutureBuilder<List<BusLine>> _busLinesFutureBuilder() {
    return FutureBuilder(
      future: loadAllBusesLines(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return _LinesTileBuilder(linesList: snapshot.data!);
      },
    );
  }
}

class _LinesTileBuilder extends StatelessWidget {
  final List<BusLine> linesList;
  const _LinesTileBuilder({
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
