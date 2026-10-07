import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chapter_tile.dart';
import 'package:veer_gatha/main.dart';

class ChapterList extends StatelessWidget {
  final String veerId;

  const ChapterList({super.key, required this.veerId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('veers')
          .doc(veerId)
          .collection('chapters')
          .snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.brown),
          );
        }
        if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(color: Colors.red),
          );
        }
        final chapters = snapshot.data?.docs ?? [];
        if (chapters.isEmpty) {
          return const Text('No chapters available');
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            final doc = chapters[index];
            final chapter = doc.data();
            final title = chapter['title']?.toString().trim() ?? '';
            return ChapterTile(
              imageUrl: chapter['imgUrl']?.toString() ?? '',
              number: (index + 1).toString().padLeft(2, '0'),
              title: title.isNotEmpty ? title : 'Chapter ${index + 1}',
              description: chapter['description']?.toString() ?? '',
              onTap: () {},
            );
          },
        );
      },
    );
  }
}
