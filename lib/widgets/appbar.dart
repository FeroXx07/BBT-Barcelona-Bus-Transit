import 'package:barcelona_bus_transit/model/hex_color.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  const CustomAppbar({
    Key? key, required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      toolbarHeight: 100,
      leading: IconButton(
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
        icon: const Icon(Icons.arrow_back),
        iconSize: 50,
        color: myColor4,
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.person),
          iconSize: 50,
          color: myColor4,
        )
      ],
    );
  }
}
