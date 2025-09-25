import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  final int duration;

  const SplashScreen({required this.nextScreen, this.duration = 3, super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: widget.duration), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => widget.nextScreen),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Builder(
                builder: (_) {
                  try {
                    return SvgPicture.asset(
                      'assets/images/logo.svg',
                      height: 150,
                    );
                  } catch (e) {
                    return const Icon(
                      Icons.note,
                      size: 100,
                      color: Colors.white,
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              Builder(
                builder: (_) {
                  try {
                    return Lottie.asset(
                      'assets/animations/loading.json',
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    );
                  } catch (e) {
                    return const CircularProgressIndicator(
                      color: Colors.white,
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome to NoteTodo App",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
