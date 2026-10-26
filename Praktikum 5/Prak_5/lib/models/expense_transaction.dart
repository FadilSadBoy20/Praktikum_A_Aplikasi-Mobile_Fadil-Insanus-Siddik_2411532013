class ExpenseTransaction {
  const ExpenseTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.isIncome,
  });

  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final bool isIncome;
}
