import 'package:barcelona_bus_transit/widgets/icons/star_icon.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class IsFavoriteStar extends StatefulWidget {
  final void Function(bool) onFavoritePressed;
  const IsFavoriteStar({
    Key? key,
    required isFavorite,
    required this.onFavoritePressed,
  }) : super(key: key);

  @override
  State<IsFavoriteStar> createState() => _IsFavoriteStarState();
}

class _IsFavoriteStarState extends State<IsFavoriteStar> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          setState(() {
            isFavorite = !isFavorite;
            developer.log("changing state to ${isFavorite.toString()}}");
            widget.onFavoritePressed(isFavorite);
          });
        },
        icon: isFavorite
            ? const StarIcon(state: true)
            : const StarIcon(state: false));
  }
}
