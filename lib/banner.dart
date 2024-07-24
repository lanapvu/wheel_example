import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedBanner extends StatefulWidget {
  const AnimatedBanner({super.key});

  @override
  _AnimatedBannerState createState() => _AnimatedBannerState();
}

class _AnimatedBannerState extends State<AnimatedBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool showSecondBanner = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showSecondBanner = true;
        _controller.reset();
        _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 128, 134, 149),
      body: Center(
        child: Stack(
          children: [
            if (!showSecondBanner)
              BannerContent(
                controller: _controller,
                text: "Pick 1st item to get AU\$100",
                subText: "Reward issued after checkout",
              )
            else
              BannerContent(
                controller: _controller,
                text: "Limited time bonus",
                subText: "Reward upgrade!",
              ),
          ],
        ),
      ),
    );
  }
}

class BannerContent extends StatelessWidget {
  final AnimationController controller;
  final String text;
  final String subText;

  const BannerContent({
    super.key,
    required this.controller,
    required this.text,
    required this.subText,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Sliding Parts
        SlidingParts(controller: controller),
        // Text in the Center
        CenterText(controller: controller, text: text, subText: subText),
        // Sparkling Stars
        SparklingStars(controller: controller),
      ],
    );
  }
}

class SlidingParts extends StatelessWidget {
  final AnimationController controller;
  const SlidingParts({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final slideAnimationLeft = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut)));

    final slideAnimationRight = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut)));

    final expandAnimation = Tween<double>(
      begin: 10.0,
      end: 100.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut)));

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          children: [
            SlideTransition(
              position: slideAnimationLeft,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: expandAnimation.value,
                  margin: const EdgeInsets.only(top: 20),
                  color: Color.fromARGB(255, 246, 229, 178),
                ),
              ),
            ),
            SlideTransition(
              position: slideAnimationRight,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: expandAnimation.value,
                  margin: const EdgeInsets.only(bottom: 20),
                  color: Color.fromARGB(255, 246, 229, 178),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CenterText extends StatelessWidget {
  final AnimationController controller;
  final String text;
  final String subText;

  const CenterText({
    super.key,
    required this.controller,
    required this.text,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    final textAnimation = CurvedAnimation(
        parent: controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut));

    return FadeTransition(
      opacity: textAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 29.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown),
            ),
          ),
          Center(
            child: Text(subText,
                style: const TextStyle(fontSize: 16.0, color: Colors.brown)),
          ),
        ],
      ),
    );
  }
}

class SparklingStars extends StatelessWidget {
  final AnimationController controller;
  const SparklingStars({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final starAnimation = CurvedAnimation(
        parent: controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut));

    return Stack(
      children: List.generate(20, (index) {
        return AnimatedStar(controller: starAnimation, index: index);
      }),
    );
  }
}

class AnimatedStar extends StatelessWidget {
  final Animation<double> controller;
  final int index;
  const AnimatedStar(
      {super.key, required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final starSize = random.nextDouble() * 5 + 5;
    final positionLeft =
        MediaQuery.of(context).size.width / 2 + random.nextDouble() * 50 - 25;
    final positionTop =
        MediaQuery.of(context).size.height / 2 + random.nextDouble() * 50 - 25;

    return Positioned(
      left: positionLeft,
      top: positionTop,
      child: FadeTransition(
        opacity: controller,
        child: Icon(
          Icons.star,
          color: const Color.fromARGB(255, 221, 194, 45),
          size: starSize,
        ),
      ),
    );
  }
}