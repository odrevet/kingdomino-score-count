import 'package:flutter/material.dart';

import 'cardboard_tile.dart';
import 'kingdomino_widget.dart';

class CastleTile extends StatelessWidget {
  final Color kingColor;

  const CastleTile(this.kingColor, {super.key});

  @override
  Widget build(BuildContext context) {
    return CardboardTile(
      child: Container(
          color: kingColor,
          child: const FittedBox(fit: BoxFit.fitWidth, child: Text(castle))),
    );
  }
}
