import 'package:barcelona_bus_transit/model/bus_line.dart';
import 'package:barcelona_bus_transit/model/bus_stop.dart';
import 'package:barcelona_bus_transit/utilities/hex_color.dart';
import 'package:barcelona_bus_transit/widgets/bus_stop_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loading.dart';
import 'package:auto_size_text/auto_size_text.dart';

class StopsListBuilder extends StatefulWidget {
  final List<BusStop> stopsList;
  const StopsListBuilder({
    super.key,
    required this.stopsList,
  });

  @override
  State<StopsListBuilder> createState() => _StopsListBuilderState();
}

class _StopsListBuilderState extends State<StopsListBuilder> {
  int _direction = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Direction(
            origin: widget.stopsList[0].origin,
            destionation: widget.stopsList[0].destination,
            onDirectionPressed: (output) {
              setState(() {
                _direction = output;
              });
            },
          ),
          Expanded(
            child: Container(
              color: myColor4,
              padding: const EdgeInsets.all(30),
              child: Expanded(
                child: FutureBuilder(
                  // Pass the line code from the provider
                  future: getBusLine(context.watch<int>()),
                  builder: ((context, snapshot) {
                    if (snapshot.hasError) {
                      return ErrorWidget(snapshot.error.toString());
                    }
                    if (!snapshot.hasData) {
                      return const Loading();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        lineTitle(snapshot),
                        lineStopsListViewBuilder(snapshot),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded lineStopsListViewBuilder(AsyncSnapshot<BusLine> snapshot) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.stopsList.length,
        itemBuilder: ((context, index) {
          if (widget.stopsList[index].direction == _direction) {
            return StopTile(
              busStop: widget.stopsList[index],
              rectColor: hexToColor(snapshot.data!.primaryColor),
            );
          } else {
            return Container();
          }
        }),
      ),
    );
  }

  Container lineTitle(AsyncSnapshot<BusLine> snapshot) {
    return Container(
      decoration: roundedDecoration(
          borderColor: hexToColor(snapshot.data!.primaryColor),
          interiorColor: hexToColor(snapshot.data!.primaryColor)),
      child: Center(
          child: Text(
        snapshot.data!.name,
        style: TextStyle(color: hexToColor(snapshot.data!.textColor)),
      )),
    );
  }
}

class Direction extends StatefulWidget {
  final String origin;
  final String destionation;
  final int direction = 1;
  final void Function(int) onDirectionPressed;
  const Direction({
    Key? key,
    required this.origin,
    required this.destionation,
    required this.onDirectionPressed,
  }) : super(key: key);

  @override
  State<Direction> createState() => _DirectionState();
}

class _DirectionState extends State<Direction> {
  int _direction = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            decoration: BoxDecoration(
              color: _direction == 1 ? myColor2 : myColor3,
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _direction = 1;
                  widget.onDirectionPressed(_direction);
                });
              },
              child: Expanded(
                child: AutoSizeText(
                  style: const TextStyle(fontSize: 12, color: myColor4),
                  "From: ${widget.origin} \n To: ${widget.destionation}",
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            decoration: BoxDecoration(
              color: _direction == 2 ? myColor2 : myColor3,
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _direction = 2;
                  widget.onDirectionPressed(_direction);
                });
              },
              child: Expanded(
                child: AutoSizeText(
                  style: const TextStyle(fontSize: 12, color: myColor4),
                  "From: ${widget.destionation} \n To: ${widget.origin}",
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
