import 'package:barcelona_bus_transit/widgets/appbar.dart';
import 'package:barcelona_bus_transit/widgets/selection_widget.dart';
import 'package:flutter/material.dart';

class FavoritesListScreen extends StatelessWidget {
  const FavoritesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
          //Here is the preferred height.
          preferredSize: Size.fromHeight(100),
          child: CustomAppbar(
            title: "Bus Lines",
          )),
      body: Selector(),
    );
  }
}

class Selector extends StatefulWidget {
  const Selector({super.key});

  @override
  State<Selector> createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  int _direction = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FavoriteSelectionsWidget(onDirectionPressed: ((output) {
          setState(() {
            _direction = output;
          });
        })),
      ],
    );
  }
}

class FavStopsList extends StatefulWidget {
  const FavStopsList({super.key});

  @override
  State<FavStopsList> createState() => _FavStopsListState();
}

class _FavStopsListState extends State<FavStopsList> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FavLinesList extends StatefulWidget {
  const FavLinesList({super.key});

  @override
  State<FavLinesList> createState() => _FavLinesListState();
}

class _FavLinesListState extends State<FavLinesList> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
