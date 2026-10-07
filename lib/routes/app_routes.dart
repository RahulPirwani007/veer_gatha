import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:veer_gatha/layouts/main_layout.dart';
import 'package:veer_gatha/screens/chapter_detail_screen.dart';
import 'package:veer_gatha/screens/coming_soon_screen.dart';
import 'package:veer_gatha/screens/eras_grid_screen.dart';
import 'package:veer_gatha/screens/home_screen.dart';
import 'package:veer_gatha/screens/login_screen.dart';
import 'package:veer_gatha/screens/profile_screen.dart';
import 'package:veer_gatha/screens/saved_screen.dart';
import 'package:veer_gatha/screens/search_screen.dart';
import 'package:veer_gatha/screens/section_detail_screen.dart';
import 'package:veer_gatha/screens/signup_screen.dart';
import 'package:veer_gatha/screens/splash_screen.dart';
import 'package:veer_gatha/screens/stories_screen.dart';
import 'package:veer_gatha/screens/terms_screen.dart';
import 'package:veer_gatha/screens/veer_detail_screen.dart';
import 'package:veer_gatha/screens/veers_grid_screen.dart';
import 'package:veer_gatha/screens/verify_email_screen.dart';

final GoRouter appRoutes = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final location = state.matchedLocation;

    // Splash screen ko hamesha allow karo
    if (location == '/splash') return null;

    final user = FirebaseAuth.instance.currentUser;

    final isLoggedIn = user != null;
    final isEmailVerified = user?.emailVerified ?? false;

    final isLoginPage = location == '/login';
    final isSignupPage = location == '/signup';
    final isVerifyEmailPage = location == '/verify-email';

    // User login nahi hai
    if (!isLoggedIn) {
      if (isLoginPage || isSignupPage) {
        return null;
      }

      return '/login';
    }

    // User login hai, lekin email verify nahi hai
    if (!isEmailVerified) {
      if (isVerifyEmailPage) {
        return null;
      }

      return '/verify-email';
    }

    // User login hai aur email verified hai
    if (isLoginPage || isSignupPage || isVerifyEmailPage) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) => const VerifyEmailScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => MainLayout(child: const HomeScreen()),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => MainLayout(child: const SearchScreen()),
    ),
    GoRoute(
      path: '/coming-soon',
      builder: (context, state) => MainLayout(
        child: ComingSoonScreen(
          title: state.uri.queryParameters['title'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/veers',
      builder: (context, state) => MainLayout(child: const VeersGridScreen()),
    ),
    GoRoute(
      path: '/eras',
      builder: (context, state) => MainLayout(child: const ErasGridScreen()),
    ),
    GoRoute(
      path: '/veer/:veerId',
      builder: (context, state) {
        final veerId = state.pathParameters['veerId']!;
        return MainLayout(child: VeerDetailScreen(veerId: veerId));
      },
    ),
    GoRoute(
      path: '/stories',
      builder: (context, state) => MainLayout(child: const StoriesScreen()),
    ),
    GoRoute(
      path: '/saved',
      builder: (context, state) => MainLayout(child: const SavedScreen()),
    ),
    GoRoute(
      path: '/terms',
      builder: (context, state) => MainLayout(child: const TermsScreen()),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => MainLayout(child: const ProfileScreen()),
    ),
    GoRoute(
      path: '/veer/:veerId/chapter/:chapterId',
      builder: (context, state) {
        return MainLayout(
          child: ChapterDetailScreen(
            veerId: state.pathParameters['veerId']!,
            chapterId: state.pathParameters['chapterId']!,
          ),
        );
      },
    ),
    GoRoute(
      path: '/veer/:veerId/chapter/:chapterId/section/:sectionId',
      builder: (context, state) {
        return MainLayout(
          child: SectionDetailScreen(
            veerId: state.pathParameters['veerId']!,
            chapterId: state.pathParameters['chapterId']!,
            sectionId: state.pathParameters['sectionId']!,
          ),
        );
      },
    ),
  ],
);
