import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veer_gatha/widgets/section_timeline_tile.dart';
import 'package:veer_gatha/main.dart';
import 'package:veer_gatha/widgets/skeleton_loaders.dart';

class ChapterDetailScreen extends StatelessWidget {
  final String veerId;
  final String chapterId;

  const ChapterDetailScreen({
    super.key,
    required this.veerId,
    required this.chapterId,
  });

  static Color navy = AppColors.navy;
  static Color brown = AppColors.brown;
  static Color gold = AppColors.gold;
  static Color cream = Color(0xFFFFF8EA);

  @override
  Widget build(BuildContext context) {
    final chapterRef = FirebaseFirestore.instance
        .collection('veers')
        .doc(veerId)
        .collection('chapters')
        .doc(chapterId);

    final uid = FirebaseAuth.instance.currentUser?.uid;

    final progressRef = uid == null
        ? null
        : FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('progress')
              .doc('${veerId}_$chapterId');

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: chapterRef.get(),
      builder: (context, chapterSnapshot) {
        if (chapterSnapshot.connectionState == ConnectionState.waiting) {
          return const ChapterDetailSkeleton();
        }

        if (chapterSnapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (!chapterSnapshot.hasData || !chapterSnapshot.data!.exists) {
          return Center(child: Text('Chapter not found'));
        }

        final chapter = chapterSnapshot.data!.data() ?? {};

        final title = chapter['title']?.toString() ?? 'Chapter';
        final subtitle = chapter['subtitle']?.toString() ?? '';
        final description =
            chapter['description']?.toString() ??
            chapter['content']?.toString() ??
            '';
        final imageUrl =
            chapter['imageUrl']?.toString() ??
            chapter['imgUrl']?.toString() ??
            '';
        final readingTime = chapter['readingTime']?.toString() ?? '5';
        final chapterNumber = chapter['chapterNumber']?.toString() ?? chapterId;

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: chapterRef
              .collection('sections')
              .orderBy('order')
              .snapshots(),
          builder: (context, sectionSnapshot) {
            final sections = sectionSnapshot.data?.docs ?? [];

            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: progressRef?.snapshots(),
              builder: (context, progressSnapshot) {
                final readIds = List<String>.from(
                  progressSnapshot.data?.data()?['readSections'] ?? [],
                );

                final total = sections.length;
                final readCount = sections
                    .where((section) => readIds.contains(section.id))
                    .length;

                final currentIndex = sections.indexWhere(
                  (section) => !readIds.contains(section.id),
                );

                final allDone = total > 0 && currentIndex == -1;

                final currentStep = total == 0
                    ? 0
                    : allDone
                    ? total
                    : currentIndex + 1;

                final progressValue = total == 0 ? 0.0 : currentStep / total;

                final _ = readCount;

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(18, 16, 18, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
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
                          '✧  CHAPTER $chapterNumber  ✧',
                          style: GoogleFonts.arimo(
                            color: brown,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      Text(
                        title,
                        style: GoogleFonts.arimo(
                          color: navy,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),

                      if (subtitle.isNotEmpty) ...[
                        SizedBox(height: 5),
                        Text(
                          subtitle,
                          style: GoogleFonts.arimo(
                            color: navy,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],

                      SizedBox(height: 14),

                      Row(
                        children: [
                          Icon(Icons.menu_book_rounded, color: brown, size: 20),
                          SizedBox(width: 7),
                          Text(
                            '$readingTime min read',
                            style: GoogleFonts.arimo(color: navy, fontSize: 14),
                          ),
                          SizedBox(width: 18),
                          Icon(Icons.layers_rounded, color: brown, size: 20),
                          SizedBox(width: 7),
                          Text(
                            '$total sections',
                            style: GoogleFonts.arimo(color: navy, fontSize: 14),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: SizedBox(
                          width: double.infinity,
                          height: 220,
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.fill,
                                  errorBuilder: (_, _, _) =>
                                      _buildImagePlaceholder(),
                                )
                              : _buildImagePlaceholder(),
                        ),
                      ),

                      SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(end: progressValue),
                                duration: Duration(milliseconds: 500),
                                builder: (context, value, _) {
                                  return LinearProgressIndicator(
                                    value: value,
                                    minHeight: 7,
                                    backgroundColor: Color(0xFFE4E0D6),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      gold,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Your journey • $currentStep of $total sections',
                            style: GoogleFonts.arimo(
                              color: navy,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(17, 14, 17, 16),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 248, 234, 0.96),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Color.fromRGBO(197, 155, 82, 0.8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.auto_awesome, color: gold, size: 20),
                                SizedBox(width: 9),
                                Expanded(
                                  child: Text(
                                    'The Beginning',
                                    style: GoogleFonts.arimo(
                                      color: navy,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              description.isNotEmpty
                                  ? description
                                  : 'Explore the story and important events that shaped this chapter.',
                              style: GoogleFonts.arimo(
                                color: navy,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      if (sectionSnapshot.hasError)
                        Center(child: Text('Unable to load sections'))
                      else if (sectionSnapshot.connectionState ==
                              ConnectionState.waiting &&
                          sections.isEmpty)
                        const SectionTilesSkeleton()
                      else if (sections.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cream,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Color.fromARGB(218, 197, 155, 6),
                            ),
                          ),
                          child: Text(
                            'No sections added yet.',
                            style: GoogleFonts.arimo(color: navy),
                          ),
                        )
                      else
                        ...sections.asMap().entries.map((entry) {
                          final index = entry.key;
                          final sectionDoc = entry.value;
                          final section = sectionDoc.data();

                          return SectionTimelineTile(
                            number: (index + 1).toString().padLeft(2, '0'),
                            title:
                                section['title']?.toString() ??
                                'Section ${index + 1}',
                            description:
                                section['description']?.toString() ??
                                section['content']?.toString() ??
                                '',
                            isDone: readIds.contains(sectionDoc.id),
                            isCurrent: index == currentIndex,
                            onTap: () => _openSection(context, sectionDoc.id),
                          );
                        }),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.sandDark,
      child: Center(child: Icon(Icons.castle_rounded, color: brown, size: 70)),
    );
  }

  void _openSection(BuildContext context, String sectionId) {
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
            'readSections': FieldValue.arrayUnion([sectionId]),
            'lastSectionId': sectionId,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    }

    context.push('/veer/$veerId/chapter/$chapterId/section/$sectionId');
  }
}
