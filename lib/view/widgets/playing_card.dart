import 'dart:async';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vector_math/vector_math.dart' as vm;

import 'package:flutter/material.dart';

import '../../logic/data/card_info.dart';

class PlayingCard extends StatefulWidget {
  final CardInfo card;

  const PlayingCard({required this.card, super.key});

  @override
  State<PlayingCard> createState() => _PlayingCardState();
}

class _PlayingCardState extends State<PlayingCard>
    with TickerProviderStateMixin {
  final cap = 26.0;

  late AnimationController controller;
  late Animation<vm.Vector2> animation;

  bool flippedRight = false;
  bool isFront = true;
  bool shouldFlipCard = false;
  bool tryToFlipOnlyOnce = true;
  double dragPositionX = 0;
  double dragPositionY = 0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    controller.addListener(
      () {
        setState(() {
          dragPositionX = animation.value.x;
          dragPositionY = animation.value.y;
        });
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var angleX = dragPositionY / 180 * math.pi;
    var angleY = dragPositionX / 180 * math.pi;
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(angleX)
      ..rotateY(angleY);
    return Draggable(
      feedback: const SizedBox(),
      onDragUpdate: _onDragUpdate,
      onDragEnd: (details) => _onDragFinished(),
      onDragCompleted: _onDragFinished,
      child: Transform(
        transform: transform,
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.shortestSide * 0.5,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 4,
              ),
            ],
          ),
          child: isFront
              ? CachedNetworkImage(
                  imageUrl: widget.card.imageUrl,
                  placeholder: (context, url) => Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset("assets/cardback.png"),
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              : Image.asset("assets/cardback.png"),
        ),
      ),
    );
  }

  void _flipCardTimer() {
    if (!shouldFlipCard) {
      shouldFlipCard = true;
      Timer(const Duration(milliseconds: 50), () => shouldFlipCard = false);
    }
  }

  void _doFlipCard() {
    setState(() {
      dragPositionX = flippedRight ? 360 - cap : cap;
      isFront = !isFront;
    });
  }

  void _onDragFinished() {
    if (shouldFlipCard) {
      _doFlipCard();
    }

    animation = Tween<vm.Vector2>(
      begin: vm.Vector2(dragPositionX, dragPositionY),
      end: vm.Vector2(
          dragPositionX > 180 ? 360 : 0, dragPositionY > 180 ? 360 : 0),
    ).animate(controller);

    controller.forward(from: 0);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (details.delta.dx > 7 || details.delta.dx < -7) {
      flippedRight = details.delta.dx > 7;
      _flipCardTimer();
    } else {
      dragPositionY += details.delta.dy;
      dragPositionY %= 360;
      dragPositionX -= details.delta.dx;
      dragPositionX %= 360;
      setState(() {
        if (dragPositionY > cap && dragPositionY < 180) {
          dragPositionY = cap;
        } else if (dragPositionY < 360 - cap && dragPositionY > 180) {
          dragPositionY = 360 - cap;
        }
        if (dragPositionX > cap && dragPositionX < 180) {
          dragPositionX = cap;
        } else if (dragPositionX < 360 - cap && dragPositionX > 180) {
          dragPositionX = 360 - cap;
        }
      });
    }
  }
}
