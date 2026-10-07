import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veer_gatha/widgets/app_background.dart';
import 'package:veer_gatha/main.dart';
import 'package:veer_gatha/widgets/skeleton_loaders.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('veers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const VeerListSkeleton();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: GoogleFonts.arimo(color: AppColors.navy),
              ),
            );
          }

          final veers = snapshot.data?.docs ?? [];

          if (veers.isEmpty) {
            return Center(child: Text('No stories available'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: veers.length,
            itemBuilder: (context, index) {
              final doc = veers[index];
              final data = doc.data();

              final name = data['name']?.toString() ?? 'Unknown Veer';

              final hindiName = data['hindiName']?.toString() ?? '';

              final image = data['imgUrl']?.toString() ?? '';

              final region = data['region']?.toString() ?? '';

              return GestureDetector(
                onTap: () {
                  context.push('/veer/${doc.id}');
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 14),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          image,
                          width: 90,
                          height: 90,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 90,
                              height: 90,
                              color: AppColors.sand,
                              child: Icon(Icons.person, size: 40),
                            );
                          },
                        ),
                      ),

                      SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.arimo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.navy,
                              ),
                            ),

                            if (hindiName.isNotEmpty)
                              Text(
                                hindiName,
                                style: GoogleFonts.arimo(
                                  fontSize: 14,
                                  color: AppColors.brown,
                                ),
                              ),

                            SizedBox(height: 5),

                            Text(
                              region,
                              style: GoogleFonts.arimo(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: AppColors.brown,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
