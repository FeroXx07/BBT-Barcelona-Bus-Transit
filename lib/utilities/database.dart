import 'package:barcelona_bus_transit/model/bus_line.dart';
import 'package:barcelona_bus_transit/model/bus_stop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String userId = "CM0Rrrc4JF6xH0D40i77"; // Hardcoded for this version

Future<void> setFavoriteBusLine(BusLine busLine) async {
  busLine.isFavorite = true;

  // Get firestore instance and the path where to manage data
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference busLineCollection =
      db.collection("Users").doc(userId).collection("BusLines");

  // Create a model for Json
  final fireStoreModel = busLine.toFireStore();

  // Upload that model
  busLineCollection.doc(busLine.uniqueId).set(fireStoreModel);
}

Future<void> removeFavoriteBusLine(BusLine busLine) async {
   busLine.isFavorite = false;
   
  // Get firestore instance and the path where to manage data
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference busLineCollection =
      db.collection("Users").doc(userId).collection("BusLines");

  // Delete that saved model
  busLineCollection.doc(busLine.uniqueId).delete();
}

Stream<List<BusLine>> getFavoriteBusLines() {
  // Get firestore instance and the path where to manage data
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference busLineCollection =
      db.collection("Users").doc(userId).collection("BusLines");

  return busLineCollection
      .get()
      .then((querySnapshot) => toBusLineList(querySnapshot))
      .asStream();
}

Future<void> setFavoriteBusStop(BusStop busStop) async {
  // Get firestore instance and the path where to manage data
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference busLineCollection =
      db.collection("Users").doc(userId).collection("BusStops");

  // Create a model for Json
  final fireStoreModel = busStop.toFirestore();

  // Upload that model
  busLineCollection.doc(busStop.uniqueId).set(fireStoreModel);
}

Future<void> removeFavoriteBusStop(BusStop busStop) async {
  // Get firestore instance and the path where to manage data
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference busLineCollection =
      db.collection("Users").doc(userId).collection("BusStops");

  // Delete that saved model
  busLineCollection.doc(busStop.uniqueId).delete();
}

Stream<List<BusStop>> getFavoriteBusStopes() {
  // Get firestore instance and the path where to manage data
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference busStopCollection =
      db.collection("Users").doc(userId).collection("BusStops");

  return busStopCollection
      .get()
      .then((querySnapshot) => toBusStopList(querySnapshot))
      .asStream();
}
