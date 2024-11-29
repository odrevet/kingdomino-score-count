import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/game.dart';
import '../models/game_set.dart';
import '../models/kingdom.dart';
import '../models/player.dart';
import '../models/rules.dart';
import '../models/score.dart';

class GameCubit extends Cubit<Game> {
  GameCubit()
      : super(Game(kingColor: KingColor.blue, players: [
          Player(score: Score(), warnings: [], kingColor: KingColor.blue),
          Player(score: Score(), warnings: [], kingColor: KingColor.green),
          Player(score: Score(), warnings: [], kingColor: KingColor.yellow),
          Player(score: Score(), warnings: [], kingColor: KingColor.pink),
          Player(score: Score(), warnings: [], kingColor: KingColor.brown),
        ])) {
    setPlayer(KingColor.blue);
  }

  void calculateScore(KingColor kingColor, Kingdom kingdom, Rules rules) {
    final newScore = Score.calculateFromKingdom(
        kingdom, rules.extension, rules.selectedQuests);

    final updatedPlayers = state.players.map((player) {
      return player.kingColor == kingColor
          ? player.copyWith(score: newScore)
          : player;
    }).toList();

    emit(state.copyWith(players: updatedPlayers));
  }

  void setWarnings(Kingdom kingdom, Rules rules) {
    final currentPlayer = state.getCurrentPlayer()!;

    final updatedPlayers = state.players.map((player) {
      return player.kingColor == currentPlayer.kingColor
          ? player.copyWith(warnings: checkKingdom(kingdom, rules.extension))
          : player;
    }).toList();

    emit(state.copyWith(players: updatedPlayers));
  }

  void setPlayer(KingColor kingColor) {
    emit(state.copyWith(kingColor: kingColor));
  }
}
