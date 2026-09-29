import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

class SignupScreen extends ConsumerWidget {
  SignupScreen({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 420,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  const Center(
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        color: Color(0xFFF8FAFC),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Center(
                    child: Text(
                      'Create your CampusMart account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  const Text(
                    'Name',
                    style: TextStyle(
                      color: Color(0xFFF8FAFC),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  _buildField(
                    controller: nameController,
                    hintText: 'Enter your name',
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Email',
                    style: TextStyle(
                      color: Color(0xFFF8FAFC),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  _buildField(
                    controller: emailController,
                    hintText: 'Enter your email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Password',
                    style: TextStyle(
                      color: Color(0xFFF8FAFC),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  _buildField(
                    controller: passwordController,
                    hintText: 'Enter your password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                        if (nameController.text
                            .trim()
                            .isEmpty ||
                            emailController.text
                                .trim()
                                .isEmpty ||
                            passwordController.text
                                .trim()
                                .isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please fill all fields',
                              ),
                            ),
                          );
                          return;
                        }

                        ref
                            .read(loadingProvider.notifier)
                            .setLoading(true);

                        try {
                          await ref
                              .read(
                            authControllerProvider,
                          )
                              .signup(
                            nameController.text.trim(),
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Account created. Please verify your email.',
                                ),
                              ),
                            );

                            Navigator.pop(context);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.toString(),
                                ),
                              ),
                            );
                          }
                        } finally {
                          ref
                              .read(
                            loadingProvider.notifier,
                          )
                              .setLoading(false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFF38BDF8),
                        foregroundColor:
                        const Color(0xFF0F172A),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF0F172A),
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

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: Color(0xFF334155),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () async {
                        ref
                            .read(loadingProvider.notifier)
                            .setLoading(true);

                        try {
                          await ref
                              .read(
                            authControllerProvider,
                          )
                              .googleLogin();

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.toString(),
                                ),
                              ),
                            );
                          }
                        } finally {
                          ref
                              .read(
                            loadingProvider.notifier,
                          )
                              .setLoading(false);
                        }
                      },
                      icon: const Icon(
                        Icons.g_mobiledata,
                        color: Color(0xFFF8FAFC),
                        size: 28,
                      ),
                      label: const Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Color(0xFFF8FAFC),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF334155),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Color(0xFFF8FAFC),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF94A3B8),
        ),
        prefixIcon: Icon(
          icon,
          color: Color(0xFF94A3B8),
        ),
        filled: true,
        fillColor: const Color(0xFF1F2937),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF334155),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF38BDF8),
          ),
        ),
      ),
    );
  }
}