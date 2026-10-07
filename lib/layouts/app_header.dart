import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veer_gatha/main.dart';
import 'package:go_router/go_router.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,

      leading: Image.asset("assets/images/logo.png", fit: BoxFit.contain),

      leadingWidth: 90,

      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "VEER GATHA",
            style: GoogleFonts.arimo(
              color: AppColors.navy,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          Container(width: 120, height: 2, color: AppColors.navy),

          Text(
            "वीर गाथा",
            style: GoogleFonts.arimo(
              color: AppColors.brown,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),

      centerTitle: true,

      actions: [
        // Notification
        IconButton(
          onPressed: () {
            // Notification screen baad me add kar sakte ho
          },
          icon: const Icon(Icons.notifications_none, color: AppColors.navy),
        ),

        // Profile
        StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            final User? currentUser = snapshot.data;

            final String? photoURL = currentUser?.photoURL;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  context.go('/profile');
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.sand,
                  backgroundImage: photoURL != null && photoURL.isNotEmpty
                      ? NetworkImage(photoURL)
                      : const AssetImage("assets/images/user.png")
                            as ImageProvider,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
