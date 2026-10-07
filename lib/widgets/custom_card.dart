import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String text;
  final String stories;
  final Color cardColor;
  final Color borderColor;
  final String img;

  const CustomCard({
    super.key,
    required this.text,
    required this.stories,
    required this.cardColor,
    required this.borderColor,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 220,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(img),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 25,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'serif',
                    color: Color(0xFF101D2D),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 7),

            Text(
              stories,
              style: const TextStyle(fontSize: 14, color: Color(0xFF202020)),
            ),

            const Spacer(),

            Container(
              width: 29,
              height: 29,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: borderColor,
                border: Border.all(color: borderColor, width: 1),
              ),
              child: const Icon(
                Icons.arrow_forward,
                size: 17,
                color: Color(0xFF111111),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
