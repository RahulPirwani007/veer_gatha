import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veer_gatha/main.dart';
import 'package:veer_gatha/widgets/app_background.dart';
import 'package:veer_gatha/widgets/skeleton_loaders.dart';

class VeersGridScreen extends StatelessWidget {
  const VeersGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('veers').snapshots(),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const VeerGridSkeleton();
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: GoogleFonts.arimo(color: AppColors.navy),
              ),
            );
          }

          final veers = snapshot.data?.docs ?? [];

          // Empty
          if (veers.isEmpty) {
            return Center(
              child: Text(
                'No veers available',
                style: GoogleFonts.arimo(color: AppColors.navy, fontSize: 16),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),

            itemCount: veers.length,

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,

              mainAxisExtent: 270,
            ),

            itemBuilder: (context, index) {
              final doc = veers[index];
              final data = doc.data();
              final name = data['name']?.toString() ?? 'Unknown Veer';
              final region = data['region']?.toString() ?? '';
              final image = data['imgUrl']?.toString() ?? '';

              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  context.push('/veer/${doc.id}');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(8),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: image.isNotEmpty
                              ? Image.network(
                                  image,
                                  width: double.infinity,
                                  height: 50,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppColors.sand,
                                      child: const Center(
                                        child: Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: AppColors.sand,
                                  child: const Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      SizedBox(
                        height: 52,
                        child: Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.arimo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                            height: 1.45,
                          ),
                        ),
                      ),

                      const SizedBox(height: 2),

                      SizedBox(
                        height: 24,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: AppColors.brown,
                            ),

                            const SizedBox(width: 3),

                            Expanded(
                              child: Text(
                                region,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.arimo(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
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
