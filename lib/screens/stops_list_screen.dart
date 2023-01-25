import 'package:barcelona_bus_transit/model/bus_stop.dart';
import 'package:barcelona_bus_transit/utilities/database.dart';
import 'package:barcelona_bus_transit/widgets/appbar.dart';
import 'package:barcelona_bus_transit/widgets/bus_stop_list.dart';
import 'package:barcelona_bus_transit/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

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
  FutureBuilder _busStopsFutureBuilder(int code) {
    return FutureBuilder(
        future: Future.wait([fetchDataAPI(code), fetchDataFavorite()]),
        builder: ((context, snapshots) {
          if (snapshots.hasError) {
            return ErrorWidget(snapshots.error.toString());
          }
          if (!snapshots.hasData) {
            return const Loading();
          }
          switch (snapshots.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return const Loading();
            case ConnectionState.active:
              return const Loading();
            case ConnectionState.done:
              {
                List<BusStop> favoriteList = snapshots.data[1]!;
                if (favoriteList.isNotEmpty) {
                  for (var local in snapshots.data[0]!) {
                    for (var global in favoriteList) {
                      if (local.code == global.code) {
                        local.isFavorite = true;
                        developer.log("Setted ${local.name} to true");
                      }
                    }
                  }
                }

                return StopsListBuilder(stopsList: snapshots.data[0]!);
              }
          }
          return const Loading();
        }));
    // return FutureBuilder(
    //   future: loadAllBusesStopsFromCode(code),
    //   builder: (context, snapshotAPI) {
    //     if (snapshotAPI.hasError) {
    //       developer.log("Error snapshot api");
    //       return ErrorWidget(snapshotAPI.error.toString());
    //     }
    //     if (!snapshotAPI.hasData) {
    //       developer.log("NO snapshot api");
    //       return const CircularProgressIndicator();
    //     }

    //     developer.log("DATA snapshot API");
    //     FutureBuilder<List<BusStop>>(
    //         future: getFavoriteBusStopes().firstWhere((element) => false),
    //         builder: (context, snapshotFavorite) {
    //           if (snapshotFavorite.hasError) {
    //             developer.log("ERROR snapshot FAVORITE");
    //             return ErrorWidget(snapshotAPI.error.toString());
    //           }
    //           if (!snapshotAPI.hasData) {
    //             developer.log("NO snapshot FAVORITE");
    //             return const Loading();
    //           }
    //           developer.log("DATA snapshot FAVORITE");
    //           List<BusStop> favoriteList = snapshotFavorite.data!;
    //           for (var local in snapshotAPI.data!) {
    //             for (var global in favoriteList) {
    //               if (local.code == global.code) {
    //                 local.isFavorite = true;
    //                 developer.log("Setted ${local.name} to true");
    //               }
    //             }
    //           }
    //           return StopsListBuilder(stopsList: snapshotAPI.data!);
    //         });
    //     return const CircularProgressIndicator();
    // switch (snapshot.connectionState) {
    //   case ConnectionState.none:
    //   case ConnectionState.waiting:
    //     return const Loading();
    //   case ConnectionState.active:
    //     return const Loading();
    //   case ConnectionState.done:
    //     {
    //       return _loadAllFavoriteBusesStop(snapshot.data!);

    //       return StopsListBuilder(stopsList: snapshot.data!);
    //     }
    // }
  }

  Future<List<BusStop>> fetchDataAPI(int code) async {
    return await loadAllBusesStopsFromCode(code);
  }

  Future<List<BusStop>> fetchDataFavorite() async {
    return await getFavoriteBusStopesFuture();
  }
// StopsListBuilder _loadAllFavoriteBusesStop(List<BusStop> stopsList) {
//   return StopsListBuilder(stopsList: stopsList);
// }
}
