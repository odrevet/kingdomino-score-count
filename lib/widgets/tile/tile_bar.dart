import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/models/extensions/extension.dart';
import 'package:kingdomino_score_count/widgets/tile/land_tile.dart';

import '../../cubits/app_state_cubit.dart';
import '../../cubits/theme_cubit.dart';
import '../../models/app_state.dart';
import '../../models/extensions/age_of_giants.dart';
import '../../models/extensions/lacour/lacour.dart';
import '../../models/land.dart';
import '../../models/user_selection.dart';
import 'castle_tile.dart';
import '../highlight_box.dart';
import '../kingdomino_widget.dart';

class TileBar extends StatefulWidget {
  final Function getSelectedcourtier;
  final Function setSelectedcourtier;
  final bool verticalAlign;

  const TileBar(
      {required this.getSelectedcourtier,
      required this.setSelectedcourtier,
      required this.verticalAlign,
      super.key});

  @override
  State<TileBar> createState() => _TileBarState();
}

class _TileBarState extends State<TileBar> {
  _TileBarState();

  final double _buttonSize = 40.0;

  var outline = Border(
    right: BorderSide(width: 3.5, color: Colors.blueGrey.shade600),
    bottom: BorderSide(width: 3.5, color: Colors.blueGrey.shade900),
  );

  @override
  Widget build(BuildContext context) {
    var kingdomEditorWidgets = [
      landButton(LandType.wheat),
      landButton(LandType.grassland),
      landButton(LandType.forest),
      landButton(LandType.lake),
      landButton(LandType.swamp),
      landButton(LandType.mine),
      widget.verticalAlign ? const Divider() : const VerticalDivider(),
      landButton(LandType.empty),
      widget.verticalAlign ? const Divider() : const VerticalDivider(),
      castleButton(),
      crownButton(),
    ];

    if (context.read<AppStateCubit>().state.userSelection.extension == Extension.ageOfGiants) {
      kingdomEditorWidgets.add(giantButton());
    } else if (context.read<AppStateCubit>().state.userSelection.extension == Extension.laCour) {
      kingdomEditorWidgets.add(resourceButton());

      for (var element in [
        Farmer(),
        Banker(),
        AxeWarrior(),
        Captain(),
        Fisherman(),
        HeavyArchery(),
        King(),
        LightArchery(),
        Lumberjack(),
        Queen(),
        Shepherdess(),
        SwordWarrior()
      ]) {
        kingdomEditorWidgets.add(courtierButton(element));
      }
    }

    return Align(
      alignment: Alignment.center,
      child: Wrap(
        direction: widget.verticalAlign ? Axis.vertical : Axis.horizontal,
        alignment: WrapAlignment.center,
        children: kingdomEditorWidgets,
      ),
    );
  }

