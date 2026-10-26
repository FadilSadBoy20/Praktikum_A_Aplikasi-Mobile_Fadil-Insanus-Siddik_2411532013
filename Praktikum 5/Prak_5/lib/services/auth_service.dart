/// Simulasi autentikasi untuk latihan navigasi. Belum terhubung ke server.
class AuthService {
  AuthService._();

  static String? currentEmail;

  static void login(String email) {
    currentEmail = email.trim();
  }

  static void logout() {
    currentEmail = null;
  }

  static String get displayName {
    final email = currentEmail;
    if (email == null || email.isEmpty) return 'Pengguna';

    final username = email.split('@').first.replaceAll(RegExp(r'[._-]+'), ' ');
    if (username.trim().isEmpty) return 'Pengguna';
    return username
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}
