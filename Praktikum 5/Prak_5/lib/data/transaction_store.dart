import 'package:flutter/foundation.dart';

import '../models/expense_transaction.dart';

/// Penyimpanan sederhana di memori agar contoh dapat dijalankan tanpa backend.
class TransactionStore extends ChangeNotifier {
  TransactionStore._() {
    final now = DateTime.now();
    _transactions.addAll([
      ExpenseTransaction(
        id: 'demo-1',
        title: 'Gaji bulanan',
        amount: 63000000000,
        category: 'Gaji',
        date: DateTime(now.year, now.month, now.day, 9),
        isIncome: true,
      ),
      ExpenseTransaction(
        id: 'demo-2',
        title: 'Belanja kebutuhan',
        amount: 235000,
        category: 'Belanja',
        date: DateTime(now.year, now.month, now.day - 1, 16),
        isIncome: false,
      ),
      ExpenseTransaction(
        id: 'demo-3',
        title: 'Makan siang',
        amount: 24000,
        category: 'Makanan',
        date: DateTime(now.year, now.month, now.day - 2, 12),
        isIncome: false,
      ),
    ]);
  }

  static final TransactionStore instance = TransactionStore._();

  final List<ExpenseTransaction> _transactions = [];

  List<ExpenseTransaction> get transactions {
    final copy = List<ExpenseTransaction>.from(_transactions);
    copy.sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(copy);
  }

  double get totalIncome => _transactions
      .where((transaction) => transaction.isIncome)
      .fold(0, (sum, transaction) => sum + transaction.amount);

  double get totalExpense => _transactions
      .where((transaction) => !transaction.isIncome)
      .fold(0, (sum, transaction) => sum + transaction.amount);

  double get balance => totalIncome - totalExpense;

  void add(ExpenseTransaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }
}
