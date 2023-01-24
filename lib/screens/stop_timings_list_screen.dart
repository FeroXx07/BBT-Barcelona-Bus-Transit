import 'package:barcelona_bus_transit/model/bus_stop.dart';
import 'package:barcelona_bus_transit/model/bus_line_stop_args.dart';
import 'package:barcelona_bus_transit/utilities/database.dart';
import 'package:barcelona_bus_transit/utilities/hex_color.dart';
import 'package:barcelona_bus_transit/widgets/appbar.dart';
import 'package:barcelona_bus_transit/widgets/custom_map.dart';
import 'package:barcelona_bus_transit/widgets/icons/favorite_star_trailing.dart';
import 'package:barcelona_bus_transit/widgets/tiles/stop_connection_tile.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class StopTimingsListScreen extends StatelessWidget {
  late BusStop previousBusStop;
  late BusStop nextBusStop;
  StopTimingsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as BusLineStopArguments;

    if (arguments.busStop.isOrigin == 1) {
      previousBusStop = arguments.busStop;
    } else {
      previousBusStop = findPreviousStop(arguments);
    }

    if (arguments.busStop.isDestionation == 1) {
      nextBusStop = arguments.busStop;
    } else {
      nextBusStop = findNextStop(arguments);
    }

    return Scaffold(
      appBar: const PreferredSize(
        //Here is the preferred height.
        preferredSize: Size.fromHeight(100),
        child: CustomAppbar(
          title: "Bus Lines",
        ),
      ),
      body: Container(
        color: myColor4,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                ThreeCircleStops(
                    previousBusStop: previousBusStop,
                    currentBusStop: arguments.busStop,
                    nextBusStop: nextBusStop),
                IsFavoriteStar(
                    isFavorite: arguments.busStop.isFavorite,
                    onFavoritePressed: (output) {
                      if (output == true) {
                        setFavoriteBusStop(arguments.busStop);
                      } else {
                        removeFavoriteBusStop(arguments.busStop);
                      }
                    }),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 30),
                itemCount: arguments.busStop.connections.length,
                itemBuilder: ((context, index) {
                  return StopConnectionTile(
                    busStop: arguments.busStop,
                    connection: arguments.busStop.connections[index],
                  );
                }),
              ),
            ),
            Expanded(
              child: CustomMap(arguments: arguments),
            ),
          ],
        ),
      ),
    );
  }
}

class ThreeCircleStops extends StatelessWidget {
  const ThreeCircleStops({
    Key? key,
    required this.currentBusStop,
    required this.previousBusStop,
    required this.nextBusStop,
  }) : super(key: key);

  final BusStop currentBusStop;
  final BusStop previousBusStop;
  final BusStop nextBusStop;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _Circle(busStop: previousBusStop, width: 50),
        _Circle(busStop: currentBusStop, width: 80),
        _Circle(busStop: nextBusStop, width: 50),
      ],
    );
  }
}

class _Circle extends StatelessWidget {
  final double width;
  const _Circle({
    Key? key,
    required this.busStop,
    required this.width,
  }) : super(key: key);

  final BusStop busStop;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: width,
          height: 100,
          decoration: BoxDecoration(
            color: hexToColor(busStop.colorRectangle),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              "${busStop.code}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          width: width,
          padding: const EdgeInsets.all(2),
          child: Text(
            busStop.name,
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}
