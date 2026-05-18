import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:from_css_color/from_css_color.dart';
import 'package:parking_app/views/welcome_page.dart';

class BoardingPage extends StatefulWidget {
  const BoardingPage({super.key});

  @override
  State<BoardingPage> createState() => _BoardingPageState();
}

class _BoardingPageState extends State<BoardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 55),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Lottie.asset(
                'assets/lottie/boardcar.json',
                fit: BoxFit.contain,
              ),
            ),

            Text(
              "Welcome to Park-In!",
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: fromCssColor("#070625"),
              ),
            ),
            

            const SizedBox(height: 20),

            Text(
              "Easy Parking at Your Fingertips",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: fromCssColor("#A3A3A3"),
              ),
            ),

            Text(
              "Book your parking spot anytime, anywhere.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: fromCssColor("#A3A3A3"),
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(350, 50),
                backgroundColor: fromCssColor("#3D6AFF"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                "Next",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: .bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}