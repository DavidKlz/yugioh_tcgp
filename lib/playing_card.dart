import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class PlayingCard extends StatefulWidget {
  const PlayingCard({super.key});

  @override
  State<PlayingCard> createState() => _PlayingCardState();
}

class _PlayingCardState extends State<PlayingCard>
    with TickerProviderStateMixin {
  final cap = 26.0;
  bool isFront = true;
  bool isDragEnabled = true;
  double dragPositionX = 0;
  double dragPositionY = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = (MediaQuery.of(context).size.shortestSide * 0.8) * 53 / 86;
    var angleX = dragPositionY / 180 * pi;
    var angleY = dragPositionX / 180 * pi;
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(angleX)
      ..rotateY(angleY);
    return Column(
      children: [
        Text("Y: $dragPositionY"),
        Text("X: $dragPositionX"),
        Draggable(
          feedback: const SizedBox(),
          onDragUpdate: (details) => setState(() {
            if (isDragEnabled) {
              if (details.delta.dx > 15) {
                flipCard();
              } else {
                dragPositionY += details.delta.dy;
                dragPositionY %= 360;
                if (dragPositionY > cap && dragPositionY < 180) {
                  dragPositionY = cap;
                } else if (dragPositionY < 360 - cap && dragPositionY > 180) {
                  dragPositionY = 360 - cap;
                }
                dragPositionX -= details.delta.dx;
                dragPositionX %= 360;
                if (dragPositionX > cap && dragPositionX < 180) {
                  dragPositionX = cap;
                } else if (dragPositionX < 360 - cap && dragPositionX > 180) {
                  dragPositionX = 360 - cap;
                }
              }
            }
          }),
          child: Transform(
            transform: transform,
            alignment: Alignment.center,
            child: SizedBox(
                width: width,
                height: width * (86 / 53),
                child: isFront ? Image.network("https://images.ygoprodeck.com/images/cards/23995346.jpg") : Image.asset("assets/cardback.png")),
          ),
        ),
      ],
    );
  }

  void pauseAnimation() {
    setState(() => isDragEnabled = false);
    Timer(const Duration(milliseconds: 150),
        () => setState(() => isDragEnabled = true));
  }

  void flipCard() {
    pauseAnimation();
    setState(() {
      isFront = !isFront;
      dragPositionY = 0;
      dragPositionX = 0;
    });
  }
}
