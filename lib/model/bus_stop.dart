import 'dart:convert';
import 'package:barcelona_bus_transit/model/stop_connections.dart';
import 'package:barcelona_bus_transit/utilities/tmb_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class BusStop {
  String uniqueId;
  int code; //Código identificador de la parada -- number : 1775

  String name; //Nombre de la parada -- string : Pl Espanya
  String
      description; //Descripción de la parada, en relación con su localización -- string : Pl. Espanya/Gran Via C.Catalanes
  String
      adress; //Dirección en la que se encuentra -- string : Av. Tibidabo, 38-40
  int order; //Orden dentro del recorrido de la línea -- number : 12
  int isOrigin; //Indica si la parada es el origen de la línea -- number : 0
  int isDestionation; //Indica si la parada es el destino de la línea -- number : 1
  String colorRectangle; //Color (formato RGB hexadecimal) -- string :ED8E8C

  List<StopConnections> connections = [];

  BusStop({
    required this.uniqueId,
    required this.code,
    required this.name,
    required this.description,
    required this.adress,
    required this.order,
    required this.isOrigin,
    required this.isDestionation,
    required this.colorRectangle,
  });

  BusStop.fromJson(Map<String, dynamic> json)
      : uniqueId = json["id"],
        code = json["properties"]["CODI_PARADA"],
        name = json["properties"]["NOM_PARADA"],
        description = json["properties"]["DESC_PARADA"],
        adress = json["properties"]["ADRECA"],
        order = json["properties"]["ORDRE"],
        isOrigin = json["properties"]["ES_ORIGEN"],
        isDestionation = json["properties"]["ES_DESTI"],
        colorRectangle = "#${json["properties"]["COLOR_REC"]}";

  BusStop.fromFireStore(Map<String, dynamic> json)
      : uniqueId = json["uniqueId"],
        code = json["code"],
        name = json["name"],
        description = json["description"],
        adress = json["adress"],
        order = json["order"],
        isOrigin = json["isOrigin"],
        isDestionation = json["isDestionation"],
        colorRectangle = "#${json["colorRectangle"]}";

  Map<String, dynamic> toFirestore() => {
        'uniqueId': uniqueId,
        'code': code,
        'name': name,
        'description': description,
        'adress': adress,
        'order': order,
        'isOrigin': isOrigin,
        'isDestionation': isDestionation,
        'colorRectangle': colorRectangle,
        'lastUpdate': Timestamp.now(),
      };

  void loadCorrespondences() async {
    connections = await connectionsStopFromCode(code);
  }
}

Future<List<StopConnections>> connectionsStopFromCode(int stopCode) async {
  String url = "https://api.tmb.cat/v1/transit/parades/$stopCode/corresp?";
  url = url + getApiString();
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  final json = jsonDecode(response.body);
  final jSonBusesLineList = json["features"];
  List<StopConnections> list = [];
  for (final jSonBusLine in jSonBusesLineList) {
    // Check for only buses in the json, then add the buses only
    StopConnections b = StopConnections.fromJson(jSonBusLine);
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
