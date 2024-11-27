import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yugioh_tcgp/view/pages/cards_overview_page.dart';
import 'package:yugioh_tcgp/view/widgets/playing_card.dart';

import 'config/routing/app_router.dart';
import 'config/routing/routes.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: Routes.overview,
    );
  }
}
