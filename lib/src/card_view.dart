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

class _CardViewState extends State<CardView> with TickerProviderStateMixin {
  late final AnimationController initialAnimationController;
  late final AnimationController cardAnimationController;
  late final AnimationController viewAnimationController;

  late final Animation<double> initialAnimation;
  late final Animation<double> cardTranslateAnimation;
  late final Animation<double> cardScaleUpAnimation;
  late final Animation<double> cardScaleDownAnimation;
  late final Animation<double> cardOpacityAnimation;
  late final Animation<double> viewChangeAnimation;

  final int maxCardLen = 3;
  int currentIndex = 0;

  late List<String> allImages;
  late List<String> viewImages;
  late List<String> cardImages;

  @override
  void initState() {
    setInitialData();
    setupAnimations();
    super.initState();
  }

  void setInitialData() {
    allImages = widget.images;
    viewImages = [allImages[0]];
    // image from index 1 of allImages
    cardImages = [...allImages]..removeAt(0);
  }

  void setupAnimations() {
    setupInitialAnimation();
    setupViewAnimation();
    setupCardAnimation();
    Future.microtask(() {
      initialAnimationController.forward();
      viewAnimationController.forward();
    });
  }

  void setupInitialAnimation() {
    initialAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    initialAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(
        parent: initialAnimationController,
        curve: Curves.decelerate,
      ),
    );
  }

  void setupViewAnimation() {
    viewAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    viewChangeAnimation = Tween<double>(begin: 0.4, end: 1).animate(
      CurvedAnimation(
        parent: viewAnimationController,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
      ),
    );
  }

  void setupCardAnimation() {
    cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    cardTranslateAnimation = Tween<double>(begin: 0, end: 50).animate(
      CurvedAnimation(
        parent: cardAnimationController,
        curve: const Interval(0, 0.4, curve: Curves.easeIn),
      ),
    );
    cardScaleUpAnimation = Tween<double>(begin: 1, end: 1.5).animate(
      CurvedAnimation(
        parent: cardAnimationController,
        curve: const Interval(0.45, 0.65, curve: Curves.bounceOut),
      ),
    );
    cardScaleDownAnimation = Tween<double>(begin: 0, end: 1.5).animate(
      CurvedAnimation(
        parent: cardAnimationController,
        curve: const Interval(0.7, 0.9, curve: Curves.bounceIn),
      ),
    );
    cardOpacityAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: cardAnimationController,
        curve: const Interval(0.8, 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: onSwipeGesture,
      child: Stack(
        children: [
          ...mainView(),
          Positioned(
            height: 200,
            width: 300,
            bottom: 0,
            right: 10,
            child: smallPreviewCard(),
          )
        ],
      ),
    );
  }

  void onSwipeGesture(details) async {
    final dx = details.primaryVelocity ?? 0;
    final leftSwipe = dx < 0;

    if (leftSwipe) {
      if (cardImages.isEmpty) return;
      await cardAnimationController.forward();
      final data = cardImages.removeAt(0);
      viewImages.add(data);
      currentIndex = currentIndex + 1;
      setState(() {});
      cardAnimationController.reset();
      viewAnimationController.reset();
      await viewAnimationController.forward();
    } else {
      if (viewImages.length == 1) {
        initialAnimationController.reset();
        initialAnimationController.forward();
        return;
      }
      await viewAnimationController.reverse();
      currentIndex = currentIndex - 1;
      viewAnimationController.forward(from: 1.0);
      final topViewIndex = viewImages.length - 1;
      final data = viewImages.removeAt(topViewIndex);
      cardImages.insert(0, data);
      setState(() {});
      cardAnimationController.forward(from: 1.0);
      await cardAnimationController.reverse();
      cardAnimationController.reset();
    }
  }

  List<Widget> mainView() {
    final bool moreItems = viewImages.length >= 2;
    final int initial = (moreItems ? viewImages.length - 2 : 0);
    List<Widget> widgets = [];
    for (int i = initial; i < viewImages.length; i++) {
      widgets.add(fullView(i));
    }
    return widgets;
  }

  Widget fullView(int index) {
    if (currentIndex == index) {
      final isLast = index == 0;
      return AnimatedBuilder(
        animation: viewChangeAnimation,
        builder: (context, child) {
          return Positioned.fill(
            child: Transform.scale(
              origin: const Offset(0, -50),
              alignment: isLast ? Alignment.center : Alignment.bottomCenter,
              scale: viewChangeAnimation.value,
              child: CachedNetworkImage(
                imageUrl: viewImages[index],
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          );
        },
      );
    }

    return Positioned.fill(
      child: CachedNetworkImage(
        imageUrl: viewImages[index],
        fit: BoxFit.cover,
      ),
    );
  }

  Widget smallPreviewCard() {
    final bool moreItems = cardImages.length >= maxCardLen;
    final int initial = (moreItems ? maxCardLen : cardImages.length) - 1;
    return AnimatedBuilder(
      animation: initialAnimationController,
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

    if (imageIndex == 0) {
      return AnimatedBuilder(
        animation: cardAnimationController,
        builder: (context, child) {
          final rightInitial = initialAnimation.value * pos;
          final scaleCard =
              cardScaleUpAnimation.value - cardScaleDownAnimation.value;

          return Positioned(
            right: rightInitial + cardTranslateAnimation.value,
            child: Opacity(
              opacity: cardOpacityAnimation.value,
              child: Transform.scale(
                scale: scaleCard,
                child: cardWidget(pos, imageIndex),
              ),
            ),
          );
        },
      );
    }

    return Positioned(
      right: initialAnimation.value * pos,
      child: cardWidget(pos, imageIndex),
    );
  }

  SizedBox cardWidget(int pos, int imageIndex) {
    return SizedBox(
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
    );
  }

  @override
  void dispose() {
    initialAnimationController.dispose();
    cardAnimationController.dispose();
    viewAnimationController.dispose();
    super.dispose();
  }
}
