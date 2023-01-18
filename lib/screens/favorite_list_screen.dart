import 'package:barcelona_bus_transit/model/bus_line.dart';
import 'package:barcelona_bus_transit/utilities/database.dart';
import 'package:barcelona_bus_transit/utilities/hex_color.dart';
import 'package:barcelona_bus_transit/widgets/appbar.dart';
import 'package:barcelona_bus_transit/widgets/tiles/bus_line_tile.dart';
import 'package:barcelona_bus_transit/widgets/loading.dart';
import 'package:barcelona_bus_transit/widgets/selection_widget.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class FavoritesListScreen extends StatelessWidget {
  const FavoritesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
          //Here is the preferred height.
          preferredSize: Size.fromHeight(100),
          child: CustomAppbar(
            title: "Bus Lines",
          )),
      body: Selector(),
    );
  }
}

class Selector extends StatefulWidget {
  const Selector({super.key});

  @override
  State<Selector> createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  int _direction = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FavoriteSelectionsWidget(
          onDirectionPressed: ((output) {
            setState(
              () {
                _direction = output;
                developer.log("new direction is $_direction");
              },
            );
          }),
        ),
        //FavLinesList(),
        if (_direction == 1) ...[
          const Expanded(child: FavLinesList()),
        ]
        //   FavStopsList()
        // ],
      ],
    );
  }
}

class FavLinesList extends StatelessWidget {
  const FavLinesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Container(
        color: myColor3,
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<List<BusLine>>(
          stream: getFavoriteBusLines(),
          builder: ((context, AsyncSnapshot<List<BusLine>> snapshot) {
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

                  return ListView.builder(
                    itemCount: favoriteList.length,
                    itemBuilder: (context, index) {
                      return LineTile(busLine: favoriteList[index]);
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
