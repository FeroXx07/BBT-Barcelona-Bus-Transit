import 'package:barcelona_bus_transit/model/tmb_lists.dart';
import 'package:barcelona_bus_transit/widgets/hex_color.dart';
import 'package:flutter/material.dart';

class BusesLinesListScreen extends StatelessWidget {
  const BusesLinesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: FutureBuilder(
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
          return _BusesLineList(linesList: snapshot.data!);
        },
      ),
    );
  }
}

class _BusesLineList extends StatelessWidget {
  final List<BusLine> linesList;
  const _BusesLineList({
    required this.linesList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: ListView.builder(
          itemCount: linesList!.length,
          itemBuilder: (context, index) {
            return BusLineWidget(busLine: linesList![index]);
          },
        ),
      ),
    );
  }
}

class BusLineWidget extends StatelessWidget {
  final BusLine busLine;
  const BusLineWidget({
    super.key,
    required this.busLine,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: CircleAvatar(
      //   backgroundImage: NetworkImage(user.avatarUrl),
      // ),
      title: Text(busLine.name),
      subtitle: Text(busLine.description),
      trailing: Container(
        width: 50,
        height: 50,
        child: Center(child: Text(busLine.name)),
        decoration: BoxDecoration(
          color: hexToColor(busLine.primaryColor),
          shape: BoxShape.circle,
        ),
      ),
      // onTap: () {
      //   Navigator.of(context).pushNamed(
      //     '/user-details',
      //     arguments: user,
      //   );
      // },
    );
  }
}
