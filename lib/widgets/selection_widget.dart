import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcelona_bus_transit/utilities/hex_color.dart';
import 'package:barcelona_bus_transit/widgets/icons/star_icon.dart';
import 'package:flutter/material.dart';

class FavoriteSelectionsWidget extends StatefulWidget {
  final int direction = 1;
  final void Function(int) onDirectionPressed;
  const FavoriteSelectionsWidget({
    Key? key,
    required this.onDirectionPressed,
  }) : super(key: key);

  @override
  State<FavoriteSelectionsWidget> createState() =>
      _FavoriteSelectionsWidgetState();
}

class _FavoriteSelectionsWidgetState extends State<FavoriteSelectionsWidget> {
  int _direction = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        selectionBox("Lines", myColor2, myColor3, 1),
        selectionBox("Favorites", myColor2, myColor3, 2),
      ],
    );
  }

  Expanded selectionBox(
      String name, Color enabledColor, Color disabledColor, final int dir) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              onTap: () {
                setState(() {
                  _direction = dir;
                  widget.onDirectionPressed(_direction);
                });
              },
              contentPadding: const EdgeInsets.all(30),
              tileColor: _direction == dir ? enabledColor : disabledColor,
              leading: const StarIcon(state: true),
              title: AutoSizeText(
                style: const TextStyle(fontSize: 12, color: myColor4),
                name,
              ),
            ),
          )
        ],
      ),
    );
  }
}
