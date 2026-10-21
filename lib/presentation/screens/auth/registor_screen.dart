import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netflix_clone/core/constants/app_constant.dart';

import '../../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
const RegisterScreen({super.key});

@override
ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
final _formKey = GlobalKey<FormState>();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _confirmPasswordController = TextEditingController();

bool _obscurePassword = true;
bool _obscureConfirmPassword = true;
bool _isLoading = false;

@override
void dispose() {
_emailController.dispose();
_passwordController.dispose();
_confirmPasswordController.dispose();
super.dispose();
}

Future<void> _register() async {
if (!_formKey.currentState!.validate()) return;


setState(() => _isLoading = true);

try {
  final user = await ref.read(registerUserProvider).call(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

  if (!mounted) return;

  if (user != null) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
      (route) => false,
    );
  }
} on FirebaseAuthException catch (error) {
  if (!mounted) return;

  String message;

  switch (error.code) {
    case 'email-already-in-use':
      message = 'An account already exists with this email.';
      break;
    case 'invalid-email':
      message = 'Please enter a valid email address.';
      break;
    case 'weak-password':
      message = 'Choose a stronger password with at least 6 characters.';
      break;
    case 'network-request-failed':
      message = 'Check your internet connection and try again.';
      break;
    default:
      message = error.message ?? 'Registration failed. Please try again.';
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
} catch (_) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Something went wrong. Please try again.'),
    ),
  );
} finally {
  if (mounted) {
    setState(() => _isLoading = false);
  }
}


}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: AppColors.background,
appBar: AppBar(
backgroundColor: AppColors.background,
iconTheme: const IconThemeData(color: Colors.white),
title: const Text(
'Sign Up',
style: TextStyle(color: Colors.white),
),
),
body: SafeArea(
child: Center(
child: SingleChildScrollView(
padding: const EdgeInsets.all(AppConstants.defaultPadding),
child: ConstrainedBox(
constraints: const BoxConstraints(maxWidth: 420),
child: Form(
key: _formKey,
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
const Text(
'Create Account',
style: TextStyle(
color: Colors.white,
fontSize: 28,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 8),
const Text(
'Join Netflix and discover your next favourite.',
style: TextStyle(
color: AppColors.textSecondary,
fontSize: 15,
),
),
const SizedBox(height: 28),
TextFormField(
controller: _emailController,
keyboardType: TextInputType.emailAddress,
style: const TextStyle(color: Colors.white),
decoration: _inputDecoration(
label: 'Email address',
icon: Icons.email_outlined,
),
validator: (value) {
final email = value?.trim() ?? '';


                    if (email.isEmpty) {
                      return 'Please enter your email.';
                    }

                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                        .hasMatch(email)) {
                      return 'Please enter a valid email.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(
                    label: 'Password',
                    icon: Icons.lock_outline,
                  ).copyWith(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password.';
                    }

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(
                    label: 'Confirm password',
                    icon: Icons.lock_outline,
                  ).copyWith(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password.';
                    }

                    if (value != _passwordController.text) {
                      return 'Passwords do not match.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius,
                        ),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
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

InputDecoration _inputDecoration({
required String label,
required IconData icon,
}) {
return InputDecoration(
labelText: label,
labelStyle: const TextStyle(color: AppColors.textSecondary),
prefixIcon: Icon(icon, color: AppColors.textSecondary),
filled: true,
fillColor: AppColors.surface,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(AppConstants.borderRadius),
borderSide: BorderSide.none,
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(AppConstants.borderRadius),
borderSide: BorderSide.none,
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(AppConstants.borderRadius),
borderSide: const BorderSide(color: AppColors.primary),
),
);
}
}
