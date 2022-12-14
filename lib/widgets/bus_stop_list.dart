import 'package:barcelona_bus_transit/model/bus_line.dart';
import 'package:barcelona_bus_transit/model/bus_stop.dart';
import 'package:barcelona_bus_transit/utilities/hex_color.dart';
import 'package:barcelona_bus_transit/widgets/bus_stop_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loading.dart';

class StopsListBuilder extends StatelessWidget {
  final List<BusStop> stopsList;
  const StopsListBuilder({super.key, 
    required this.stopsList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: myColor4,
        padding: const EdgeInsets.all(30),
        child: FutureBuilder(
          // Pass the line code from the provider
          future: getBusLine(context.watch<int>()),
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return ErrorWidget(snapshot.error.toString());
            }
            if (!snapshot.hasData) {
              return const Loading();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: roundedDecoration(
                      borderColor: hexToColor(snapshot.data!.primaryColor),
                      interiorColor: hexToColor(snapshot.data!.primaryColor)),
                  child: Center(
                      child: Text(
                    snapshot.data!.name,
                    style:
                        TextStyle(color: hexToColor(snapshot.data!.textColor)),
                  )),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: stopsList.length,
                    itemBuilder: ((context, index) {
                      return StopTile(
                        busStop: stopsList[index],
                        rectColor: hexToColor(snapshot.data!.primaryColor),
                      );
                    }),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

