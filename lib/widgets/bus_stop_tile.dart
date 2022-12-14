// Each individual stop tile
import 'package:barcelona_bus_transit/model/bus_stop.dart';
import 'package:barcelona_bus_transit/model/hex_color.dart';
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
      padding: const EdgeInsets.all(4.0),
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
