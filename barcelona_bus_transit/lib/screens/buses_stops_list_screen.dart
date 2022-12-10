import 'package:barcelona_bus_transit/model/tmb_lists.dart';
import 'package:barcelona_bus_transit/widgets/appbar.dart';
import 'package:barcelona_bus_transit/widgets/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StopsListScreen extends StatelessWidget {
  const StopsListScreen({super.key});

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
        return _StopsTileBuilder(stopsList: snapshot.data!);
      },
    );
  }
}

class _StopsTileBuilder extends StatefulWidget {
  final List<BusStop> stopsList;

  _StopsTileBuilder({
    required this.stopsList,
  });

  @override
  State<_StopsTileBuilder> createState() => _StopsTileBuilderState();
}

class _StopsTileBuilderState extends State<_StopsTileBuilder> {
  String name = "Loading";

  BusLine? busLine;

  @override
  Widget build(BuildContext context) {
    
    getBusLine(context.watch<int>()).then((value) {
      BusLine busLine = value as BusLine;
      
      name = busLine.name;

    });
    return Scaffold(
      body: Scrollbar(
        child: Container(
          color: myColor3,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Center(child: Text(name)),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.stopsList!.length,
                  itemBuilder: (context, index) {
                    return _StopTile(busStop: widget.stopsList![index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StopTile extends StatelessWidget {
  final BusStop busStop;
  const _StopTile({required this.busStop});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Text(busStop.name),
        subtitle: Text(busStop.adress),
      ),
    );
  }
}
