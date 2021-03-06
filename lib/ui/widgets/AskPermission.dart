import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import "BottomBarBlackContainer.dart";
import "CardTemplate.dart";
import '../../core/providers/ToiletModel.dart';

class AskPermission extends StatelessWidget {
  const AskPermission(
    this.scrollProgress,
    this.sc,
  );

  final double scrollProgress;
  final ScrollController sc;

  @override
  Widget build(BuildContext context) {
    final checkLocationPermission =
        Provider.of<ToiletModel>(context, listen: false)
            .checkLocationPermission;

    return Column(
      children: [
        BottomBarBlackContainer(
          scrollProgress,
          checkLocationPermission,
          Text(
            AppLocalizations.of(context).noLocationTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              fontFamily: "Muli",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0),
          child: CardTemplate(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).noLocationCardTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(height: 8),
                Text(
                  AppLocalizations.of(context).noLocationCardDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            gradient: LinearGradient(
              stops: [0],
              colors: [Colors.grey[100]],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 25,
            ),
          ),
        ),
      ],
    );
  }
}
