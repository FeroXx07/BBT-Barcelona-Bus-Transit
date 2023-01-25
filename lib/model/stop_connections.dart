import 'package:cloud_firestore/cloud_firestore.dart';

class StopConnection {
  int stopCode;
  int lineCode;
  String name;
  String operator;
  String colorText;
  String colorRect;

  StopConnection({
    required this.stopCode,
    required this.lineCode,
    required this.name,
    required this.operator,
    required this.colorText,
    required this.colorRect,
  });

  StopConnection.fromJsonAPI(Map<String, dynamic> json)
      : stopCode = json["properties"]["CODI_PARADA"],
        lineCode = json["properties"]["CODI_LINIA"],
        name = json["properties"]["NOM_LINIA"],
        operator = json["properties"]["NOM_OPERADOR"],
        colorRect = "#${json["properties"]["COLOR_LINIA"]}",
        colorText = "#${json["properties"]["COLOR_TEXT_LINIA"]}";

  StopConnection.fromFireStoreJsonFire(Map<String, dynamic>doc)
      : stopCode = doc["stopCode"],
        lineCode = doc["lineCode"],
        name = doc["name"],
        operator = doc["operator"],
        colorText = doc["colorText"],
        colorRect = doc["colorRect"];

  StopConnection.fromFireStore(DocumentSnapshot doc)
      : stopCode = doc["stopCode"],
        lineCode = doc["lineCode"],
        name = doc["name"],
        operator = doc["operator"],
        colorText = doc["colorText"],
        colorRect = doc["colorRect"];

  Map<String, dynamic> toFireStore() => {
        "stopCode": stopCode,
        "lineCode": lineCode,
        "name": name,
        "operator": operator,
        "colorText": colorText,
        "colorRect": colorRect,
      };
}
