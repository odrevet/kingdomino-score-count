import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/cubits/score_cubit.dart';
import 'package:kingdomino_score_count/cubits/theme_cubit.dart';

import 'kingdomino_widget.dart';

class KingdominoApp extends StatelessWidget {
  const KingdominoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, MaterialColor>(
        builder: (context, color) => MaterialApp(
            title: 'Kingdomino Score',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                brightness: MediaQuery.platformBrightnessOf(context),
                seedColor: color,
              ),
              fontFamily: 'HammersmithOne',
            ),
            home: MultiBlocProvider(providers: [
              BlocProvider<ScoreCubit>(
                create: (BuildContext context) => ScoreCubit(),
              ),
              BlocProvider<KingdomCubit>(
                create: (BuildContext context) => KingdomCubit(),
              ),
            ], child: const KingdominoWidget())),
      ),
    );
  }
}
