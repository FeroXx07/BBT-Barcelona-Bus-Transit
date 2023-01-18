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

  StopTiming.fromJsonClosed()
      : status = "failure",
        routeId = "line closed",
        timeInMin = 0,
        timeInSeconds = 0,
        timeInString = "no time, line closed",
        destination = "no destination, line closed";

  StopTiming.fromJsonOpened(Map<String, dynamic> json)
      : status = "success",
        routeId = json["routeId"],
        timeInMin = json["t-in-min"],
        timeInSeconds = json["t-in-s"],
        timeInString = json["text-ca"],
        destination = json["destination"];
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
        "https://api.tmb.cat/v1/ibus/lines/${connection.name}/stops/${connection.stopCode}?";
    url = url + getApiString();
    final uri = Uri.parse(url);

    return http.get(uri);
  }).asyncMap((event) async => await event);
}
