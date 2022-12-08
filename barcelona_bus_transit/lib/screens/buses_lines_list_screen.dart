import 'package:barcelona_bus_transit/model/tmb_lists.dart';
import 'package:barcelona_bus_transit/widgets/hex_color.dart';
import 'package:flutter/material.dart';

class BusesLinesListScreen extends StatelessWidget {
  const BusesLinesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        //Here is the preferred height.
        preferredSize: const Size.fromHeight(125),
        child: AppBar(
          title: const Text("Bus lines"),
          centerTitle: true,
          toolbarHeight: 125,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
            iconSize: 80,
            color: myColor2,
          ),
          actions: [
            IconButton(
              onPressed: (() {}),
              icon: const Icon(Icons.more_vert),
              iconSize: 50,
              color: myColor4,
            )
          ],
        ),
      ),
      body: _BusLinesBuilder(),
    );
  }

  FutureBuilder<List<BusLine>> _BusLinesBuilder() {
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
        return _BusesLineList(linesList: snapshot.data!);
      },
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
        child: Container(
          color: myColor3,
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: linesList!.length,
            itemBuilder: (context, index) {
              return BusLineTile(busLine: linesList![index]);
            },
          ),
        ),
      ),
    );
  }
}

class BusLineTile extends StatelessWidget {
  final BusLine busLine;
  const BusLineTile({
    super.key,
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
        onTap: () {
          
        },
        // leading: CircleAvatar(
        //   backgroundImage: NetworkImage(user.avatarUrl),
        // ),
        leading: CircleIcon(busLine: busLine),
        title: Text(busLine.description),
        trailing: const IsFavoriteStar(isFavorite: false),
        contentPadding:
            const EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 15),
        // onTap: () {
        //   Navigator.of(context).pushNamed(
        //     '/user-details',
        //     arguments: user,
        //   );
        // },
      ),
    );
  }
}

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
