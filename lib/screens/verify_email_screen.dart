import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veer_gatha/main.dart';
import 'package:veer_gatha/widgets/app_background.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> resendVerificationEmail() async {
    try {
      setState(() {
        isLoading = true;
      });

      final user = _auth.currentUser;

      if (user == null) {
        if (mounted) {
          context.go('/login');
        }
        return;
      }

      await user.sendEmailVerification();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.darkNavy,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Verification email sent successfully.',
                  style: GoogleFonts.arimo(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Text(
            e.message ?? 'Could not send verification email.',
            style: GoogleFonts.arimo(color: Colors.white, fontSize: 13),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> checkVerification() async {
    try {
      setState(() {
        isLoading = true;
      });
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        if (mounted) {
          context.go('/login');
        }
        return;
      }
      await currentUser.reload();
      final user = _auth.currentUser;
      if (!mounted) return;

      if (user != null && user.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.darkNavy,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            content: Text(
              'Email verified successfully!',
              style: GoogleFonts.arimo(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));

        if (!mounted) return;

        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.brown,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            content: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Email is not verified yet. Please check your inbox.',
                    style: GoogleFonts.arimo(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Verification check error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Text(
            'Unable to check verification status.',
            style: GoogleFonts.arimo(color: Colors.white),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> logout() async {
    await _auth.signOut();

    if (!mounted) return;

    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final email = _auth.currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;

              final compact = height < 700;

              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: compact ? 12 : 24,
                  ),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 410),
                    padding: EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: compact ? 18 : 26,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(248, 236, 216, 0.96),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: AppColors.brown.withValues(alpha: 0.28),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.16),
                          blurRadius: 30,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: compact ? 48 : 56,
                              height: compact ? 48 : 56,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'VEER GATHA',
                                  style: GoogleFonts.arimo(
                                    color: AppColors.darkNavy,
                                    fontSize: compact ? 17 : 19,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.3,
                                  ),
                                ),
                                Text(
                                  'वीर गाथा',
                                  style: GoogleFonts.arimo(
                                    color: AppColors.brown,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: compact ? 14 : 20),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.brown.withValues(alpha: 0.25),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Icon(
                                Icons.diamond_outlined,
                                size: 13,
                                color: AppColors.brown,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.brown.withValues(alpha: 0.25),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: compact ? 14 : 20),

                        Container(
                          width: compact ? 66 : 76,
                          height: compact ? 66 : 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.darkNavy,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.darkNavy.withValues(
                                  alpha: 0.20,
                                ),
                                blurRadius: 16,
                                offset: const Offset(0, 7),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.mark_email_read_outlined,
                            size: compact ? 31 : 36,
                            color: const Color.fromRGBO(248, 236, 216, 1),
                          ),
                        ),

                        SizedBox(height: compact ? 13 : 17),

                        Text(
                          'Verify Your Email',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.arimo(
                            color: AppColors.darkNavy,
                            fontSize: compact ? 23 : 27,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'One step away from your journey',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.arimo(
                            color: AppColors.brown,
                            fontSize: compact ? 12 : 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),

                        SizedBox(height: compact ? 14 : 18),

                        Text(
                          'We sent a verification link to your email address.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.arimo(
                            color: AppColors.darkNavy.withValues(alpha: 0.72),
                            fontSize: compact ? 13 : 14,
                            height: 1.45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: compact ? 12 : 15),

                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: compact ? 11 : 13,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.72),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.brown.withValues(alpha: 0.20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: AppColors.brown.withValues(
                                    alpha: 0.10,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.email_outlined,
                                  color: AppColors.brown,
                                  size: 19,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  email,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.arimo(
                                    color: AppColors.darkNavy,
                                    fontSize: compact ? 12.5 : 13.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: compact ? 14 : 18),

                        SizedBox(
                          width: double.infinity,
                          height: compact ? 48 : 52,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : checkVerification,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkNavy,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade400,
                              elevation: 4,
                              shadowColor: AppColors.darkNavy.withValues(
                                alpha: 0.30,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 21,
                                    width: 21,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.verified_outlined,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'I Have Verified',
                                        style: GoogleFonts.arimo(
                                          fontSize: compact ? 14 : 15,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        SizedBox(height: compact ? 8 : 10),

                        TextButton(
                          onPressed: isLoading ? null : resendVerificationEmail,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.brown,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                          ),
                          child: Text(
                            'Resend verification email',
                            style: GoogleFonts.arimo(
                              color: AppColors.brown,
                              fontSize: compact ? 12.5 : 13,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.brown,
                            ),
                          ),
                        ),

                        SizedBox(height: compact ? 3 : 6),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 15,
                              color: AppColors.darkNavy.withValues(alpha: 0.55),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Check your Spam or Junk folder',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.arimo(
                                  color: AppColors.darkNavy.withValues(
                                    alpha: 0.60,
                                  ),
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: compact ? 8 : 12),

                        TextButton(
                          onPressed: isLoading ? null : logout,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.darkNavy,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.arrow_back_rounded, size: 16),
                              const SizedBox(width: 5),
                              Text(
                                'Back to Login',
                                style: GoogleFonts.arimo(
                                  color: AppColors.darkNavy,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
