import 'package:barcelona_bus_transit/model/tmb_lists.dart';
import 'package:barcelona_bus_transit/widgets/appbar.dart';
import 'package:barcelona_bus_transit/widgets/custom_icons.dart';
import 'package:barcelona_bus_transit/widgets/hex_color.dart';
import 'package:flutter/material.dart';

class LinesListScreen extends StatelessWidget {
  const LinesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        //Here is the preferred height.
        preferredSize: Size.fromHeight(100),
        child: CustomAppbar(title: "Bus Lines",)
      ),
      body: _busLinesFutureBuilder(),
    );
  }

  FutureBuilder<List<BusLine>> _busLinesFutureBuilder() {
    return FutureBuilder(
      future: loadAllBusesLines(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return _LinesTileBuilder(linesList: snapshot.data!);
      },
    );
  }
}

class _LinesTileBuilder extends StatelessWidget {
  final List<BusLine> linesList;
  const _LinesTileBuilder({
    required this.linesList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: Container(
          color: myColor3,
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: linesList!.length,
            itemBuilder: (context, index) {
              return _LineTile(busLine: linesList![index]);
            },
          ),
        ),
      ),
    );
  }
}

class _LineTile extends StatelessWidget {
  final BusLine busLine;
  const _LineTile({
    required this.busLine,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 6, color: myColor2),
        borderRadius: const BorderRadius.all(
          Radius.circular(40),
        ),
      ),
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

