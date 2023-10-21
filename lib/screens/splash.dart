// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shoppy/screens/home.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatefulWidget {
  
  // ignore: use_key_in_widget_constructors
  const Loading({Key? key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animation1.json',
              height: screenHeight * 0.6, 
            ),
          ],
        ),
      ),
    );
  }
}
