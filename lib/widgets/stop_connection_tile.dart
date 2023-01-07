import 'dart:convert';

import 'package:barcelona_bus_transit/model/bus_line.dart';
import 'package:barcelona_bus_transit/model/bus_stop.dart';
import 'package:barcelona_bus_transit/model/stop_connections.dart';
import 'package:barcelona_bus_transit/model/stop_timings.dart';
import 'package:barcelona_bus_transit/widgets/icons/circle_icon.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class StopConnectionTile extends StatefulWidget {
  final BusStop busStop;
  final StopConnection connection;

  const StopConnectionTile(
      {super.key, required this.connection, required this.busStop});

  @override
  State<StopConnectionTile> createState() => _StopConnectionTileState();
}

class _StopConnectionTileState extends State<StopConnectionTile> {
  String destination = "loading...";
  String time = "loading...";
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FutureBuilder(
        future: getBusLine(widget.connection.lineCode),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return CircleIcon(busLine: snapshot.data!);
        },
      ),
      title: StreamBuilder(
        stream: getTimeConnection(widget.connection),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error.toString());
          }
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            case ConnectionState.active:
              {
                Map<String, dynamic> busInfo =
                    jsonDecode(snapshot.data!.body);
                var stop = StopTiming.fromJson(busInfo["features"][0]);
                destination = stop.destination;
                time = stop.timeInString;
                return const CircularProgressIndicator();
              }
            case ConnectionState.done:
              break;
            default:
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return Text(destination);
        },
      ),
      trailing: Text(time),
    );
  }
}