  Widget landButton(LandType landType) {
    var isSelected =
        context.read<AppStateCubit>().state.userSelection.getSelectionMode() ==
                SelectionMode.land &&
            context
                    .read<AppStateCubit>()
                    .state
                    .userSelection
                    .getSelectedLandType() ==
                landType;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () => _onSelectLandType(landType),
          child: Container(
              margin: const EdgeInsets.all(5.0),
              height: _buttonSize,
              width: _buttonSize,
              decoration: BoxDecoration(
                  boxShadow: isSelected
                      ? [highlightBox(context.read<ThemeCubit>().state)]
                      : null),
              child: LandTile(landType: landType))),
    );
  }

  Widget resourceButton() {
    var isSelected =
        context.read<AppStateCubit>().state.userSelection.getSelectionMode() ==
            SelectionMode.resource;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () => context
              .read<AppStateCubit>()
              .state
              .userSelection
              .setSelectionMode(SelectionMode.resource),
          child: Container(
              margin: const EdgeInsets.all(5.0),
              height: _buttonSize,
              width: _buttonSize,
              decoration: BoxDecoration(
                  boxShadow: isSelected
                      ? [highlightBox(context.read<ThemeCubit>().state)]
                      : null),
              child: Image.asset('assets/lacour/resource.png'))),
    );
  }

  Widget courtierButton(Courtier courtier) {
    var isSelected =
        context.read<AppStateCubit>().state.userSelection.getSelectionMode() ==
                SelectionMode.courtier &&
            widget.getSelectedcourtier() == courtier;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () => _onSelectcourtier(courtier),
          child: Container(
              margin: const EdgeInsets.all(5.0),
              height: _buttonSize,
              width: _buttonSize,
              decoration: BoxDecoration(
                  boxShadow: isSelected
                      ? [highlightBox(context.read<ThemeCubit>().state)]
                      : null),
              child: Image(
                  height: 50,
                  width: 50,
                  image: AssetImage(courtierPicture[courtier.runtimeType]!)))),
    );
  }

  Widget castleButton() {
    return BlocBuilder<AppStateCubit, AppState>(
        builder: (BuildContext context, appState) {

      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => setState(() {
            context
                .read<AppStateCubit>()
                .state
                .userSelection
                .setSelectionMode(SelectionMode.castle);
            context
                .read<AppStateCubit>()
                .state
                .userSelection
                .setSelectedLandType(LandType.castle);
          }),
          child: Container(
            margin: const EdgeInsets.all(5.0),
            height: _buttonSize,
            width: _buttonSize,
            decoration: BoxDecoration(
                boxShadow: appState.userSelection.getSelectionMode() ==
                            SelectionMode.castle &&
                        appState.userSelection.getSelectedLandType() ==
                            LandType.castle
                    ? [highlightBox(context.read<ThemeCubit>().state)]
                    : null,
                border: outline),
            child: CastleTile(context.read<ThemeCubit>().state),
          ),
        ),
      );
    });
  }

  Widget crownButton() {
    var isSelected =
        context.read<AppStateCubit>().state.userSelection.getSelectionMode() ==
            SelectionMode.crown;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () => _onSelectCrown(),
          child: Container(
            margin: const EdgeInsets.all(5.0),
            height: _buttonSize,
            width: _buttonSize,
            decoration: BoxDecoration(
                boxShadow: isSelected
                    ? [highlightBox(context.read<ThemeCubit>().state)]
                    : null),
            child: const FittedBox(fit: BoxFit.fitHeight, child: Text(crown)),
          )),
    );
  }

  Widget giantButton() {
    var isSelected =
        context.read<AppStateCubit>().state.userSelection.getSelectionMode() ==
            SelectionMode.giant;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () => _onSelectGiant(),
          child: Container(
            margin: const EdgeInsets.all(5.0),
            height: _buttonSize,
            width: _buttonSize,
            decoration: BoxDecoration(
                boxShadow: isSelected
                    ? [highlightBox(context.read<ThemeCubit>().state)]
                    : null),
            child: const FittedBox(fit: BoxFit.fitHeight, child: Text(giant)),
          )),
    );
  }

  //CALLBACKS
  void _onSelectLandType(LandType? selectedType) {
    if (selectedType == LandType.castle) {
      _onSelectCastle();
    } else {
      setState(() {
        context
            .read<AppStateCubit>()
            .state
            .userSelection
            .setSelectedLandType(selectedType);
        context
            .read<AppStateCubit>()
            .state
            .userSelection
            .setSelectionMode(SelectionMode.land);
      });
    }
  }

  void _onSelectcourtier(Courtier courtier) {
    setState(() {
      widget.setSelectedcourtier(courtier);
      context
          .read<AppStateCubit>()
          .state
          .userSelection
          .setSelectionMode(SelectionMode.courtier);
    });
  }

  void _onSelectCrown() {
    setState(() {
      context
          .read<AppStateCubit>()
          .state
          .userSelection
          .setSelectionMode(SelectionMode.crown);
    });
  }

  void _onSelectCastle() {
    setState(() {
      context
          .read<AppStateCubit>()
          .state
          .userSelection
          .setSelectedLandType(LandType.castle);
      context
          .read<AppStateCubit>()
          .state
          .userSelection
          .setSelectionMode(SelectionMode.castle);
    });
  }

  void _onSelectGiant() {
    setState(() {
      context
          .read<AppStateCubit>()
          .state
          .userSelection
          .setSelectionMode(SelectionMode.giant);
    });
  }
}