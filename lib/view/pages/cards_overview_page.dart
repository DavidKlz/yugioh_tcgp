import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yugioh_tcgp/logic/provider/card_provider.dart';

import '../../config/routing/routes.dart';

class CardsOverviewPage extends ConsumerStatefulWidget {
  const CardsOverviewPage({super.key});

  @override
  ConsumerState createState() => _CardsOverviewPageState();
}

class _CardsOverviewPageState extends ConsumerState<CardsOverviewPage> {
  late ScrollController controller;
  late Timer fuzzySearch = Timer(const Duration(milliseconds: 0), () {});

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: controller,
          child: Center(
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    if (fuzzySearch.isActive) {
                      fuzzySearch.cancel();
                    }
                    fuzzySearch = Timer(
                        const Duration(milliseconds: 200),
                        () => ref
                            .read(cardServiceProvider.notifier)
                            .searchName(value));
                  },
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ref
                      .watch(cardServiceProvider)
                      .map(
                        (e) => GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamed(Routes.detail, arguments: e),
                          child: SizedBox(
                            width: 268,
                            height: 391,
                            child: Hero(
                              tag: e.id,
                              child: CachedNetworkImage(
                                imageUrl: e.thumbUrl,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                placeholder: (context, url) =>
                                    Image.asset("assets/cardback.png"),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 500) {
      ref.read(cardServiceProvider.notifier).loadNext();
    }
  }
}
