import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veer_gatha/main.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(18, 10, 18, 12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
          height: 70,
          decoration: BoxDecoration(
            color: Color.fromRGBO(234, 244, 223, 0.92),
            border: Border.all(
              color: Color.fromRGBO(255, 255, 255, 0.7),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _FooterItem(
                icon: Icons.home_rounded,
                label: "Home",
                selected: path == '/home',
                onTap: () {
                  context.go('/home');
                },
              ),

              _FooterItem(
                icon: Icons.menu_book_rounded,
                label: "Stories",
                selected: path == '/stories',
                onTap: () {
                  context.go('/stories');
                },
              ),

              _FooterItem(
                icon: Icons.bookmark_rounded,
                label: "Saved",
                selected: path == '/saved',
                onTap: () {
                  context.go('/saved');
                },
              ),

              _FooterItem(
                icon: Icons.person_rounded,
                label: "Profile",
                selected: path == '/profile',
                onTap: () {
                  context.go('/profile');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FooterItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        height: 68,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 27, color: Color(0xFF182B3A)),

            SizedBox(height: 3),

            Text(
              label,
              style: GoogleFonts.arimo(
                fontSize: 13,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                color: Color(0xFF182B3A),
              ),
            ),

            SizedBox(height: 4),

            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: selected ? 48 : 0,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
