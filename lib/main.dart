import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'views/home_screen.dart';
import 'views/login_screen.dart';
import 'views/verify_email_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: CampusMart(),
    ),
  );
}

class CampusMart extends ConsumerWidget {
  const CampusMart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusMart',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF38BDF8),
          brightness: Brightness.dark,
        ),
      ),
      home: authState.when(
        data: (user) {
          if (user == null) {
            return LoginScreen();
          }

          if (!user.emailVerified) {
            return const VerifyEmailScreen();
          }

          return const HomeScreen();
        },
        loading: () => const Scaffold(
          backgroundColor: Color(0xFF0F172A),
          body: Center(
            child: CircularProgressIndicator(
              color: Color(0xFF38BDF8),
            ),
          ),
        ),
        error: (error, stack) => Scaffold(
          backgroundColor: const Color(0xFF0F172A),
          body: Center(
            child: Text(
              error.toString(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}