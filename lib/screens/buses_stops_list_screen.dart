import 'package:barcelona_bus_transit/model/bus_stop.dart';
import 'package:barcelona_bus_transit/widgets/appbar.dart';
import 'package:barcelona_bus_transit/widgets/bus_stop_list.dart';
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
        return StopsListBuilder(stopsList: snapshot.data!);
      },
    );
  }
}


