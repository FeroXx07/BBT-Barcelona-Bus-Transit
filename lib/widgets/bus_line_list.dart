import 'package:barcelona_bus_transit/model/bus_line.dart';
import 'package:barcelona_bus_transit/utilities/database.dart';
import 'package:barcelona_bus_transit/utilities/hex_color.dart';
import 'package:barcelona_bus_transit/widgets/tiles/bus_line_tile.dart';
import 'package:barcelona_bus_transit/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class LinesTileBuilder extends StatefulWidget {
  final List<BusLine> linesList;
  const LinesTileBuilder({
    super.key,
    required this.linesList,
  });

  @override
  State<LinesTileBuilder> createState() => _LinesTileBuilderState();
}

class _LinesTileBuilderState extends State<LinesTileBuilder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: Container(
          color: myColor3,
          padding: const EdgeInsets.all(20),
          child: StreamBuilder<List<BusLine>>(
              stream: getFavoriteBusLines(),
              builder: (context, AsyncSnapshot<List<BusLine>> snapshot) {
                if (snapshot.hasError) {
                  return ErrorWidget(snapshot.error.toString());
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Loading();
                  case ConnectionState.active:
                    return const Loading();
                  case ConnectionState.done:
                    {
                      developer.log(
                          "Favorite loaded: lenght = ${snapshot.data!.length}");

                      List<BusLine> favoriteList = snapshot.data!;
                      for (var local in widget.linesList) {
                        for (var global in favoriteList) {
                          if (local.code == global.code) {
                            local.isFavorite = true;
                            developer.log("Setted ${local.name} to true");
                          }
                        }
                      }
                      return ListView.builder(
                        itemCount: widget.linesList.length,
                        itemBuilder: (context, index) {
                          return LineTile(busLine: widget.linesList[index]);
                        },
                      );
                    }
                }
              }),
        ),
      ),
    );
  }
}
