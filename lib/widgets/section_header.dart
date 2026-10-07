import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veer_gatha/main.dart';

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.sand,
          child: Icon(icon, size: 16, color: AppColors.brown),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.arimo(
            color: const Color.fromRGBO(0, 14, 42, 1),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
