import 'package:barcelona_bus_transit/model/bus_line.dart';
import 'package:barcelona_bus_transit/model/hex_color.dart';
import 'package:flutter/material.dart';

class IsFavoriteStar extends StatefulWidget {

  const IsFavoriteStar({
    Key? key,
    required isFavorite,
  }) : super(key: key);

  @override
  State<IsFavoriteStar> createState() => _IsFavoriteStarState();
}

class _IsFavoriteStarState extends State<IsFavoriteStar> {
  final bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return  IconButton(
      onPressed: () {
      },
      icon: const Icon(Icons.star_border));
  }
}

class CircleIcon extends StatelessWidget {
  const CircleIcon({
    Key? key,
    required this.busLine,
  }) : super(key: key);

  final BusLine busLine;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        color: hexToColor(busLine.primaryColor),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          busLine.name,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
