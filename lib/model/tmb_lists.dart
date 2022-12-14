import 'dart:convert';

import 'package:barcelona_bus_transit/widgets/tmb_api.dart';
import 'package:http/http.dart' as http;

class BusLine {
  String uniqueId;
  int code; //Código identificador de la línea -- number : 2

  String name; //Nombre la línea -- string : L2
  String
      description; //Descripción de la línea -- string : Pg. Marítim / Av. Tibidabo
  String origin; //Origen del recorrido de la línea -- string : Pg. Marítim
  String
      destination; //Destino del recorrido de la línea -- string : Av. Tibidabo

  //Descripción del tipo de calendario (cuándo circula la línea) -- string : Només feiners
  String descriptionCalendarType;

  String
      primaryColor; //Color que identifica a la línea (formato RGB hexadecimal) -- string :DC241F
  String
      secondaryColor; //Color secundario de la línea (formato RGB hexadecimal) -- string :ED8E8C
  String
      textColor; //Color por el texto de la línea (formato RGB hexadecimal) -- string :FFFFFF

  BusLine({
    required this.uniqueId,
    required this.code,
    required this.name,
    required this.description,
    required this.origin,
    required this.destination,
    required this.descriptionCalendarType,
    required this.primaryColor,
    required this.secondaryColor,
    required this.textColor,
  });

  BusLine.fromJson(Map<String, dynamic> json)
      : uniqueId = json["id"],
        code = json["properties"]["CODI_LINIA"],
        name = json["properties"]["NOM_LINIA"],
        description = json["properties"]["DESC_LINIA"],
        origin = json["properties"]["ORIGEN_LINIA"],
        destination = json["properties"]["DESTI_LINIA"],
        descriptionCalendarType = json["properties"]["NOM_TIPUS_CALENDARI"],
        primaryColor = "#${json["properties"]["COLOR_LINIA"]}",
        secondaryColor = "#${json["properties"]["COLOR_AUX_LINIA"]}",
        textColor = "#${json["properties"]["COLOR_TEXT_LINIA"]}";
}

Future<List<BusLine>> loadAllBusesLines() async {
  String url = "https://api.tmb.cat/v1/transit/linies/bus?";
  url = url + getApiString();
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  final json = jsonDecode(response.body);
  final jSonBusesLineList = json["features"];
  List<BusLine> userList = [];
  for (final jSonBusLine in jSonBusesLineList) {
    userList.add(BusLine.fromJson(jSonBusLine));
  }

  userList.sort((a, b) => a.primaryColor.compareTo(b.primaryColor));

  return userList;
}

class StopConnections {
  int stopCode;
  int lineCode;
  String name;
  String operator;
  String colorText;
  String colorRect;

  StopConnections({
    required this.stopCode,
    required this.lineCode,
    required this.name,
    required this.operator,
    required this.colorText,
    required this.colorRect,
  });

  StopConnections.fromJson(Map<String, dynamic> json)
      : stopCode = json["properties"]["CODI_PARADA"],
        lineCode = json["properties"]["CODI_LINIA"],
        name = json["properties"]["NOM_LINIA"],
        operator = json["properties"]["NOM_OPERADOR"],
        colorRect = json["properties"]["COLOR_LINIA"],
        colorText = json["properties"]["COLOR_TEXT_LINIA"];
}

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
        colorRectangle = json["properties"]["COLOR_REC"];

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

Future<BusLine> getBusLine(int code) async {
  String url = "https://api.tmb.cat/v1/transit/linies/bus/$code?";
  url = url + getApiString();
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  Map<String, dynamic> busInfo = jsonDecode(response.body);
  var busLine = BusLine.fromJson(busInfo["features"][0]);

  return busLine;
}
