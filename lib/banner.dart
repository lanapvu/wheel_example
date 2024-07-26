import 'package:flutter/material.dart';
// import 'dart:math';

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
      duration: const Duration(seconds: 1),
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
                text: "Get immediate AU\$100",
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
        SlidingParts(controller: controller),
        CenterText(controller: controller, text: text, subText: subText),
        RunningLines(controller: controller),
        Stars(controller: controller),
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
        curve: const Interval(0.0, 0.2, curve: Curves.easeInOut)));

    final slideAnimationRight = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeInOut)));

    final expandAnimation = Tween<double>(
      begin: 10.0,
      end: 100.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut)));

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
                  color: const Color.fromARGB(255, 246, 229, 178),
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
                  color: const Color.fromARGB(255, 246, 229, 178),
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
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated Main Text
        AnimatedBuilder(
          animation: textAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.5 - 0.5 * textAnimation.value, // From large to small
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: textAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.3 - 0.3 * textAnimation.value, // From large to small
              child: Center(
                child: Text(
                  subText,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.brown,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class RunningLines extends StatelessWidget {
  final AnimationController controller;
  const RunningLines({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final repeatedAnimation = CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeInOut));

    final repeatedAnimation2 = CurvedAnimation(
        parent: controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeInOut));

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          children: [
            Align(
              alignment: const Alignment(0.0, 0.12),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 10,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: const Offset(-1.0, 0.0),
                  ).animate(repeatedAnimation),
                  child: Container(
                    height: 2,
                    color: const Color.fromARGB(255, 206, 192, 149),
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.0, 0.12),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 10,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: const Offset(-1.0, 0.0),
                  ).animate(repeatedAnimation2),
                  child: Container(
                    height: 2,
                    color: const Color.fromARGB(255, 206, 192, 149),
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.0, -0.12),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 10,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: const Offset(1.0, 0.0),
                  ).animate(repeatedAnimation),
                  child: Container(
                    height: 2,
                    color: const Color.fromARGB(255, 206, 192, 149),
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.0, -0.12),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 10,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: const Offset(1.0, 0.0),
                  ).animate(repeatedAnimation2),
                  child: Container(
                    height: 2,
                    color: const Color.fromARGB(255, 206, 192, 149),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
class Stars extends StatelessWidget {
  final AnimationController controller;
  const Stars({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Define the repeated animation for both sets of stars
    final repeatedAnimation1 = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
    );

    final repeatedAnimation2 = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    );

    // Define the fade-out animation for the first set of stars
    final fadeOutAnimation1 = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.45, 0.5, curve: Curves.easeOut),
    ));

    // Define the fade-in animation for the second set of stars
    final fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 0.55, curve: Curves.easeIn),
    ));

    // Define the fade-out animation for the second set of stars
    final fadeOutAnimation2 = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.95, 1.0, curve: Curves.easeOut),
    ));

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          children: [
            // First set of stars animating diagonally to the top-right and bottom-right
            Transform.translate(
              offset: Offset(
                100 * repeatedAnimation1.value,
                -100 * repeatedAnimation1.value,
              ),
              child: Align(
                alignment: const Alignment(0.0, -0.08),
                child: FadeTransition(
                  opacity: fadeOutAnimation1,
                  child: const Icon(
                    Icons.star,
                    color: Color.fromARGB(255, 206, 192, 149),
                    size: 40.0,
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(
                100 * repeatedAnimation1.value,
                100 * repeatedAnimation1.value,
              ),
              child: Align(
                alignment: const Alignment(0.0, 0.08),
                child: FadeTransition(
                  opacity: fadeOutAnimation1,
                  child: const Icon(
                    Icons.star,
                    color: Color.fromARGB(255, 206, 192, 149),
                    size: 40.0,
                  ),
                ),
              ),
            ),
            // Second set of stars animating diagonally to the top-right and bottom-right
            Transform.translate(
              offset: Offset(
                100 * repeatedAnimation2.value,
                -100 * repeatedAnimation2.value,
              ),
              child: Align(
                alignment: const Alignment(0.0, -0.08),
                child: FadeTransition(
                  opacity: fadeOutAnimation2,
                  child: FadeTransition(
                    opacity: fadeInAnimation,
                    child: const Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 206, 192, 149),
                      size: 40.0,
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(
                100 * repeatedAnimation2.value,
                100 * repeatedAnimation2.value,
              ),
              child: Align(
                alignment: const Alignment(0.0, 0.08),
                child: FadeTransition(
                  opacity: fadeOutAnimation2,
                  child: FadeTransition(
                    opacity: fadeInAnimation,
                    child: const Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 206, 192, 149),
                      size: 40.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
