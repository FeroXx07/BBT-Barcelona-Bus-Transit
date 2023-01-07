import 'package:barcelona_bus_transit/model/bus_stop.dart';
import 'package:barcelona_bus_transit/utilities/hex_color.dart';
import 'package:barcelona_bus_transit/widgets/appbar.dart';
import 'package:barcelona_bus_transit/widgets/stop_connection_tile.dart';
import 'package:flutter/material.dart';

class StopTimingsListScreen extends StatelessWidget {
  const StopTimingsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final busStop = ModalRoute.of(context)!.settings.arguments as BusStop;
    return Scaffold(
      appBar: const PreferredSize(
        //Here is the preferred height.
        preferredSize: Size.fromHeight(100),
        child: CustomAppbar(
          title: "Bus Lines",
        ),
      ),
      body: Container(
        color: myColor3,
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: busStop.connections.length,
          itemBuilder: ((context, index) {
            return StopConnectionTile(
              busStop: busStop,
              connection: busStop.connections[index],
            );
          }),
        ),
      ),
    );
  }
}
