import 'package:shared_preferences/shared_preferences.dart';
import '../database_helper.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final DatabaseHelper _db = DatabaseHelper();
  User? _currentUser;

  static const String _keyUserId = 'user_id';
  static const String _keyIsLoggedIn = 'is_logged_in';

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  String? get currentEmail => _currentUser?.email;

  String get displayName {
    if (_currentUser == null) return 'Pengguna';
    return _currentUser!.nama;
  }

  Future<bool> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt(_keyUserId);
      final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;

      if (userId != null && isLoggedIn) {
        _currentUser = await _db.getUserById(userId);
        return _currentUser != null;
      }
      return false;
    } catch (e) {
      print('Error initializing auth service: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> register({
    required String nama,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      if (nama.trim().isEmpty) {
        return {'success': false, 'message': 'Nama tidak boleh kosong'};
      }
      if (email.trim().isEmpty || !_isValidEmail(email)) {
        return {'success': false, 'message': 'Email tidak valid'};
      }
      if (phone.trim().isEmpty || !_isValidPhone(phone)) {
        return {'success': false, 'message': 'Nomor telepon tidak valid'};
      }
      if (password.length < 8) {
        return {'success': false, 'message': 'Password minimal 8 karakter'};
      }

      final existingUser = await _db.getUserByEmail(email);
      if (existingUser != null) {
        return {'success': false, 'message': 'Email sudah terdaftar'};
      }

      final newUser = User(
        nama: nama.trim(),
        email: email.trim().toLowerCase(),
        phone: phone.trim(),
        password: password,
        createdAt: DateTime.now(),
      );

      final insertedUser = await _db.insertUser(newUser);
      if (insertedUser == null) {
        return {'success': false, 'message': 'Gagal mendaftar, coba lagi'};
      }

      await _saveSession(insertedUser);
      _currentUser = insertedUser;

      return {'success': true, 'message': 'Registrasi berhasil', 'user': insertedUser};
    } catch (e) {
      print('Error during registration: $e');
      return {'success': false, 'message': 'Terjadi kesalahan: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      if (email.trim().isEmpty) {
        return {'success': false, 'message': 'Email tidak boleh kosong'};
      }
      if (password.isEmpty) {
        return {'success': false, 'message': 'Password tidak boleh kosong'};
      }

      final user = await _db.verifyCredentials(email.trim().toLowerCase(), password);

      if (user == null) {
        return {'success': false, 'message': 'Email atau password salah'};
      }

      await _db.updateLastLogin(user.id!);
      await _saveSession(user);
      _currentUser = user;

      return {'success': true, 'message': 'Login berhasil', 'user': user};
    } catch (e) {
      print('Error during login: $e');
      return {'success': false, 'message': 'Terjadi kesalahan: ${e.toString()}'};
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyUserId);
      await prefs.setBool(_keyIsLoggedIn, false);
      _currentUser = null;
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  Future<void> _saveSession(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyUserId, user.id!);
      await prefs.setBool(_keyIsLoggedIn, true);
    } catch (e) {
      print('Error saving session: $e');
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final phoneRegex = RegExp(r'^(\+62|62|0)[0-9]{9,12}$');
    return phoneRegex.hasMatch(cleanPhone);
  }

  Future<void> refreshCurrentUser() async {
    if (_currentUser != null && _currentUser!.id != null) {
      _currentUser = await _db.getUserById(_currentUser!.id!);
    }
  }
}
