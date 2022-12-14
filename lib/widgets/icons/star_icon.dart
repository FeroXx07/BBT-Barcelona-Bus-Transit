import 'package:flutter/material.dart';

class StarIcon extends StatelessWidget {
  final bool state;
  const StarIcon({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      state ? Icons.star : Icons.star_border,
      color: state ? Colors.yellow : Colors.black,
      shadows: const [
        Shadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 2),
      ],
    );
  }
}
