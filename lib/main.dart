import 'package:barcelona_bus_transit/screens/favorite_list_screen.dart';
import 'package:barcelona_bus_transit/screens/lines_list_screen.dart';
import 'package:barcelona_bus_transit/screens/stop_timings_list_screen.dart';
import 'package:barcelona_bus_transit/screens/stops_list_screen.dart';
import 'package:barcelona_bus_transit/utilities/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BarcelonaBusTransitApp());
}

class BarcelonaBusTransitApp extends StatelessWidget {
  const BarcelonaBusTransitApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: myColor1),
      ),
      initialRoute: '/busesList',
      routes: {
        '/busesList': (context) => const LinesListScreen(),
        '/stopsList': (context) => const StopsListScreen(),
        '/favoriteList': (context) => const FavoritesListScreen(),
        "/stopScreen": ((context) => const StopTimingsListScreen())
      },
    );
  }
}
