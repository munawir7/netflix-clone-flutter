import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netflix_clone/core/constants/app_constant.dart';
import 'package:netflix_clone/presentation/screens/auth/registor_screen.dart';

import '../../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';


class LoginScreen extends ConsumerStatefulWidget {
const LoginScreen({super.key});

@override
ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
final _formKey = GlobalKey<FormState>();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();

bool _obscurePassword = true;
bool _isLoading = false;

@override
void dispose() {
_emailController.dispose();
_passwordController.dispose();
super.dispose();
}

Future<void> _signIn() async {
if (!_formKey.currentState!.validate()) {
return;
}


setState(() {
  _isLoading = true;
});

try {
  final user = await ref.read(loginUserProvider).call(
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
    case 'invalid-email':
      message = 'Please enter a valid email address.';
      break;
    case 'user-not-found':
    case 'invalid-credential':
    case 'wrong-password':
      message = 'Invalid email or password.';
      break;
    case 'user-disabled':
      message = 'This account has been disabled.';
      break;
    case 'too-many-requests':
      message = 'Too many attempts. Please try again later.';
      break;
    case 'network-request-failed':
      message = 'Check your internet connection and try again.';
      break;
    default:
      message = error.message ?? 'Sign in failed. Please try again.';
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
    setState(() {
      _isLoading = false;
    });
  }
}


}
void _openRegisterScreen() {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const RegisterScreen(),
    ),
  );
}
@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: AppColors.background,
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
const SizedBox(height: 35),


                const Text(
                  'NETFLIX',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 45),

                const Text(
                  'Sign In',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
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
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  onFieldSubmitted: (_) {
                    if (!_isLoading) {
                      _signIn();
                    }
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(
                    label: 'Password',
                    icon: Icons.lock_outline,
                  ).copyWith(
                    suffixIcon: IconButton(
                      tooltip: _obscurePassword
                          ? 'Show password'
                          : 'Hide password',
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
                      return 'Please enter your password.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          AppColors.primary.withValues(alpha: 0.6),
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
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed:
                        _isLoading ? null : _openRegisterScreen,
                    child: const Text.rich(
                      TextSpan(
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(text: 'New to Netflix? '),
                          TextSpan(
                            text: 'Sign up now',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
labelStyle: const TextStyle(
color: AppColors.textSecondary,
),
prefixIcon: Icon(
icon,
color: AppColors.textSecondary,
),
filled: true,
fillColor: AppColors.surface,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(
AppConstants.borderRadius,
),
borderSide: BorderSide.none,
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(
AppConstants.borderRadius,
),
borderSide: BorderSide.none,
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(
AppConstants.borderRadius,
),
borderSide: const BorderSide(
color: AppColors.primary,
),
),
);
}
}
