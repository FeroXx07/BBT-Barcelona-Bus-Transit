import 'dart:convert';
import 'package:barcelona_bus_transit/model/bus_line_stop_args.dart';
import 'package:barcelona_bus_transit/model/stop_connections.dart';
import 'package:barcelona_bus_transit/utilities/tmb_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class BusStop {
  late String uniqueId;
  late int code; //Código identificador de la parada -- number : 1775

  late String name; //Nombre de la parada -- string : Pl Espanya
  late String
      description; //Descripción de la parada, en relación con su localización -- string : Pl. Espanya/Gran Via C.Catalanes
  late String
      adress; //Dirección en la que se encuentra -- string : Av. Tibidabo, 38-40
  late String
      colorRectangle; //Color (formato RGB hexadecimal) -- string :ED8E8C
  late String origin;
  late String destination;
  late int order; //Orden dentro del recorrido de la línea -- number : 12
  late int
      isOrigin; //Indica si la parada es el origen de la línea -- number : 0
  late int
      isDestination; //Indica si la parada es el destino de la línea -- number : 1
  late int direction; // 1 es anada, 2 es tornada
  late double latitud;
  late double longitud;

  List<StopConnection> connections = [];
  bool isFavorite = false;
  BusStop({
    required this.uniqueId,
    required this.code,
    required this.name,
    required this.description,
    required this.adress,
    required this.order,
    required this.isOrigin,
    required this.isDestination,
    required this.colorRectangle,
    required this.direction,
    required this.origin,
    required this.destination,
    required this.latitud,
    required this.longitud,
  });

  BusStop.fromJson(Map<String, dynamic> json)
      : uniqueId = json["id"],
        code = json["properties"]["CODI_PARADA"],
        name = json["properties"]["NOM_PARADA"],
        description = json["properties"]["DESC_PARADA"],
        adress = json["properties"]["ADRECA"],
        order = json["properties"]["ORDRE"],
        isOrigin = json["properties"]["ES_ORIGEN"],
        isDestination = json["properties"]["ES_DESTI"],
        origin = json["properties"]["ORIGEN_SENTIT"],
        destination = json["properties"]["DESTI_SENTIT"],
        colorRectangle = "#${json["properties"]["COLOR_REC"]}",
        direction = json["properties"]["ID_SENTIT"],
        latitud = json["geometry"]["coordinates"][1],
        longitud = json["geometry"]["coordinates"][0];

  BusStop.fromFireStore(DocumentSnapshot doc) {
    uniqueId = doc["uniqueId"];
    code = doc["code"];
    name = doc["name"];
    description = doc["description"];
    adress = doc["adress"];
    order = doc["order"];
    isOrigin = doc["isOrigin"];
    isDestination = doc["isDestination"];
    origin = doc["origin"];
    destination = doc["destination"];
    colorRectangle = doc["colorRectangle"];
    direction = doc["direction"];
    latitud = doc["latitud"];
    longitud = doc["longitud"];
    isFavorite = doc["isFavorite"];
    connections = (doc["connections"] as List<dynamic>)
        .map((e) => StopConnection.fromFireStoreJsonFire(e))
        .toList();
  }

  Map<String, dynamic> toFirestore() => {
        'uniqueId': uniqueId,
        'code': code,
        'name': name,
        'description': description,
        'adress': adress,
        'order': order,
        'isOrigin': isOrigin,
        'isDestination': isDestination,
        'origin': origin,
        'destination': destination,
        'colorRectangle': colorRectangle,
        'direction': direction,
        'latitud': latitud,
        'longitud': longitud,
        'isFavorite': isFavorite,
        'connections':
            List<StopConnection>.from(connections.map((x) => x.toFireStore())),
        'lastUpdate': Timestamp.now(),
      };

  void loadCorrespondences() async {
    connections = await connectionsStopFromCode(code);
  }
}

Future<List<StopConnection>> connectionsStopFromCode(int stopCode) async {
  String url = "https://api.tmb.cat/v1/transit/parades/$stopCode/corresp?";
  url = url + getApiString();
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  final json = jsonDecode(response.body);
  final jSonBusesLineList = json["features"];
  List<StopConnection> list = [];
  for (final jSonBusLine in jSonBusesLineList) {
    // Check for only buses in the json, then add the buses only
    StopConnection b = StopConnection.fromJsonAPI(jSonBusLine);
    if (jSonBusLine["properties"]["NOM_OPERADOR"] == "TB") {
      list.add(b);
    }
  }

  return list;
}

Future<List<BusStop>> loadAllBusesStopsFromCode(int lineCode) async {
  String url = "https://api.tmb.cat/v1/transit/linies/bus/$lineCode/parades?";
  url = url + getApiString();
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  final json = jsonDecode(response.body);
  final jSonBusesStopsList = json["features"];
  List<BusStop> stopsList = [];

  for (final jSonBusLine in jSonBusesStopsList) {
    stopsList.add(BusStop.fromJson(jSonBusLine));
    stopsList.last.loadCorrespondences();
  }

  // Sort the stops by the order inside line
  stopsList.sort((a, b) => a.order.compareTo(b.order));

  return stopsList;
}

List<BusStop> toBusStopList(QuerySnapshot query) {
  final doc = query.docs;
  List<BusStop> list = doc.map((e) => BusStop.fromFireStore(e)).toList();
  return list;
}

BusStop findPreviousStop(BusLineStopArguments arguments) {
  return arguments.allStops.singleWhere(
    (element) {
      // First the must be in the same direction
      if (element.direction == arguments.busStop.direction) {
        // Secondly it must be the previous order in the line
        return element.order == arguments.busStop.order - 1;
      } else {
        return false;
      }
    },
  );
}

BusStop findNextStop(BusLineStopArguments arguments) {
  return arguments.allStops.singleWhere(
    (element) {
      // First the must be in the same direction
      if (element.direction == arguments.busStop.direction) {
        // Secondly it must be the previous order in the line
        return element.order == arguments.busStop.order + 1;
      } else {
        return false;
      }
    },
  );
}
