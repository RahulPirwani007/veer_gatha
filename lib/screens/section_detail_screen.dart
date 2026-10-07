import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veer_gatha/main.dart';
import 'package:veer_gatha/widgets/skeleton_loaders.dart';

class SectionDetailScreen extends StatelessWidget {
  final String veerId;
  final String chapterId;
  final String sectionId;

  const SectionDetailScreen({
    super.key,
    required this.veerId,
    required this.chapterId,
    required this.sectionId,
  });

  static const Color navy = AppColors.navy;
  static const Color brown = AppColors.brown;
  static const Color gold = AppColors.gold;
  static const Color cream = Color(0xFFFFF8EA);

  @override
  Widget build(BuildContext context) {
    final sectionsRef = FirebaseFirestore.instance
        .collection('veers')
        .doc(veerId)
        .collection('chapters')
        .doc(chapterId)
        .collection('sections');

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: sectionsRef.doc(sectionId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SectionDetailSkeleton();
        }

        if (snapshot.hasError) {
          return Center(child: Text('Unable to load section'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('Section not found'));
        }

        final data = snapshot.data!.data() ?? {};
        final title = data['title']?.toString() ?? 'Section';
        final content = data['content']?.toString() ?? '';
        final description = data['description']?.toString() ?? '';
        final imageUrl =
            data['imageUrl']?.toString() ?? data['imgUrl']?.toString() ?? '';

        final paragraphs = content
            .split(RegExp(r'\n+'))
            .where((p) => p.trim().isNotEmpty)
            .map((p) => p.trim())
            .toList();
        final wordCount = content.trim().isEmpty
            ? 0
            : content.trim().split(RegExp(r'\s+')).length;
        final minutes = wordCount <= 200 ? 1 : (wordCount / 200).ceil();

        return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: sectionsRef.orderBy('order').get(),
          builder: (context, listSnapshot) {
            if (listSnapshot.connectionState == ConnectionState.waiting) {
              return const SectionDetailSkeleton();
            }

            final sections = listSnapshot.data?.docs ?? [];
            final total = sections.length;
            final index = sections.indexWhere((s) => s.id == sectionId);
            final currentNumber = index == -1 ? 1 : index + 1;

            final hasPrevious = index > 0;
            final hasNext = index != -1 && index < total - 1;

            final previousDoc = hasPrevious ? sections[index - 1] : null;
            final nextDoc = hasNext ? sections[index + 1] : null;
            final nextTitle = nextDoc?.data()['title']?.toString() ?? '';

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(18, 14, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (total > 0) ...[
                    Row(
                      children: List.generate(total, (i) {
                        return Expanded(
                          child: Container(
                            height: 5,
                            margin: EdgeInsets.only(
                              right: i == total - 1 ? 0 : 5,
                            ),
                            decoration: BoxDecoration(
                              color: i <= currentNumber - 1
                                  ? gold
                                  : Color(0xFFE4E0D6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 14),
                  ],

                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 240,
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    color: AppColors.sandDark,
                                    child: Center(
                                      child: Icon(
                                        Icons.auto_stories_rounded,
                                        size: 55,
                                        color: brown,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  color: AppColors.sandDark,
                                  child: Center(
                                    child: Icon(
                                      Icons.auto_stories_rounded,
                                      size: 55,
                                      color: brown,
                                    ),
                                  ),
                                ),
                        ),
                        Positioned.fill(
                          child: IgnorePointer(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.45),
                                  ],
                                  stops: [0.55, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 14,
                          bottom: 14,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFF4D9),
                              border: Border.all(color: gold),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '✧  SECTION $currentNumber OF $total  ✧',
                              style: GoogleFonts.arimo(
                                color: brown,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    title,
                    style: GoogleFonts.arimo(
                      color: navy,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                  ),

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, color: brown, size: 18),
                      SizedBox(width: 6),
                      Text(
                        '$minutes min read',
                        style: GoogleFonts.arimo(
                          color: navy,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  if (description.isNotEmpty) ...[
                    SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(14, 4, 4, 4),
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: gold, width: 3)),
                      ),
                      child: Text(
                        description,
                        style: GoogleFonts.arimo(
                          color: brown,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: gold.withValues(alpha: 0.5),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.auto_awesome, color: gold, size: 18),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: gold.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                    decoration: BoxDecoration(
                      color: cream.withValues(alpha: 0.96),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: gold.withValues(alpha: 0.6)),
                    ),
                    child: paragraphs.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Section content is not available.',
                              style: GoogleFonts.arimo(
                                color: navy,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: paragraphs.asMap().entries.map((entry) {
                              final text = entry.value;
                              final isFirst = entry.key == 0;

                              return Padding(
                                padding: EdgeInsets.only(bottom: 14),
                                child: isFirst
                                    // First paragraph with drop-cap letter
                                    ? RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: text.substring(0, 1),
                                              style: GoogleFonts.arimo(
                                                color: brown,
                                                fontSize: 30,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            TextSpan(
                                              text: text.substring(1),
                                              style: GoogleFonts.arimo(
                                                color: navy,
                                                fontSize: 16.5,
                                                height: 1.8,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Text(
                                        text,
                                        style: GoogleFonts.arimo(
                                          color: navy,
                                          fontSize: 16.5,
                                          height: 1.8,
                                        ),
                                      ),
                              );
                            }).toList(),
                          ),
                  ),

                  if (hasNext) ...[
                    SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF6E3B7),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: gold),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_stories_rounded,
                            color: brown,
                            size: 22,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'UP NEXT',
                                  style: GoogleFonts.arimo(
                                    color: brown,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  nextTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.arimo(
                                    color: navy,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  Padding(
                    padding: EdgeInsets.only(top: 22, bottom: 4),
                    child: Row(
                      children: [
                        // Previous
                        Expanded(
                          flex: 4,
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: hasPrevious
                                  ? () => _goToSection(context, previousDoc!.id)
                                  : null,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: navy,
                                disabledForegroundColor: navy.withValues(alpha: 0.3),
                                backgroundColor: cream.withValues(alpha: 0.9),
                                side: BorderSide(
                                  color: hasPrevious
                                      ? gold
                                      : gold.withValues(alpha: 0.35),
                                ),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_back_rounded, size: 20),
                                  SizedBox(width: 6),
                                  Text(
                                    'Previous',
                                    style: GoogleFonts.arimo(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 12),

                        Expanded(
                          flex: 6,
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                if (hasNext) {
                                  _goToSection(context, nextDoc!.id);
                                } else if (context.canPop()) {
                                  // last section -> back to chapter
                                  context.pop();
                                } else {
                                  context.go(
                                    '/veer/$veerId/chapter/$chapterId',
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFFB300),
                                foregroundColor: navy,
                                elevation: 1,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  side: BorderSide(color: gold),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    hasNext ? 'Next Section' : 'Finish Chapter',
                                    style: GoogleFonts.arimo(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    hasNext
                                        ? Icons.arrow_forward_rounded
                                        : Icons.check_circle_rounded,
                                    size: 22,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _goToSection(BuildContext context, String targetSectionId) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('progress')
          .doc('${veerId}_$chapterId')
          .set({
            'veerId': veerId,
            'chapterId': chapterId,
            'readSections': FieldValue.arrayUnion([targetSectionId]),
            'lastSectionId': targetSectionId,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    }

    context.pushReplacement(
      '/veer/$veerId/chapter/$chapterId/section/$targetSectionId',
    );
  }
}
