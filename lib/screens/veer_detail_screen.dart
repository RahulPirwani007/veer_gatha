import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:veer_gatha/main.dart';
import 'package:veer_gatha/widgets/app_background.dart';
import 'package:veer_gatha/widgets/chapter_tile.dart';
import 'package:veer_gatha/widgets/fact_grid_item.dart';
import 'package:veer_gatha/widgets/hero_card.dart';
import 'package:veer_gatha/widgets/section_header.dart';

class VeerDetailScreen extends StatefulWidget {
  final String veerId;

  const VeerDetailScreen({super.key, required this.veerId});

  @override
  State<VeerDetailScreen> createState() => _VeerDetailScreenState();
}

class _VeerDetailScreenState extends State<VeerDetailScreen> {
  bool isLoading = true;
  Map<String, dynamic>? veer;

  @override
  void initState() {
    super.initState();
    _fetchVeer();
  }

  Future<void> _fetchVeer() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('veers')
          .doc(widget.veerId)
          .get();

      if (!mounted) return;

      setState(() {
        veer = doc.exists ? doc.data() : null;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading veer: $e');

      if (!mounted) return;

      setState(() {
        veer = null;
        isLoading = false;
      });
    }
  }

  String _getValue(Map<String, dynamic> data, String key) {
    final value = data[key]?.toString().trim();

    if (value == null || value.isEmpty) {
      return '-';
    }

    return value;
  }

  Widget _detailSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 260,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Container(
                      width: 130,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      width: 240,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      width: 160,
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _skeletonSectionHeader(),
                    const SizedBox(height: 16),
                    _skeletonLine(double.infinity),
                    const SizedBox(height: 8),
                    _skeletonLine(double.infinity),
                    const SizedBox(height: 8),
                    _skeletonLine(double.infinity),
                    const SizedBox(height: 8),
                    _skeletonLine(260),
                    const SizedBox(height: 18),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 210,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _skeletonSectionHeader(),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.5,
                      children: List.generate(7, (index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _skeletonSectionHeader(),
                        Container(
                          width: 100,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _chapterSkeletonCard(),
                    const SizedBox(height: 10),
                    _chapterSkeletonCard(),
                    const SizedBox(height: 10),
                    _chapterSkeletonCard(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _skeletonLine(double width) {
    return Container(
      width: width,
      height: 14,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _skeletonSectionHeader() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 100,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }

  Widget _chapterSkeletonCard() {
    return Container(
      width: double.infinity,
      height: 82,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _chapterSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(3, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index == 2 ? 0 : 10),
            child: ChapterTile(
              imageUrl: '',
              number: '00',
              title: 'Chapter title',
              description: 'Chapter description',
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AppBackground(child: _detailSkeleton());
    }

    if (veer == null || veer!.isEmpty) {
      return AppBackground(
        child: Center(
          child: Text(
            'Veer not found',
            style: GoogleFonts.arimo(fontSize: 18, color: AppColors.navy),
          ),
        ),
      );
    }

    final data = veer!;
    final String imgUrl = data['imgUrl']?.toString() ?? '';
    final String region = data['region']?.toString() ?? '';
    final String name = data['name']?.toString() ?? 'Unknown Veer';
   final String hindiName = data['hindiName']?.toString() ?? '';
    final String quote = data['quote']?.toString() ?? '';
    final String description = data['description']?.toString() ?? '';
    final String birthDate = _getValue(data, 'birthDate');
    final String birthPlace = _getValue(data, 'birthPlace');
    final String father = _getValue(data, 'father');
    final String mother = _getValue(data, 'mother');
    final String deathDate = _getValue(data, 'deathDate');
  final String deathPlace = _getValue(data, 'deathPlace');
    final String era = _getValue(data, 'era');

    return AppBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroCard(
                imgUrl: imgUrl,
                region: region,
                name: name,
                hindiName: hindiName,
                quote: quote,
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(icon: Icons.person, title: 'About'),

                    const SizedBox(height: 10),

                    Text(
                      description.trim().isEmpty
                          ? 'No description available.'
                          : description,
                      style: GoogleFonts.arimo(
                        fontSize: 15,
                        height: 1.6,
                        color: AppColors.navy,
                      ),
                    ),

                    if (quote.trim().isNotEmpty) ...[
                      const SizedBox(height: 14),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.sand,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            '“$quote”',
                            style: GoogleFonts.arimo(
                              fontStyle: FontStyle.italic,
                              fontSize: 13,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(
                      icon: Icons.emoji_events,
                      title: 'Key Facts',
                    ),

                    const SizedBox(height: 14),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2.5,
                      children: [
                        FactGridItem(
                          icon: Icons.person_outline,
                          label: 'Mother',
                          value: mother,
                        ),

                        FactGridItem(
                          icon: Icons.person_outline,
                          label: 'Father',
                          value: father,
                        ),

                        FactGridItem(
                          icon: Icons.calendar_today,
                          label: 'Birth',
                          value: birthDate,
                        ),

                        FactGridItem(
                          icon: Icons.location_on_outlined,
                          label: 'Birth Place',
                          value: birthPlace,
                        ),

                        FactGridItem(
                          icon: Icons.event,
                          label: 'Death Date',
                          value: deathDate,
                        ),

                        FactGridItem(
                          icon: Icons.location_on_outlined,
                          label: 'Death Place',
                          value: deathPlace,
                        ),

                        FactGridItem(
                          icon: Icons.history,
                          label: 'Era',
                          value: era,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('veers')
                      .doc(widget.veerId)
                      .collection('chapters')
                      .snapshots(),

                  builder: (context, snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SectionHeader(
                                icon: Icons.menu_book,
                                title: 'Chapters',
                              ),

                              Text(
                                'Loading...',
                                style: GoogleFonts.arimo(
                                  color: AppColors.brown,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          _chapterSkeleton(),
                        ],
                      );
                    }

                    if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      );
                    }

                    final chapters = snapshot.data?.docs ?? [];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SectionHeader(
                              icon: Icons.menu_book,
                              title: 'Chapters',
                            ),

                            Text(
                              'Total ${chapters.length} Chapters',
                              style: GoogleFonts.arimo(
                                color: const Color.fromRGBO(154, 67, 26, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        if (chapters.isEmpty)
                          Text(
                            'No chapters available',
                            style: GoogleFonts.arimo(color: AppColors.navy),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: chapters.length,
                            itemBuilder: (context, index) {
                              final chapter = chapters[index].data();
                              final title =
                                  chapter['title']?.toString().trim() ?? '';
                              final description =
                                  chapter['description']?.toString() ?? '';
                              final imageUrl =
                                  chapter['imgUrl']?.toString() ?? '';
                              return ChapterTile(
                                imageUrl: imageUrl,
                                number: (index + 1).toString().padLeft(2, '0'),
                                title: title.isNotEmpty
                                    ? title
                                    : 'Chapter ${index + 1}',
                                description: description,
                                onTap: () {
                                  context.push(
                                    '/veer/${widget.veerId}/chapter/${chapters[index].id}',
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
