import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

// ==================== MODELS ====================

class User {
  final int? id;
  final String nama;
  final String email;
  final String phone;
  final String password;
  final DateTime createdAt;
  final DateTime? lastLogin;

  User({
    this.id,
    required this.nama,
    required this.email,
    required this.phone,
    required this.password,
    required this.createdAt,
    this.lastLogin,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'phone': phone,
      'password': password,
      'created_at': createdAt.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      nama: map['nama'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      password: map['password'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      lastLogin: map['last_login'] != null 
          ? DateTime.parse(map['last_login'] as String) 
          : null,
    );
  }

  User copyWith({
    int? id,
    String? nama,
    String? email,
    String? phone,
    String? password,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}

class ExpenseTransaction {
  final int? id;
  final int userId;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final bool isIncome;
  final DateTime createdAt;

  ExpenseTransaction({
    this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.isIncome,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'is_income': isIncome ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ExpenseTransaction.fromMap(Map<String, dynamic> map) {
    return ExpenseTransaction(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      title: map['title'] as String,
      amount: map['amount'] as double,
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      isIncome: (map['is_income'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  ExpenseTransaction copyWith({
    int? id,
    int? userId,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    bool? isIncome,
    DateTime? createdAt,
  }) {
    return ExpenseTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      isIncome: isIncome ?? this.isIncome,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// ==================== DATABASE ====================

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'expense_tracker.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            phone TEXT NOT NULL,
            password TEXT NOT NULL,
            created_at TEXT NOT NULL,
            last_login TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            category TEXT NOT NULL,
            date TEXT NOT NULL,
            is_income INTEGER NOT NULL,
            created_at TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
          )
        ''');

        await db.execute('CREATE INDEX idx_transactions_user_id ON transactions(user_id)');
        await db.execute('CREATE INDEX idx_transactions_date ON transactions(date)');
        await db.execute('CREATE UNIQUE INDEX idx_users_email ON users(email)');
      },
    );
  }

  // Hash password
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // ==================== USER OPERATIONS ====================

  Future<User?> insertUser(User user) async {
    try {
      final db = await database;
      
      final existingUser = await getUserByEmail(user.email);
      if (existingUser != null) {
        throw Exception('Email sudah terdaftar');
      }

      final hashedUser = user.copyWith(password: _hashPassword(user.password));
      final id = await db.insert('users', hashedUser.toMap(), conflictAlgorithm: ConflictAlgorithm.abort);
      return hashedUser.copyWith(id: id);
    } catch (e) {
      print('Error inserting user: $e');
      rethrow;
    }
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      final db = await database;
      final maps = await db.query('users', where: 'email = ?', whereArgs: [email], limit: 1);
      if (maps.isEmpty) return null;
      return User.fromMap(maps.first);
    } catch (e) {
      print('Error getting user by email: $e');
      return null;
    }
  }

  Future<User?> getUserById(int id) async {
    try {
      final db = await database;
      final maps = await db.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
      if (maps.isEmpty) return null;
      return User.fromMap(maps.first);
    } catch (e) {
      print('Error getting user by id: $e');
      return null;
    }
  }

  Future<User?> verifyCredentials(String email, String password) async {
    try {
      final user = await getUserByEmail(email);
      if (user == null) return null;
      
      final hashedPassword = _hashPassword(password);
      if (user.password == hashedPassword) {
        return user;
      }
      return null;
    } catch (e) {
      print('Error verifying credentials: $e');
      return null;
    }
  }

  Future<void> updateLastLogin(int userId) async {
    try {
      final db = await database;
      await db.update(
        'users',
        {'last_login': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      print('Error updating last login: $e');
    }
  }

  // ==================== TRANSACTION OPERATIONS ====================

  Future<ExpenseTransaction> insertTransaction(ExpenseTransaction transaction) async {
    try {
      final db = await database;
      final id = await db.insert('transactions', transaction.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      return transaction.copyWith(id: id);
    } catch (e) {
      print('Error inserting transaction: $e');
      rethrow;
    }
  }

  Future<List<ExpenseTransaction>> getTransactionsByUserId(int userId) async {
    try {
      final db = await database;
      final maps = await db.query(
        'transactions',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'date DESC, created_at DESC',
      );
      return maps.map((map) => ExpenseTransaction.fromMap(map)).toList();
    } catch (e) {
      print('Error getting transactions: $e');
      return [];
    }
  }

  Future<double> getTotalIncome(int userId) async {
    try {
      final db = await database;
      final result = await db.rawQuery(
        'SELECT SUM(amount) as total FROM transactions WHERE user_id = ? AND is_income = 1',
        [userId],
      );
      if (result.isEmpty || result.first['total'] == null) return 0.0;
      return (result.first['total'] as num).toDouble();
    } catch (e) {
      print('Error calculating total income: $e');
      return 0.0;
    }
  }

  Future<double> getTotalExpense(int userId) async {
    try {
      final db = await database;
      final result = await db.rawQuery(
        'SELECT SUM(amount) as total FROM transactions WHERE user_id = ? AND is_income = 0',
        [userId],
      );
      if (result.isEmpty || result.first['total'] == null) return 0.0;
      return (result.first['total'] as num).toDouble();
    } catch (e) {
      print('Error calculating total expense: $e');
      return 0.0;
    }
  }

  Future<double> getBalance(int userId) async {
    try {
      final income = await getTotalIncome(userId);
      final expense = await getTotalExpense(userId);
      return income - expense;
    } catch (e) {
      print('Error calculating balance: $e');
      return 0.0;
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      final db = await database;
      await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting transaction: $e');
      rethrow;
    }
  }
}
