import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

//Spinning wheel sections
class SpinItem {
  String label;
  TextStyle labelStyle;
  TextStyle? subLabel1Style;
  TextStyle? subLabel2Style;
  TextStyle? subLabel3Style;
  Color color;

  SpinItem(
      {required this.label,
      required this.color,
      required this.labelStyle,
      this.subLabel1Style,
      this.subLabel2Style,
      this.subLabel3Style});
}

//Spinning control
class MySpinner extends StatefulWidget {
  final MySpinController mySpinController;
  final List<SpinItem> itemList;
  final double wheelSize;
  final Function(void) onFinished;

  const MySpinner({
    super.key,
    required this.mySpinController,
    required this.onFinished,
    required this.itemList,
    required this.wheelSize,
  });

  @override
  State<MySpinner> createState() => _MySpinnerState();
}

//Controllers: spinning, confetti
class _MySpinnerState extends State<MySpinner> with TickerProviderStateMixin {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    widget.mySpinController.initLoad(
      tickerProvider: this,
      itemList: widget.itemList,
    );
    widget.mySpinController.onFinished = (result) {
      widget.onFinished(result);
      _confettiController.play();
    };
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    widget.mySpinController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          alignment: Alignment.center,
          child: AnimatedBuilder(
            animation: widget.mySpinController._baseAnimation,
            builder: (context, child) {
              double value = widget.mySpinController._baseAnimation.value;
              double rotationValue = (360 * value);
              return RotationTransition(
                turns: AlwaysStoppedAnimation(rotationValue / 360),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RotatedBox(
                      quarterTurns: 3,
                      child: Container(
                        width: widget.wheelSize,
                        height: widget.wheelSize,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 232, 203, 156),
                            shape: BoxShape.circle),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 0, 0, 0),
                              shape: BoxShape.circle),
                          padding: const EdgeInsets.all(5),
                          child: CustomPaint(
                            painter: SpinWheelPainter(items: widget.itemList),
                          ),
                        ),
                      ),
                    ),
                    ...widget.itemList.asMap().entries.map((entry) {
                      int index = entry.key;
                      SpinItem item = entry.value;
                      double rotateInterval = 360 / widget.itemList.length;
                      double rotateAmount = (index + 0.5) * rotateInterval;

                      List<TextSpan> textSpans = [];
                      List<String> parts = item.label.split('\n');
                      for (int i = 0; i < parts.length; i++) {
                        TextStyle style;
                        switch (i) {
                          case 0:
                            style = item.subLabel1Style ?? item.labelStyle;
                            break;
                          case 1:
                            style = item.subLabel2Style ?? item.labelStyle;
                            break;
                          case 2:
                            style = item.subLabel3Style ?? item.labelStyle;
                            break;
                          default:
                            style = item.labelStyle;
                            break;
                        }
                        textSpans.add(TextSpan(
                          text: parts[i] + (i < parts.length - 1 ? '\n' : ''),
                          style: style.copyWith(height: 1.1),
                        ));
                      }
                      return RotationTransition(
                        turns: AlwaysStoppedAnimation(rotateAmount / 360),
                        child: Transform.translate(
                          offset: Offset(0, -widget.wheelSize / 4),
                          child: RotatedBox(
                            quarterTurns: 4,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: textSpans,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            alignment: Alignment.topCenter,
            child: const Icon(
              Icons.signal_wifi_4_bar,
              size: 50,
              color: Color.fromARGB(255, 228, 182, 109),
            ),
          ),
        ),
        Center(
          child: GestureDetector(
            onTap: () {
              widget.mySpinController.spin();
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 244, 227, 190),
                  shape: BoxShape.circle),
              padding: const EdgeInsets.all(3),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 212, 141, 82)
                          .withOpacity(0.5),
                      spreadRadius: 8,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Spin',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Color.fromARGB(255, 234, 117, 54),
              Color.fromARGB(255, 252, 162, 60),
              Color.fromARGB(255, 183, 136, 61),
              Color.fromARGB(255, 179, 105, 1)
            ],
          ),
        ),
      ],
    );
  }
}

class SpinWheelPainter extends CustomPainter {
  final List<SpinItem> items;

  SpinWheelPainter({required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final paint = Paint()..style = PaintingStyle.fill;

    final totalSections = items.length;
    const totalAngle = 2 * math.pi;
    final sectionAngleWithSpace = totalAngle / totalSections;

    for (var i = 0; i < items.length; i++) {
      final startAngle = i * sectionAngleWithSpace;

      paint.color = items[i].color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sectionAngleWithSpace,
        true,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MySpinController {
  late AnimationController _animationController;
  late Animation<double> _baseAnimation;
  late List<SpinItem> _itemList;
  bool _isSpinning = false;
  //int _selectedItem = -1;
  double _currentRotation = 0;
  late TickerProvider _tickerProvider;

  void initLoad({
    required TickerProvider tickerProvider,
    required List<SpinItem> itemList,
  }) {
    _tickerProvider = tickerProvider;
    _itemList = itemList;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: _tickerProvider,
    );

    _baseAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed && _isSpinning) {
              _animationController
                  .repeat(); // Keep spinning if the wheel is spinning
            }
          });
  }

  void spin() {
    if (_isSpinning) return;

    _isSpinning = true;
    _animationController.stop();
    _animationController.reset();
    _animationController.duration = const Duration(milliseconds: 300);
    _animationController.repeat();
  }

  void stop() {
    if (!_isSpinning) return;

    _animationController.stop();
    _isSpinning = false;
    _slowDown(); // Start the slowdown process
  }

  void _slowDown() {
    final random = math.Random();
    double targetRotation =
        _currentRotation + (random.nextDouble() * 2 * math.pi);

    _animationController.stop();
    _animationController.duration = const Duration(milliseconds: 1000);
    _baseAnimation = Tween<double>(begin: _currentRotation, end: targetRotation)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _currentRotation = targetRotation;
          _animationController.stop();
          onFinished?.call(_getSelectedIndex());
        }
      });

    _animationController.forward(from: 0);
  }

  int _getSelectedIndex() {
    int index = (_currentRotation / (2 * math.pi) * _itemList.length).floor() %
        _itemList.length;
    return index;
  }

  void Function(int)? onFinished;

  void dispose() {
    _animationController.dispose();
  }
}
