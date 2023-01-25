import 'package:barcelona_bus_transit/model/bus_line.dart';
import 'package:barcelona_bus_transit/model/bus_stop.dart';
import 'package:barcelona_bus_transit/utilities/database.dart';
import 'package:barcelona_bus_transit/utilities/hex_color.dart';
import 'package:barcelona_bus_transit/widgets/appbar.dart';
import 'package:barcelona_bus_transit/widgets/icons/circle_icon.dart';
import 'package:barcelona_bus_transit/widgets/tiles/bus_line_tile.dart';
import 'package:barcelona_bus_transit/widgets/loading.dart';
import 'package:barcelona_bus_transit/widgets/selection_widget.dart';
import 'package:barcelona_bus_transit/widgets/tiles/bus_stop_tile.dart';
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
        ] else
          const Expanded(child: FavStopsList()),
      ],
    );
  }
}

class FavStopsList extends StatelessWidget {
  const FavStopsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Container(
        color: myColor3,
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<List<BusStop>>(
          stream: getFavoriteBusStopesStream(),
          builder: ((context, AsyncSnapshot<List<BusStop>> snapshot) {
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
                  List<BusStop> favoriteList = snapshot.data!;

                  return ListView.builder(
                    itemCount: favoriteList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: roundedDecoration(),
                        child: ListTile(
                          // leading: CircleAvatar(
                          //   backgroundImage: NetworkImage(user.avatarUrl),
                          // ),
                          leading: const CircleIconFromColor(
                              color: Colors.lightGreen),
                          trailing: SizedBox(
                            width: 100,
                            height: 60,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 1,
                              ),
                              itemCount: favoriteList[index].connections.length,
                              itemBuilder: ((context, index2) {
                                return Connection(
                                  busStop: favoriteList[index],
                                  index: index2,
                                );
                              }),
                            ),
                          ),
                          title: Text(favoriteList[index].name),

                          contentPadding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 5, right: 15),
                        ),
                      );
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
