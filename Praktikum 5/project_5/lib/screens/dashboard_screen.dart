import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../services/auth_service.dart';
import '../widgets/formatters.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.onViewHistory});

  final VoidCallback onViewHistory;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  List<ExpenseTransaction> _recentTransactions = [];
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  double _balance = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final userId = AuthService().currentUser?.id;
    if (userId == null) return;

    try {
      final transactions = await _db.getTransactionsByUserId(userId);
      final income = await _db.getTotalIncome(userId);
      final expense = await _db.getTotalExpense(userId);
      final balance = await _db.getBalance(userId);

      if (mounted) {
        setState(() {
          _recentTransactions = transactions.take(3).toList();
          _totalIncome = income;
          _totalExpense = expense;
          _balance = balance;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading dashboard data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final userName = AuthService().displayName;
    final userEmail = AuthService().currentEmail ?? '';

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
        children: [
          Text(
            'Halo, $userName',
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 5),
          Text(
            userEmail,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF52ab98), Color(0xFF2b6777)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2b6777).withOpacity(0.20),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.account_balance_wallet_outlined, size: 20, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Total Saldo', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  formatRupiah(_balance),
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text('Ringkasan keuanganmu', style: TextStyle(color: Color(0xFFC8D8E4))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: 'Pemasukan',
                  value: formatRupiah(_totalIncome),
                  icon: Icons.south_west_rounded,
                  color: const Color(0xFF16865C),
                  background: const Color(0xFFE4F5EA),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  title: 'Pengeluaran',
                  value: formatRupiah(_totalExpense),
                  icon: Icons.north_east_rounded,
                  color: const Color(0xFFD94747),
                  background: const Color(0xFFFBE9E7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Transaksi Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              TextButton(
                onPressed: widget.onViewHistory,
                child: const Text('Lihat semua'),
              ),
            ],
          ),
          if (_recentTransactions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Text('Belum ada transaksi. Tekan tombol + untuk menambahkan.'),
            )
          else
            ..._recentTransactions.map((transaction) => _TransactionTile(transaction: transaction)),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.background,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: background,
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final ExpenseTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final color = transaction.isIncome ? const Color(0xFF16865C) : const Color(0xFFD94747);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: transaction.isIncome ? const Color(0xFFE4F5EA) : const Color(0xFFFBE9E7),
            child: Icon(
              transaction.isIncome ? Icons.south_west_rounded : Icons.north_east_rounded,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('${transaction.category} • ${formatDate(transaction.date)}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '${transaction.isIncome ? '+' : '-'}${formatRupiah(transaction.amount)}',
            style: TextStyle(fontWeight: FontWeight.w800, color: color, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
