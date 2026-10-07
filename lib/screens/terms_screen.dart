import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veer_gatha/main.dart';
import 'package:veer_gatha/widgets/app_background.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms & Conditions',
              style: GoogleFonts.arimo(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Please read these terms carefully before using the app.',
              style: GoogleFonts.arimo(fontSize: 15, color: AppColors.navy),
            ),

            const SizedBox(height: 20),

            _buildSection(
              '1. Introduction',
              'Welcome to VEER GATHA. This app is created for '
                  'educational and informational purposes to share '
                  'the history, stories and achievements of great '
                  'personalities of India.',
            ),

            _buildSection(
              '2. Educational Purpose',
              'VEER GATHA is an educational project developed '
                  'to help users learn about Indian history, '
                  'historical events and inspiring personalities. '
                  'The content is intended for general knowledge '
                  'and learning purposes only.',
            ),

            _buildSection(
              '3. Historical Information',
              'We aim to provide accurate and meaningful '
                  'historical information. However, some historical '
                  'events and accounts may differ across sources. '
                  'Users are encouraged to refer to reliable books, '
                  'historical records and other trusted sources '
                  'for further research.',
            ),

            _buildSection(
              '4. Content and Images',
              'The app may contain text, stories, illustrations '
                  'and images related to historical personalities. '
                  'Some content or images may be sourced from '
                  'publicly available materials. All respective '
                  'copyrights and ownership rights belong to '
                  'their original owners.',
            ),

            _buildSection(
              '5. User Responsibilities',
              'Users are expected to use this app respectfully '
                  'and only for lawful purposes. Users must not '
                  'attempt to misuse the app, disrupt its services '
                  'or use its content in a misleading or harmful way.',
            ),

            _buildSection(
              '6. Intellectual Property',
              'The app name, original design, interface and '
                  'original content created for VEER GATHA are '
                  'protected by applicable intellectual property '
                  'laws. Users should not copy, reproduce or '
                  'redistribute original content without '
                  'appropriate permission.',
            ),

            _buildSection(
              '7. Data and Privacy',
              'We respect user privacy. Any personal information '
                  'collected through the app will be handled in '
                  'accordance with our Privacy Policy. Users should '
                  'review the Privacy Policy to understand how '
                  'their information is collected, used and protected.',
            ),

            _buildSection(
              '8. App Availability',
              'We aim to keep the app accessible and functional. '
                  'However, we do not guarantee uninterrupted '
                  'availability. The app may be updated, modified '
                  'or temporarily unavailable due to maintenance '
                  'or technical issues.',
            ),

            _buildSection(
              '9. Limitation of Liability',
              'VEER GATHA is provided for educational purposes. '
                  'We are not responsible for any loss or damage '
                  'arising from the use of the app or reliance on '
                  'its content, to the extent permitted by applicable law.',
            ),

            _buildSection(
              '10. Third-Party Services',
              'The app may use third-party services such as '
                  'Firebase for authentication, data storage or '
                  'other app features. These services may have '
                  'their own terms and privacy policies, which '
                  'users should review where applicable.',
            ),

            _buildSection(
              '11. Changes to Terms',
              'We reserve the right to update or modify these '
                  'Terms & Conditions whenever necessary. Any '
                  'changes will be reflected in the app. Continued '
                  'use of the app after changes are made indicates '
                  'acceptance of the updated terms, where applicable.',
            ),

            _buildSection(
              '12. Contact Us',
              'If you have any questions, suggestions or concerns '
                  'regarding these Terms & Conditions, you can contact '
                  'the developer of VEER GATHA at '
                  'rahulpirwani2000@gmail.com. We welcome your valuable '
                  'feedback and suggestions to help improve the app.',
            ),
            _buildSection(
              '13. Content Sources',
              'The historical information, stories and images used '
                  'in VEER GATHA are collected from sources such as '
                  'Wikipedia and other publicly available references. '
                  'The content is not AI-generated. We aim to present '
                  'historical information for educational purposes. '
                  'All respective content rights and copyrights belong '
                  'to their original owners. If you find any incorrect '
                  'information or copyright concerns, please contact '
                  'the developer.',
            ),

            _buildSection(
              '14. Apology and User Feedback',
              'If you face any problems, errors or inconvenience '
                  'while using VEER GATHA, I sincerely apologize for '
                  'your experience. As a single developer, I am always '
                  'trying to improve this app and provide a better '
                  'learning experience. Your feedback, suggestions '
                  'and support are truly valuable to me. If you have '
                  'any issues or suggestions, please feel free to '
                  'contact me at rahulpirwani2000@gmail.com. '
                  'Thank you for your patience and understanding.',
            ),

            const SizedBox(height: 10),

            Center(
              child: Text(
                'Thank you for using VEER GATHA',
                textAlign: TextAlign.center,
                style: GoogleFonts.arimo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String description) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.arimo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            description,
            style: GoogleFonts.arimo(
              fontSize: 15,
              height: 1.6,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}
