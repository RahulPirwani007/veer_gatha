import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veer_gatha/main.dart';
import 'package:veer_gatha/widgets/app_background.dart';

class ComingSoonScreen extends StatelessWidget {
  final String title;

  const ComingSoonScreen({super.key, this.title = ''});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.hourglass_top_rounded,
                size: 80,
                color: AppColors.brown,
              ),
              const SizedBox(height: 16),
              Text(
                'Coming Soon',
                textAlign: TextAlign.center,
                style: GoogleFonts.arimo(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              if (title.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.arimo(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brown,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Text(
                'We are working on this section.\nStay tuned!',
                textAlign: TextAlign.center,
                style: GoogleFonts.arimo(fontSize: 15, color: AppColors.navy),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brown,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
