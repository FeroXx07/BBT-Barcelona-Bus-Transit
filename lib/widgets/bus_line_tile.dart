
import 'package:barcelona_bus_transit/model/bus_line.dart';
import 'package:barcelona_bus_transit/utilities/hex_color.dart';
import 'package:barcelona_bus_transit/widgets/custom_icons.dart';
import 'package:flutter/material.dart';

class LineTile extends StatelessWidget {
  final BusLine busLine;
  const LineTile({super.key, 
    required this.busLine,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: roundedDecoration(),
      child: ListTile(
        // leading: CircleAvatar(
        //   backgroundImage: NetworkImage(user.avatarUrl),
        // ),
        leading: CircleIcon(busLine: busLine),
        title: Text(busLine.description),
        trailing: const IsFavoriteStar(isFavorite: false),
        contentPadding:
            const EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 15),
        onTap: () {
          Navigator.of(context).pushNamed(
            '/stopsList',
            arguments: busLine.code,
          );
        },
      ),
    );
  }
}
