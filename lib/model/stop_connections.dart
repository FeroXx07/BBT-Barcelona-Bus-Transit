

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
        colorRect = "#${json["properties"]["COLOR_LINIA"]}",
        colorText = "#${json["properties"]["COLOR_TEXT_LINIA"]}";
}