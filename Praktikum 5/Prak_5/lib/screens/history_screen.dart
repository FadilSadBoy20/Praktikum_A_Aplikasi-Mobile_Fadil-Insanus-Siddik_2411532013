import 'package:flutter/material.dart';

import '../data/transaction_store.dart';
import '../models/expense_transaction.dart';
import '../widgets/formatters.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = TransactionStore.instance;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final transactions = store.transactions;
        if (transactions.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 56, color: Colors.black38),
                  SizedBox(height: 12),
                  Text('Belum ada riwayat transaksi.', style: TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          itemCount: transactions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) => _HistoryTile(transaction: transactions[index]),
        );
      },
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.transaction});

  final ExpenseTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final color = transaction.isIncome ? const Color(0xFF2b6777) : const Color(0xFFD94747);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: transaction.isIncome ? const Color(0xFFc8d8e4) : const Color(0xFFFBE9E7),
            child: Icon(
              transaction.isIncome ? Icons.south_west_rounded : Icons.north_east_rounded,
              color: color,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 5),
                Text(transaction.category, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                const SizedBox(height: 3),
                Text(formatDate(transaction.date), style: const TextStyle(color: Colors.black45, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${transaction.isIncome ? '+' : '-'}${formatRupiah(transaction.amount)}',
            style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
