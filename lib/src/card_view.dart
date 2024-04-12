import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardView extends StatefulWidget {
  const CardView({super.key, required this.images})
      : assert(
          images.length >= 2,
          "images list length must be greater than 2",
        );
  final List<String> images;

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> initialAnimation;

  final int maxCardLen = 3;
  int currentIndex = 0;

  late List<String> allImages;
  late List<String> viewImages;
  late List<String> cardImages;

  @override
  void initState() {
    setInitialData();
    setupAnimation();
    super.initState();
  }

  void setInitialData() {
    allImages = widget.images;
    viewImages = [allImages[0]];
    cardImages = [...allImages]..removeAt(0);
    // cardImages = cardImages.reversed.toList();
  }

  void setupAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    initialAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: animationController, curve: Curves.decelerate),
    );
    Future.microtask(() => animationController.forward());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final dx = details.primaryVelocity ?? 0;
        final leftSwipe = dx < 0;

        if (leftSwipe) {
          if (cardImages.isEmpty) return;
          final data = cardImages.removeAt(0);
          viewImages.add(data);
          currentIndex = currentIndex + 1;
        } else {
          if (viewImages.length == 1) return;
          final data = viewImages.removeAt(currentIndex);
          cardImages.insert(0, data);
          currentIndex = currentIndex - 1;
        }
        setState(() {});
        animationController.forward();
      },
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: viewImages[currentIndex],
              ),
            ),
            Positioned(
              height: 200,
              width: 300,
              bottom: 0,
              right: 0,
              child: smallPreviewCard(),
            )
          ],
        ),
      ),
    );
  }

  Widget smallPreviewCard() {
    final bool moreItems = cardImages.length >= maxCardLen;
    final int initial = (moreItems ? maxCardLen : cardImages.length) - 1;
    return AnimatedBuilder(
      animation: initialAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            for (int i = initial; i >= 0; i--) miniCard(imageIndex: i),
          ],
        );
      },
    );
  }

  Widget miniCard({required int imageIndex}) {
    final pos = maxCardLen - imageIndex;
    return Positioned(
      right: initialAnimation.value * pos,
      child: SizedBox(
        height: 100.0 + 20 * pos,
        width: 105,
        child: Card(
          elevation: 5.0 * pos,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.hardEdge,
          child: CachedNetworkImage(
            imageUrl: cardImages[imageIndex],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
