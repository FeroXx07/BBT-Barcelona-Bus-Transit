// Each individual stop tile
import 'package:barcelona_bus_transit/model/bus_stop.dart';
import 'package:barcelona_bus_transit/utilities/hex_color.dart';
import 'package:flutter/material.dart';

class StopTile extends StatelessWidget {
  final BusStop busStop;
  final Color rectColor;
  const StopTile({super.key, required this.busStop, required this.rectColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          StepperCircle(rectColor: rectColor),
          StepperRect(rectColor: rectColor),
        ],
      ),
      onTap: () {
        Navigator.of(context).pushNamed('/stopScreen',
            arguments: busStop);
      },
      trailing: SizedBox(
        width: 100,
        height: 60,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          itemCount: busStop.connections.length,
          itemBuilder: ((context, index) {
            return Connection(
              busStop: busStop,
              index: index,
            );
          }),
        ),
      ),

      title: Text(
        busStop.name,
        style: const TextStyle(fontSize: 11),
      ),

      //subtitle: Text(busStop.adress),
    );
  }
}

class Connection extends StatelessWidget {
  final int index;
  const Connection({
    Key? key,
    required this.busStop,
    required this.index,
  }) : super(key: key);

  final BusStop busStop;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/stopsList',
            arguments: busStop.connections[index].lineCode);
      },
      child: Card(
        color: hexToColor(busStop.connections[index].colorRect),
        child: Center(
          child: Text(
            busStop.connections[index].name,
            style: TextStyle(
              fontSize: 8,
              color: hexToColor(busStop.connections[index].colorText),
            ),
          ),
        ),
      ),
    );
  }
}

class StepperRect extends StatelessWidget {
  const StepperRect({
    Key? key,
    required this.rectColor,
  }) : super(key: key);

  final Color rectColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Container(
        width: 10,
        decoration: BoxDecoration(
          color: rectColor,
        ),
      ),
    );
  }
}

class StepperCircle extends StatelessWidget {
  const StepperCircle({
    Key? key,
    required this.rectColor,
  }) : super(key: key);

  final Color rectColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 14),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: rectColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
