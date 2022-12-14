import 'package:barcelona_bus_transit/model/tmb_lists.dart';
import 'package:barcelona_bus_transit/widgets/appbar.dart';
import 'package:barcelona_bus_transit/widgets/hex_color.dart';
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
                      return _StopTile(
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

// Each individual stop tile
class _StopTile extends StatelessWidget {
  final BusStop busStop;
  final Color rectColor;
  const _StopTile({required this.busStop, required this.rectColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: rectColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Container(
              width: 10,
              decoration: BoxDecoration(
                color: rectColor,
              ),
            ),
          ),
        ],
      ),
      trailing: SizedBox(
        width: 100,
        height: 50,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: busStop.connections.length,
            itemBuilder: ((context, index) {
              return Container(
                color: myColor5,
                child: Text(
                  busStop.connections[index].name,
                  style: const TextStyle(
                    color: myColor4,
                  ),
                ),
              );
            })),
      ),

      title: Text(busStop.name),
      //subtitle: Text(busStop.adress),
    );
  }
}
