import 'package:booker/screen/on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              OnBoarding(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fadeAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            final slideAnimation = Tween<Offset>(
              begin: Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(position: slideAnimation, child: child),
            );
          },
          transitionDuration: Duration(milliseconds: 800),
        ),
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logo.png', width: 80, height: 105),
            SizedBox(height: 4),
            Container(
              width: 52,
              height: 9,
              decoration: BoxDecoration(
                color: Color.fromRGBO(127, 86, 217, 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            SizedBox(height: 20),

            Text(
              "BOOKER",
              style: GoogleFonts.lemon(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.16,
                color: const Color(0xFF000000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
