import 'package:flutter/material.dart';

import 'main.dart' show castle;
import 'kingdom.dart';
import 'kingdomWidget.dart';

const String shield = '\u{1F6E1}';
const String check = '\u{2713}';

///render a shield with point awarded in front
class QuestPointWidget extends StatelessWidget {
  int points;

  QuestPointWidget(int points) {
    this.points = points;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text(
          shield,
          style: TextStyle(fontSize: 40),
        ),
        Text(' ' + points.toString(), style: TextStyle(fontSize: 25))
      ],
    );
  }
}

Widget landWidget(LandType landType, [double size = 50.0]) {
  return Container(
      child: Container(
    height: size,
    width: size,
    child: Container(
        color: getColorForLandType(landType),
        child: landType == LandType.castle
            ? FittedBox(fit: BoxFit.fitWidth, child: Text(castle))
            : Text('')),
  ));
}

abstract class Quest {
  int extraPoints; //points awarded if quest is fulfilled

  int getPoints(Kingdom kingdom);
}

abstract class QuestWidget extends StatelessWidget {
  Quest quest;
}

class Harmony extends Quest {
  int extraPoints = 5;

  int getPoints(Kingdom kingdom) {
    return kingdom.lands
            .expand((i) => i)
            .toList()
            .where((land) => land.landType == LandType.none)
            .isEmpty
        ? extraPoints
        : 0;
  }
}

class HarmonyWidget extends QuestWidget {
  final quest = Harmony();

  @override
  Widget build(BuildContext context) {
    const String rectangle = '\u{25AD}';
    const String trashCan = '\u{1F5D1}';
    const String cross = '\u{2717}';

    return Row(children: <Widget>[
      QuestPointWidget(quest.extraPoints),
      Stack(children: [
        Text(rectangle, style: TextStyle(fontSize: 40)),
        Text(cross, style: TextStyle(fontSize: 40, color: Colors.red))
      ]),
      Icon(Icons.delete)
    ]);
  }
}

class MiddleKingdom extends Quest {
  final int extraPoints = 10;

  int getPoints(Kingdom kingdom) {
    int x, y;

    if (kingdom.size == 5) {
      x = y = 2;
    } else {
      x = y = 3;
    }

    if (kingdom.lands[x][y].landType == LandType.castle)
      return extraPoints;
    else
      return 0;
  }
}

class MiddleKingdomWidget extends QuestWidget {
  final quest = MiddleKingdom();

  Widget _buildTable() {
    return Container(
        constraints: BoxConstraints(
            maxHeight: 50.0, maxWidth: 50.0, minWidth: 50.0, minHeight: 50.0),
        child: Table(
            border: TableBorder.all(width: 0.1, color: Colors.grey),
            children: [
              TableRow(children: [
                Text(' '),
                Text(' '),
                Text(' '),
              ]),
              TableRow(children: [
                Text(' '),
                Text(check),
                Text(' '),
              ]),
              TableRow(children: [
                Text(' '),
                Text(' '),
                Text(' '),
              ]),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Stack(children: [
        landWidget(LandType.castle),
        QuestPointWidget(quest.extraPoints)
      ]),
      _buildTable()
    ]);
  }
}
