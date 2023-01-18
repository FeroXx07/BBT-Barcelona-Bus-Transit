import 'package:barcelona_bus_transit/model/bus_line.dart';
import 'package:barcelona_bus_transit/model/bus_stop.dart';

class BusLineStopArguments {
  final BusLine busLine;
  final BusStop busStop;
  late List<BusStop> allStops;
  BusLineStopArguments(this.allStops,
      {required this.busLine, required this.busStop});
}
