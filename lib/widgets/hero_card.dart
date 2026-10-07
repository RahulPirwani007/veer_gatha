import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veer_gatha/main.dart';

class HeroCard extends StatelessWidget {
  final String imgUrl;
  final String region;
  final String name;
  final String hindiName;
  final String quote;

  const HeroCard({
    super.key,
    required this.imgUrl,
    required this.region,
    required this.name,
    required this.hindiName,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 140,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: imgUrl.isNotEmpty
                    ? Image.network(
                        imgUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _imagePlaceholder();
                        },
                      )
                    : _imagePlaceholder(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.brown,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          region,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    name,
                    style: GoogleFonts.arimo(
                      color: AppColors.darkNavy,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (hindiName.isNotEmpty)
                    Text(
                      hindiName,
                      style: GoogleFonts.arimo(
                        color: AppColors.brown,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (quote.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      '\u201c$quote\u201d',
                      style: GoogleFonts.arimo(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        color: AppColors.navy,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  _watchStoryButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }

  Widget _watchStoryButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE7A83B),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: AppColors.navy,
            child: Icon(Icons.play_arrow, size: 14, color: Colors.white),
          ),
          SizedBox(width: 8),
          Text(
            'Watch Story',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
          SizedBox(width: 6),
          Icon(Icons.chevron_right, size: 18, color: AppColors.navy),
        ],
      ),
    );
  }
}
