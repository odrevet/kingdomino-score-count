import '../kingdom.dart';
import '../land.dart' show LandType;
import 'quest.dart';

class MiddleKingdom extends Quest {
  static final MiddleKingdom _singleton = MiddleKingdom._internal();

  factory MiddleKingdom() {
    return _singleton;
  }

  MiddleKingdom._internal() : super(reward: 10);

  @override
  int getPoints(Kingdom kingdom) {
    int x, y;

    if (kingdom.size == 5) {
      x = y = 2;
    } else {
      x = y = 3;
    }

    if (kingdom.getLand(x, y)?.landType == LandType.castle) {
      return reward;
    } else {
      return 0;
    }
  }
}
