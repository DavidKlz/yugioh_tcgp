import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yugioh_tcgp/view/pages/cards_overview_page.dart';
import 'package:yugioh_tcgp/view/pages/detail_card_page.dart';

import '../../logic/data/card_info.dart';
import 'routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch(settings.name) {
      case Routes.detail:
        return _createRoute(DetailCardPage(card: settings.arguments as CardInfo));
      case Routes.overview:
      default:
        return _createRoute(const CardsOverviewPage());
    }
  }

  static MaterialPageRoute _createRoute(Widget screen) {
    return MaterialPageRoute(
      builder: (context) => screen,
    );
  }
}