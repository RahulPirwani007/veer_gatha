import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:veer_gatha/main.dart';
import 'package:veer_gatha/widgets/section_timeline_tile.dart';

Widget _block({double? width, required double height, double radius = 10}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.sandDark,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

class VeerListSkeleton extends StatelessWidget {
  final int itemCount;
  const VeerListSkeleton({super.key, this.itemCount = 6});
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                _block(width: 90, height: 90, radius: 14),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Loading Veer Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('वीर का नाम', style: TextStyle(fontSize: 14)),
                      SizedBox(height: 5),
                      Text('Region name', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class VeerGridSkeleton extends StatelessWidget {
  const VeerGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _block(width: double.infinity, height: 100, radius: 10),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Loading Veer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text('Region', style: TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SectionTilesSkeleton extends StatelessWidget {
  const SectionTilesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(
          3,
          (i) => SectionTimelineTile(
            number: '0${i + 1}',
            title: 'Loading section title',
            description: 'Loading section description text goes here for you',
            isDone: false,
            isCurrent: false,
            onTap: () {},
          ),
        ),
      ),
    );
  }
}

class ChapterDetailSkeleton extends StatelessWidget {
  const ChapterDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.sand,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '✧  CHAPTER 01  ✧',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Chapter title here',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 5),
            const Text(
              'Chapter subtitle',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            const Row(
              children: [
                Icon(Icons.menu_book_rounded, size: 20),
                SizedBox(width: 7),
                Text('5 min read', style: TextStyle(fontSize: 14)),
                SizedBox(width: 18),
                Icon(Icons.layers_rounded, size: 20),
                SizedBox(width: 7),
                Text('4 sections', style: TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 16),
            _block(width: double.infinity, height: 220, radius: 18),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _block(height: 7, radius: 20)),
                const SizedBox(width: 12),
                const Text(
                  'Your journey • 1 of 4 sections',
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(17, 14, 17, 16),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The Beginning',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Explore the story and important events that shaped this '
                    'chapter. Loading the description text for this chapter '
                    'so the card looks filled while data is fetched.',
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionTilesSkeleton(),
          ],
        ),
      ),
    );
  }
}

class SectionDetailSkeleton extends StatelessWidget {
  const SectionDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                4,
                (i) => Expanded(
                  child: Container(
                    height: 5,
                    margin: EdgeInsets.only(right: i == 3 ? 0 : 5),
                    decoration: BoxDecoration(
                      color: AppColors.sandDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            _block(width: double.infinity, height: 240, radius: 22),
            const SizedBox(height: 16),
            const Text(
              'Section title loading',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Short section description goes here',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 14),
            const Row(
              children: [
                Icon(Icons.schedule, size: 18),
                SizedBox(width: 6),
                Text('2 min read', style: TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Loading paragraph text for this section. The story content '
              'will appear here once it has been loaded from the server. '
              'Loading paragraph text for this section. The story content '
              'will appear here once it has been loaded from the server.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 12),
            const Text(
              'Loading paragraph text for this section. The story content '
              'will appear here once it has been loaded from the server. '
              'Loading paragraph text for this section.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _block(height: 48, radius: 24)),
                const SizedBox(width: 12),
                Expanded(child: _block(height: 48, radius: 24)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
