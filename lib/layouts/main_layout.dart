import 'package:flutter/material.dart';
import 'package:veer_gatha/layouts/app_header.dart';
import 'package:veer_gatha/layouts/app_footer.dart';
import 'package:veer_gatha/widgets/app_background.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppHeader(),
        body: child,
        bottomNavigationBar: AppFooter(),
      ),
    );
  }
}
