import 'dart:async';
import 'package:flutter/material.dart';
import '/my_spinning_wheel.dart';
import '/banner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SpinningWheelPage(),
    );
  }
}

class SpinningWheelPage extends StatefulWidget {
  const SpinningWheelPage({super.key});

  @override
  SpinningWheelPageState createState() => SpinningWheelPageState();
}

class SpinningWheelPageState extends State<SpinningWheelPage> {
  StreamController<int> selected = StreamController<int>();
  MySpinController mySpinController = MySpinController();
  String buttonText = 'Stop';
  bool secondSpin = false;
  int spinCount = 0;

  //final GlobalKey<_MySpinnerState> _spinnerKey = GlobalKey<_MySpinnerState>();

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  void handleSpinFinish(BuildContext context) {
    spinCount++;
    if (spinCount >= 2) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AnimatedBanner()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 128, 134, 149),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(4.0),
              child: const Text(
                'Spin to win AU\$100',
                style: TextStyle(
                    color: Color.fromARGB(255, 246, 229, 178),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              )),
          Container(
            padding: const EdgeInsets.only(bottom: 20.0),
            alignment: Alignment.center,
            child: const Text('Coupon bundle',
                style: TextStyle(
                    color: Color.fromARGB(255, 246, 229, 178), fontSize: 16)),
          ),
          MySpinner(
            mySpinController: mySpinController,
            wheelSize: 350,
            itemList: [
              SpinItem(
                  label: '1 more\n chance',
                  labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 78, 51, 26),
                      fontWeight: FontWeight.bold),
                  subLabel1Style: const TextStyle(
                      fontSize: 32.0,
                      color: Color.fromARGB(255, 78, 51, 26),
                      fontWeight: FontWeight.bold),
                  subLabel2Style: const TextStyle(
                      fontSize: 24.0,
                      color: Color.fromARGB(255, 78, 51, 26),
                      fontWeight: FontWeight.bold),
                  color: const Color.fromARGB(255, 236, 214, 184)),
              SpinItem(
                  label: 'Jackpot\n AU\$100\n Coupons',
                  labelStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  subLabel1Style: const TextStyle(
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 239, 209, 162),
                      fontWeight: FontWeight.bold),
                  subLabel2Style: const TextStyle(
                      fontSize: 32.0,
                      color: Color.fromARGB(255, 239, 209, 162),
                      fontWeight: FontWeight.bold),
                  subLabel3Style: const TextStyle(
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 239, 209, 162),
                      fontWeight: FontWeight.bold),
                  color: const Color.fromARGB(255, 206, 109, 40)),
              SpinItem(
                  label: 'AU\$10\n Coupons',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 78, 51, 26),
                    fontWeight: FontWeight.bold,
                  ),
                  subLabel1Style: const TextStyle(
                      fontSize: 32.0,
                      color: Color.fromARGB(255, 78, 51, 26),
                      fontWeight: FontWeight.bold),
                  subLabel2Style: const TextStyle(
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 78, 51, 26),
                      fontWeight: FontWeight.bold),
                  color: const Color.fromARGB(255, 236, 214, 184)),
              SpinItem(
                  label: 'AU\$25\n Coupons',
                  labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 78, 51, 26),
                      fontWeight: FontWeight.bold),
                  subLabel1Style: const TextStyle(
                      fontSize: 32.0,
                      color: Color.fromARGB(255, 78, 51, 26),
                      fontWeight: FontWeight.bold),
                  subLabel2Style: const TextStyle(
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 78, 51, 26),
                      fontWeight: FontWeight.bold),
                  color: const Color.fromARGB(255, 225, 192, 124)),
            ],
            onFinished: (result) async {
              setState(() {
                if (secondSpin) {
                  buttonText = '';
                  handleSpinFinish(context);
                } else {
                  buttonText = 'Try your last chance';
                  secondSpin = true;
                }
              });
            },
          ),
          const SizedBox(height: 30),
          if (buttonText.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 244, 227, 190),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.all(0.5),
              child: ElevatedButton(
                onPressed: () {
                  if (buttonText == 'Stop') {
                    mySpinController.stop();
                  } else {
                    mySpinController.spin();
                    setState(() {
                      buttonText = 'Stop';
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 236, 130, 64),
                  minimumSize: const Size(270, 45),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
        ],
      ), 
    );
  }
}
