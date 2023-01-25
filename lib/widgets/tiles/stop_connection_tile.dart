import 'dart:async';
import 'dart:convert';

import 'package:barcelona_bus_transit/model/bus_line.dart';
import 'package:barcelona_bus_transit/model/bus_stop.dart';
import 'package:barcelona_bus_transit/model/stop_connections.dart';
import 'package:barcelona_bus_transit/model/stop_timings.dart';
import 'package:barcelona_bus_transit/widgets/icons/circle_icon.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:http/src/response.dart';

//ignore: must_be_immutable
class StopConnectionTile extends StatefulWidget {
  final BusStop busStop;
  final StopConnection connection;
  String destination = "loading...";
  String time = "loading...";

  StopConnectionTile(
      {super.key, required this.connection, required this.busStop});

  @override
  State<StopConnectionTile> createState() => _StopConnectionTileState();
}

class _StopConnectionTileState extends State<StopConnectionTile> {
  // Initial response, streams every 5 seconds
  late StreamController<String> _streamController;

  @override
  void didChangeDependencies() {
    _streamController = StreamController<String>();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant StopConnectionTile oldWidget) {
    _streamController = StreamController<String>();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: FutureBuilder(
          future: getBusLine(widget.connection.lineCode),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorWidget(snapshot.error.toString());
            }
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return CircleIconFromBusLine(busLine: snapshot.data!);
          },
        ),
        trailing: _timeStreamBuilderSubscriber(),
        title: _mainStreamBuilder(),
      ),
    );
  }

  StreamBuilder<Response> _mainStreamBuilder() {
    return StreamBuilder(
      stream: getTimeConnection(widget.connection),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error.toString());
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Text(widget.destination);
          case ConnectionState.active:
            {
              Map<String, dynamic> busInfo = jsonDecode(snapshot.data!.body);

              final timeData = busInfo["data"]["ibus"];
              StopTiming stopTiming;

              // Check if data is empty and return the proper response
              if (timeData.isEmpty) {
                stopTiming = StopTiming.fromJsonClosed();
              } else {
                stopTiming = StopTiming.fromJsonOpened(timeData[0]);
              }
              _sendStreamToSubscribers(
                  stopTiming.destination, stopTiming.timeInString);

              return Text(widget.destination);
            }
          case ConnectionState.done:
            break;
          default:
            return Text(widget.destination);
        }
        return Text(widget.destination);
      },
    );
  }

  StreamBuilder<String> _timeStreamBuilderSubscriber() {
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          widget.time = snapshot.data!;
          return Text(widget.time);
        }
        return Text(widget.time);
      },
    );
  }

  void _sendStreamToSubscribers(String destination_, String time_) {
    widget.destination = destination_;
    widget.time = time_;
    _streamController.add(widget.time);
  }
}
