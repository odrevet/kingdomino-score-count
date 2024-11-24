import 'game_set.dart';
import 'kingdom_size.dart';
import 'land.dart';
import 'property.dart';

class Kingdom {
  KingdomSize kingdomSize = KingdomSize.small;
  late List<List<Land>> lands = [];

  Kingdom({required this.kingdomSize, List<List<Land>>? lands}) {
    if (lands != null) {
      this.lands = lands;
    } else {
      this.lands = [];
      for (var i = 0; i < kingdomSize.size; i++) {
        this.lands.add(List<Land>.generate(kingdomSize.size, (_) => Land()));
      }
    }
  }

  Kingdom copyWith(
      {KingdomSize? kingdomSize, KingColor? player, List<List<Land>>? lands}) {
    if (lands == null) {
      var landsCopy = [];
      for (var i = 0; i < this.kingdomSize.size; i++) {
        landsCopy.add(List<Land>.generate(
            this.kingdomSize.size, (j) => getLand(j, i)!.copyWith()));
      }
    }
    return Kingdom(
        kingdomSize: kingdomSize ?? this.kingdomSize,
        lands: lands ?? this.lands);
  }

  List<List<Land>> getLands() {
    return lands;
  }

  Land? getLand(int y, int x) {
    if (y < 0 || x < 0 || x > kingdomSize.size || y > kingdomSize.size) {
      return null;
    }

    return lands[x][y];
  }

  void reSize(KingdomSize kingdomSize) {
    this.kingdomSize = kingdomSize;
    lands = [];
    for (var i = 0; i < kingdomSize.size; i++) {
      lands.add(List<Land>.generate(kingdomSize.size, (_) => Land()));
    }
  }

  void clear() {
    lands.expand((i) => i).toList().forEach((land) {
      land.landType = LandType.empty;
      land.crowns = 0;
      land.giants = 0;
      land.hasResource = false;
      land.courtier = null;
    });
  }

  List<Property> getProperties() {
    var properties = <Property>[];

    for (var x = 0; x < kingdomSize.size; x++) {
      for (var y = 0; y < kingdomSize.size; y++) {
        var property = _getAdjacentLand(x, y, null);
        if (property != null) {
          properties.add(property);
        }
      }
    }

    //reset marked status
    lands.expand((i) => i).toList().forEach((land) => land.isMarked = false);

    return properties;
  }

  ///add land at x y to the property if it's landType is the same as land
  void _addLandToProperty(int x, int y, Land land, Property property) {
    if (isInBound(x, y)) {
      Land? landToAdd = getLand(x, y);
      if (landToAdd != null &&
          landToAdd.landType == land.landType &&
          landToAdd.isMarked == false) {
        property.landCount++;
        property.crownCount += landToAdd.getCrowns();
        property.giantCount += landToAdd.giants;
        _getAdjacentLand(x, y, property);
      }
    }
  }

  Property? _getAdjacentLand(int x, int y, Property? property) {
    if (!isInBound(x, y)) return null;

    Land? land = getLand(x, y);
    if (land == null ||
        land.landType == LandType.empty ||
        land.landType == LandType.castle ||
        land.isMarked == true) return null;

    if (property == null) {
      property = Property(land.landType);
      property.landCount++;
      property.crownCount += land.getCrowns();
      property.giantCount += land.giants;
    }

    land.isMarked = true;

    _addLandToProperty(x, y - 1, land, property);
    _addLandToProperty(x, y + 1, land, property);
    _addLandToProperty(x - 1, y, land, property);
    _addLandToProperty(x + 1, y, land, property);

    return property;
  }

  int calculateScoreFromProperties(List<Property> properties) {
    int score = 0;
    for (var property in properties) {
      score += property.landCount * property.crownCount;
    }
    return score;
  }

  bool isInBound(int x, int y) {
    return (x >= 0 && x < kingdomSize.size && y >= 0 && y < kingdomSize.size);
  }
}
