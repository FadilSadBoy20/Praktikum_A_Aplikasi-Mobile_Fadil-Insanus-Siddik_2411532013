# Expense Tracker - Gabungan Praktikum 1-5 (Optimized)

Aplikasi manajemen keuangan pribadi dengan fitur lengkap termasuk autentikasi, database SQLite, dan UI/UX modern.

## 📱 Fitur Utama

### ✅ Authentication System
- **Register**: Nama, Email, Phone, Password, Confirm Password
- **Login**: Email & Password
- **Session Management**: Auto-login dengan SharedPreferences
- **Password Security**: Hash dengan SHA-256

### 💾 Data Persistence
- **SQLite Database** untuk menyimpan data user dan transaksi
- **Data Isolation**: Setiap user hanya bisa akses transaksi miliknya
- **Relational Database**: Foreign key relationship

### 🏠 Dashboard
- Saldo total dengan gradient card
- Summary pemasukan & pengeluaran
- 3 transaksi terbaru
- Pull-to-refresh

### 📜 Riwayat Transaksi
- Daftar lengkap semua transaksi
- Sorted by date (terbaru dulu)
- Pull-to-refresh

### 👤 Profile
- Avatar dengan initial nama
- Info lengkap: Nama, Email, No. Telepon
- Logout dengan confirmation dialog

### ➕ Tambah Transaksi
- Segmented button (Pemasukan/Pengeluaran)
- Form: Nama, Jumlah, Kategori, Tanggal
- Auto-refresh setelah tambah

## 📂 Struktur Project (SIMPLIFIED - 12 Files)

```
lib/
├── database_helper.dart           # ✅ Database + Models (All-in-one)
├── main.dart                      # Entry point + Routes
├── services/
│   └── auth_service.dart          # Authentication service
├── screens/                       # 7 screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── main_screen.dart
│   ├── dashboard_screen.dart
│   ├── history_screen.dart
│   ├── profile_screen.dart
│   └── add_transaction_screen.dart
└── widgets/
    └── formatters.dart            # Format utilities
```

## 🎯 Optimisasi yang Dilakukan

### ❌ Sebelum (18 files):
```
lib/
├── constants/app_colors.dart
├── database/
│   ├── database_helper.dart
│   ├── user_database.dart
│   └── transaction_database.dart
├── models/
│   ├── user.dart
│   └── expense_transaction.dart
├── services/auth_service.dart
├── screens/ (8 files)
└── widgets/formatters.dart
```

### ✅ Sesudah (12 files):
```
lib/
├── database_helper.dart          # Gabungan 5 files (database + models)
├── main.dart
├── services/auth_service.dart
├── screens/ (8 files)            # Inline colors, no constants
└── widgets/formatters.dart
```

**Pengurangan: 18 → 12 files (33% lebih sedikit!)**

## 🔧 Perubahan Detail

1. **Gabungkan Database + Models** (5 files → 1 file)
   - `database_helper.dart` sekarang berisi:
     - DatabaseHelper (singleton)
     - User model + operations
     - ExpenseTransaction model + operations
     - Password hashing

2. **Hapus Constants Folder**
   - Semua warna sekarang inline di setiap screen
   - Lebih mudah di-maintain per screen
   - Tidak perlu import tambahan

3. **Update All Imports**
   - Semua screen sekarang import `../database_helper.dart`
   - Tidak ada import constants
   - Import lebih clean dan minimal

## 🗄️ Database Schema

### Table: users
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nama TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  phone TEXT NOT NULL,
  password TEXT NOT NULL,
  created_at TEXT NOT NULL,
  last_login TEXT
)
```

### Table: transactions
```sql
CREATE TABLE transactions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  amount REAL NOT NULL,
  category TEXT NOT NULL,
  date TEXT NOT NULL,
  is_income INTEGER NOT NULL,
  created_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id)
)
```

## 🚀 Cara Menjalankan

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run aplikasi**:
   ```bash
   flutter run
   ```

3. **Build APK** (opsional):
   ```bash
   flutter build apk --release
   ```

## 📱 Flow Aplikasi

```
App Start → Splash Screen (2s)
              ↓
        [Check Session]
              ↓
      ┌───────┴────────┐
      ↓                ↓
  Not Logged       Logged In
      ↓                ↓
  Login Screen    Main Screen
      ↓
  Register Screen
      ↓
  [Auto Login]
      ↓
  Main Screen (BottomNav: Dashboard, History, Profile)
```

## ✨ Fitur Bonus

- ✅ Session management (auto-login)
- ✅ Password hashing (SHA-256)
- ✅ Multi-user support
- ✅ Pull-to-refresh
- ✅ Loading indicators
- ✅ Success/Error messages
- ✅ Form validation real-time
- ✅ Format Rupiah & tanggal
- ✅ Logout confirmation dialog

## 🔒 Keamanan

- Password di-hash dengan SHA-256
- Session management dengan SharedPreferences
- Email unique validation
- SQL injection prevention (parameterized queries)
- User data isolation

## 🎯 Pemenuhan Persyaratan Tugas

| Persyaratan | Status | Detail |
|------------|--------|--------|
| **1. Local Storage SQLite** | ✅ | 2 tabel dengan foreign key |
| **2. Form Login** | ✅ | Email + Password |
| **3. Form Register** | ✅ | 5 fields lengkap |
| **4. Data disimpan lokal** | ✅ | SQLite + password hashing |
| **5. Pertahankan UI/UX existing** | ✅ | Dashboard, History, Profile sama |
| **6. Redesign Login & Register** | ✅ | Modern gradient design |
| **7. Code Optimization** | ✅ | 18 files → 12 files (33% reduction) |

## 📊 Statistics

- **Total Files**: 12 dart files (down from 18)
- **Lines of Code**: ~1,500 lines
- **Dependencies**: 5 packages (sqflite, crypto, shared_preferences, intl, path)
- **Screens**: 8 screens
- **Database Tables**: 2 tables with indexes
- **Models**: 2 models (User, ExpenseTransaction)

---

**Version**: 2.0.0 (Optimized)
**Last Updated**: 26 Oktober 2026
**Status**: Production Ready ✅
