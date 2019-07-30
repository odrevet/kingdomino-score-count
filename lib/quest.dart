import 'package:flutter/material.dart';

import 'kingdom.dart';

const String shield = '\u{1F6E1}';

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
        Text(' ' + points.toString(),  style: TextStyle(fontSize: 25))
      ],
    );
  }
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
    return Row(children: <Widget>[
      QuestPointWidget(quest.extraPoints),
      Text('Harmony')
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

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      QuestPointWidget(quest.extraPoints),
      Text('Middle Kingdom')
    ]);
  }
}