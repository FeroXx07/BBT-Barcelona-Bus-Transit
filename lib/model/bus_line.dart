import 'dart:convert';
import 'package:barcelona_bus_transit/utilities/tmb_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isFavorite = false;

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

  BusLine.fromFireStore(DocumentSnapshot doc)
      : uniqueId = doc.get("uniqueId"),
        code = doc.get("code"),
        name = doc.get("name"),
        description = doc.get("description"),
        origin = doc.get("origin"),
        destination = doc.get("destination"),
        descriptionCalendarType = doc.get("descriptionCalendarType"),
        primaryColor = doc.get("primaryColor"),
        secondaryColor = doc.get("secondaryColor"),
        textColor = doc.get("textColor"),
        isFavorite = doc.get("isFavorite");

  Map<String, dynamic> toFireStore() => {
        'uniqueId': uniqueId,
        'code': code,
        'name': name,
        'description': description,
        'origin': origin,
        'destination': destination,
        'descriptionCalendarType': descriptionCalendarType,
        'primaryColor': primaryColor,
        'secondaryColor': secondaryColor,
        'textColor': textColor,
        'isFavorite': isFavorite,
        'lastUpdate': Timestamp.now(),
      };
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

Future<BusLine> getBusLine(int code) async {
  String url = "https://api.tmb.cat/v1/transit/linies/bus/$code?";
  url = url + getApiString();
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  Map<String, dynamic> busInfo = jsonDecode(response.body);
  var busLine = BusLine.fromJson(busInfo["features"][0]);

  return busLine;
}

List<BusLine> toBusLineList(QuerySnapshot query) {
  final doc = query.docs;
  List<BusLine> list = doc.map((e) => BusLine.fromFireStore(e)).toList();
  return list;
}
