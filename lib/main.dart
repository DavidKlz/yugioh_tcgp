import 'package:flutter/material.dart';
import 'package:yugioh_tcgp/playing_card.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(child: PlayingCard()),
        ),
      ),
    );
  }
}
