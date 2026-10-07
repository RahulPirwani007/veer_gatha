import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veer_gatha/widgets/app_background.dart';
import 'package:veer_gatha/main.dart';
import 'package:veer_gatha/widgets/skeleton_loaders.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return AppBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Icon(
                Icons.lock_outline,
                size: 50,
                color: AppColors.navy,
              ),
               SizedBox(height: 12),
               Text('Please login to see saved Veers'),
               SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  context.push('/login');
                },
                child:  Text('Login'),
              ),
            ],
          ),
        ),
      );
    }

    return AppBackground(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('savedVeers')
            .orderBy('savedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const VeerListSkeleton();
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final saved = snapshot.data?.docs ?? [];

          if (saved.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Icon(
                    Icons.bookmark_border,
                    size: 60,
                    color: AppColors.navy,
                  ),
                   SizedBox(height: 10),
                  Text(
                    'No saved Veers',
                    style: GoogleFonts.arimo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:  AppColors.navy,
                    ),
                  ),
                   SizedBox(height: 6),
                   Text('Save your favourite heroes here.'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding:  EdgeInsets.all(16),
            itemCount: saved.length,
            itemBuilder: (context, index) {
              final doc = saved[index];
              final data = doc.data();

              return GestureDetector(
                onTap: () {
                  context.push('/veer/${doc.id}');
                },
                child: Container(
                  margin:  EdgeInsets.only(bottom: 14),
                  padding:  EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:  AppColors.cream,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          data['imgUrl']?.toString() ?? '',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),

                       SizedBox(width: 14),

                      Expanded(
                        child: Text(
                          data['name']?.toString() ?? 'Unknown Veer',
                          style: GoogleFonts.arimo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:  AppColors.navy,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('savedVeers')
                              .doc(doc.id)
                              .delete();
                        },
                        icon:  Icon(
                          Icons.bookmark,
                          color: AppColors.brown,
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
