import 'package:barcelona_bus_transit/widgets/icons/star_icon.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class IsFavoriteStar extends StatefulWidget {
  final void Function(bool) onFavoritePressed;
  final bool isFavorite;
  const IsFavoriteStar({super.key, 
    required this.onFavoritePressed,
    required this.isFavorite,
  });

  @override
  State<IsFavoriteStar> createState() => _IsFavoriteStarState();
}

class _IsFavoriteStarState extends State<IsFavoriteStar> {
  @override
  void didChangeDependencies() {
    setState(() {
      _isFavorite = widget.isFavorite;
    });
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant IsFavoriteStar oldWidget) {
    setState(() {
      _isFavorite = widget.isFavorite;
    });
    super.didUpdateWidget(oldWidget);
  }

  bool _isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          setState(() {
            _isFavorite = !_isFavorite;
            developer.log("changing state to ${_isFavorite.toString()}}");
            widget.onFavoritePressed(_isFavorite);
          });
        },
        icon: _isFavorite
            ? const StarIcon(state: true)
            : const StarIcon(state: false));
  }
}
