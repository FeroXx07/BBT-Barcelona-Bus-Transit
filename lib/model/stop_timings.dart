import 'package:barcelona_bus_transit/model/stop_connections.dart';
import 'package:barcelona_bus_transit/utilities/tmb_api.dart';
import 'package:http/http.dart' as http;

class StopTiming {
  String status;
  String routeId;
  int timeInMin;
  int timeInSeconds;
  String timeInString;
  String destination;

  StopTiming(
      {required this.status,
      required this.routeId,
      required this.timeInMin,
      required this.timeInSeconds,
      required this.timeInString,
      required this.destination});

  StopTiming.fromJson(Map<String, dynamic> json)
      : status = json["status"],
        routeId = json["data"]["data"]["routeId"],
        timeInMin = json["data"]["data"]["t-in-min"],
        timeInSeconds = json["data"]["data"]["t-in-s"],
        timeInString = json["data"]["data"]["text-ca"],
        destination = json["data"]["data"]["destination"];
}

// Stream<StopTiming> getTimingsConnection(StopConnection connection) {
//   String url =
//       "https://api.tmb.cat/v1/ibus/lines/${connection.lineCode}/stops/${connection.stopCode}?";
//   url = url + getApiString();
//   final uri = Uri.parse(url);
//   final response = http.get(uri);
//   Map<String, dynamic> busInfo = jsonDecode(response.toString());
//   var stop = StopTiming.fromJson(busInfo["features"][0]);

//   return stop;
// }

Stream<http.Response> getTimeConnection(StopConnection connection) async* {
  yield* Stream.periodic(const Duration(seconds: 5), (_) {
    String url =
        "https://api.tmb.cat/v1/ibus/lines/${connection.lineCode}/stops/${connection.stopCode}?";
    url = url + getApiString();
    final uri = Uri.parse(url);

    return http.get(uri);
  }).asyncMap((event) async => await event);
}
