import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class LoadingNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setLoading(bool value) {
    state = value;
  }
}

final loadingProvider =
NotifierProvider<LoadingNotifier, bool>(
  LoadingNotifier.new,
);