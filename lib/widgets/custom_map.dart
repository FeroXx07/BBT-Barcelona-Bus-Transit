
import 'package:barcelona_bus_transit/model/bus_line_stop_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';

class CustomMap extends StatelessWidget {
  const CustomMap({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  final BusLineStopArguments arguments;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FlutterMap(
        options: MapOptions(
          center: LatLng(arguments.busStop.latitud, arguments.busStop.longitud),
          zoom: 15.5,
        ),
        // nonRotatedChildren: [
        //   AttributionWidget.defaultWidget(
        //     source: 'OpenStreetMap contributors',
        //     onSourceTapped: null,
        //   ),
        // ],
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.citm-task2-project.firebaseapp.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                    arguments.busStop.latitud, arguments.busStop.longitud),
                width: 80,
                height: 80,
                builder: (context) => const Icon(
                  Icons.fmd_bad,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}