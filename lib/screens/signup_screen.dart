import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:veer_gatha/widgets/app_background.dart';
import 'package:veer_gatha/widgets/custom_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool acceptTerms = false;
  bool isButtonEnabled = false;
  bool isLoading = false;


  void checkForm() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    final valid =
        name.isNotEmpty &&
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email) &&
        password.length >= 6 &&
        confirmPassword == password &&
        acceptTerms &&
        !isLoading;

    if (mounted) {
      setState(() {
        isButtonEnabled = valid;
      });
    }
  }


  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Please accept Terms & Conditions.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
      isButtonEnabled = false;
    });

    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text,
          );

      final User? user = credential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'User account could not be created.',
        );
      }

      debugPrint('✅ Firebase account created');
      debugPrint('User UID: ${user.uid}');
      debugPrint('User Email: ${user.email}');

      await user.updateDisplayName(nameController.text.trim());

      debugPrint('✅ Display name saved: ${nameController.text.trim()}');

      try {
        await user.sendEmailVerification();
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            content: Text(
              'Verification email failed.\n'
              'Code: ${e.code}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );

        return;
      }
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Account created! Verification email sent.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

      context.go('/verify-email');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email address is already registered.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'weak-password':
          message = 'Password is too weak. Please use a stronger password.';
          break;

        case 'operation-not-allowed':
          message = 'Email and password sign-up is currently unavailable.';
          break;

        case 'network-request-failed':
          message = 'Network error. Please check your internet connection.';
          break;

        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;

        default:
          message = e.message ?? 'Sign-up failed. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          content: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Something went wrong. Please try again.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });

        checkForm();
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.9),
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo.png', width: 100),

                    const SizedBox(height: 10),

                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    CustomTextField(
                      hintText: 'Full Name',
                      prefixIcon: Icons.person,
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter name';
                        }

                        return null;
                      },
                      onChanged: (_) {
                        checkForm();
                      },
                    ),

                    const SizedBox(height: 15),

                    CustomTextField(
                      hintText: 'Email',
                      prefixIcon: Icons.email,
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter email';
                        }

                        if (!RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        ).hasMatch(value.trim())) {
                          return 'Invalid email';
                        }

                        return null;
                      },
                      onChanged: (_) {
                        checkForm();
                      },
                    ),

                    const SizedBox(height: 15),

                    CustomTextField(
                      hintText: 'Password',
                      prefixIcon: Icons.lock,
                      controller: passwordController,
                      obscureText: hidePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter password';
                        }

                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }

                        return null;
                      },
                      onChanged: (_) {
                        checkForm();
                      },
                    ),

                    const SizedBox(height: 15),

                    CustomTextField(
                      hintText: 'Confirm Password',
                      prefixIcon: Icons.lock,
                      controller: confirmPasswordController,
                      obscureText: hideConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          hideConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          setState(() {
                            hideConfirmPassword = !hideConfirmPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm password';
                        }

                        if (value != passwordController.text) {
                          return 'Password does not match';
                        }

                        return null;
                      },
                      onChanged: (_) {
                        checkForm();
                      },
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Checkbox(
                          value: acceptTerms,
                          activeColor: Colors.green,
                          onChanged: isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    acceptTerms = value ?? false;
                                  });

                                  checkForm();
                                },
                        ),
                        const Expanded(
                          child: Text('I agree to Terms & Conditions'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isButtonEnabled ? signup : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey,
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text('Create Account'),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have account?'),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  context.go('/login');
                                },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
