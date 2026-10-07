import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:veer_gatha/widgets/app_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      if (mounted) {
        context.go("/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    double logoSize;
    double titleSize;
    double loaderSize;

    if (width < 600) {
      logoSize = width * 0.45;
      titleSize = 28;
      loaderSize = 45;
    } else if (width < 1024) {
      logoSize = width * 0.30;
      titleSize = 36;
      loaderSize = 55;
    } else {
      logoSize = 300;
      titleSize = 42;
      loaderSize = 65;
    }

    return Scaffold(
      body: AppBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: logoSize,
                height: logoSize,
                fit: BoxFit.contain,
              ),

              SizedBox(height: 20),

              Text(
                "Veer Gatha",
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),

              SizedBox(height: 25),

              SpinKitWave(
                size: loaderSize,
                itemBuilder: (context, index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.white, Colors.green],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
