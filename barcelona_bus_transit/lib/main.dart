import 'package:barcelona_bus_transit/screens/buses_lines_list_screen.dart';
import 'package:barcelona_bus_transit/widgets/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: myColor1),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const BusesLinesListScreen(),
      },
    );
  }
}
