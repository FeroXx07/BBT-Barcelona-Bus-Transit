import 'package:barcelona_bus_transit/model/bus_line.dart';
import 'package:barcelona_bus_transit/model/bus_stop.dart';
import 'package:barcelona_bus_transit/widgets/appbar.dart';
import 'package:barcelona_bus_transit/widgets/bus_stop_tile.dart';
import 'package:barcelona_bus_transit/model/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StopsListScreen extends StatelessWidget {
  const StopsListScreen({super.key});

  // The main screen of the page with its appbar
  @override
  Widget build(BuildContext context) {
    final lineCode = ModalRoute.of(context)!.settings.arguments as int;
    return Provider.value(
      value: lineCode,
      child: Scaffold(
        appBar: const PreferredSize(
          //Here is the preferred height.
          preferredSize: Size.fromHeight(100),
          child: CustomAppbar(title: "Bus Stops"),
        ),
        body: _busStopsFutureBuilder(lineCode),
      ),
    );
  }

  // The future builder correctnes procedure
  FutureBuilder<List<BusStop>> _busStopsFutureBuilder(int code) {
    return FutureBuilder(
      future: loadAllBusesStopsFromCode(code),
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
        return _StopsListBuilder(stopsList: snapshot.data!);
      },
    );
  }
}

class _StopsListBuilder extends StatelessWidget {
  final List<BusStop> stopsList;
  const _StopsListBuilder({
    required this.stopsList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: myColor4,
        padding: const EdgeInsets.only(left: 30, top: 30, bottom: 30),
        child: FutureBuilder(
          // Pass the line code from the provider
          future: getBusLine(context.watch<int>()),
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return ErrorWidget(snapshot.error.toString());
            }
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
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

