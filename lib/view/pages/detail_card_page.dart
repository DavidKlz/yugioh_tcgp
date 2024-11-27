import 'package:flutter/material.dart';
import 'package:yugioh_tcgp/view/widgets/playing_card.dart';

import '../../logic/data/card_info.dart';

class DetailCardPage extends StatelessWidget {
  final CardInfo card;

  const DetailCardPage({required this.card, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back)),
            Center(child: Hero(tag: card.id, child: PlayingCard(card: card))),
          ],
        ),
      ),
    );
  }
}
