import '../services/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<void> login(
      String email,
      String password,
      ) {
    return _authService.login(email, password);
  }

  Future<void> signup(
      String name,
      String email,
      String password,
      ) {
    return _authService.signup(
      name,
      email,
      password,
    );
  }

  Future<void> googleLogin() {
    return _authService.googleLogin();
  }

  Future<void> logout() {
    return _authService.logout();
  }
}