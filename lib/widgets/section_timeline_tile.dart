import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veer_gatha/main.dart';

class SectionTimelineTile extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final bool isDone;
  final bool isCurrent;
  final VoidCallback onTap;

  const SectionTimelineTile({
    super.key,
    required this.number,
    required this.title,
    required this.description,
    required this.isDone,
    required this.isCurrent,
    required this.onTap,
  });

  static const Color navy = AppColors.navy;
  static const Color gold = AppColors.gold;
  static const Color darkGold = Color(0xFFB8891C);
  static const Color cream = Color(0xFFFFF8EA);

  static const double circleSize = 46;
  static const double gap = 12; 
  @override
  Widget build(BuildContext context) {
    final Color circleColor = isDone
        ? gold
        : isCurrent
        ? darkGold
        : cream;

    return Padding(
      padding: const EdgeInsets.only(left: circleSize + gap - 2, bottom: 12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -(circleSize / 2) - gap - 1,
            top: -12,
            bottom: -12,
            child: Container(
              width: 2,
              color: gold.withValues(alpha: isDone ? 1 : 0.6),
            ),
          ),

          Positioned(
            left: -(circleSize + gap),
            top: 8,
            child: Container(
              width: circleSize,
              height: circleSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
                border: Border.all(color: gold, width: 2),
              ),
              child: isDone
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 24,
                    )
                  : Text(
                      number,
                      style: GoogleFonts.arimo(
                        color: isCurrent ? Colors.white : navy,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(13),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 78),
                padding: const EdgeInsets.fromLTRB(16, 11, 12, 11),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? const Color(0xFFF6E3B7)
                      : cream.withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: isCurrent ? gold : gold.withValues(alpha: 0.55),
                    width: isCurrent ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.arimo(
                              color: navy,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.arimo(
                                color: navy.withValues(alpha: 0.8),
                                fontSize: 12,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: navy,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
