import 'package:barcelona_bus_transit/model/bus_line.dart';
import 'package:barcelona_bus_transit/widgets/appbar.dart';
import 'package:barcelona_bus_transit/widgets/bus_line_list.dart';
import 'package:barcelona_bus_transit/widgets/loading.dart';
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
         return const Loading();
        }
        return LinesTileBuilder(linesList: snapshot.data!);
      },
    );
  }
}


