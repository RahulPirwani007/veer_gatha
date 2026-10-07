
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veer_gatha/main.dart';

class ChapterTile extends StatelessWidget {
  final String imageUrl;
  final String number;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const ChapterTile({
    super.key,
    required this.imageUrl,
    required this.number,
    required this.title,
    required this.description,
    this.onTap,
  });

  static const Color navy = AppColors.navy;
  static const Color brown = AppColors.brown;
  static const Color gold = AppColors.gold;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9ED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: gold.withValues(alpha: 0.7),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Chapter image and number
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              width: 76,
                              height: 76,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }

                                return _imagePlaceholder(
                                  isLoading: true,
                                );
                              },
                              errorBuilder:
                                  (context, error, stackTrace) {
                                return _imagePlaceholder();
                              },
                            )
                          : _imagePlaceholder(),
                    ),

                    // Chapter number badge
                    Positioned(
                      top: -5,
                      left: -5,
                      child: Container(
                        width: 25,
                        height: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: navy,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFFF9ED),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          number,
                          style: GoogleFonts.arimo(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.arimo(
                          color: navy,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        description.isNotEmpty
                            ? description
                            : 'Explore this chapter and its story.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.arimo(
                          fontSize: 12,
                          height: 1.4,
                          color: const Color(0xFF343434),
                        ),
                      ),

                      const SizedBox(height: 7),

                      Row(
                        children: [
                          const Icon(
                            Icons.menu_book_rounded,
                            size: 15,
                            color: brown,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Read Chapter',
                            style: GoogleFonts.arimo(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: brown,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 6),

                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1DDBB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: navy,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder({bool isLoading = false}) {
    return Container(
      width: 76,
      height: 76,
      color: AppColors.sandDark,
      alignment: Alignment.center,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: brown,
              ),
            )
          : const Icon(
              Icons.menu_book_rounded,
              size: 30,
              color: brown,
            ),
    );
  }
}