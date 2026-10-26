import 'package:flutter/material.dart';

import '../data/transaction_store.dart';
import '../models/expense_transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  bool _isIncome = false;
  String _category = 'Makanan';
  DateTime _date = DateTime.now();

  List<String> get _categories => _isIncome
      ? const ['Gaji', 'Bonus', 'Investasi', 'Hadiah', 'Lainnya']
      : const ['Makanan', 'Transportasi', 'Belanja', 'Tagihan', 'Hiburan', 'Kesehatan', 'Lainnya'];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _chooseDate() async {
    final chosen = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Pilih tanggal transaksi',
    );
    if (chosen != null && mounted) setState(() => _date = chosen);
  }

  void _saveTransaction() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text.trim().replaceAll(',', '.'));
    final transaction = ExpenseTransaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      amount: amount,
      category: _category,
      date: _date,
      isIncome: _isIncome,
    );

    TransactionStore.instance.add(transaction);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi', style: TextStyle(fontWeight: FontWeight.w800))),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('Jenis Transaksi', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 12),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(
                    value: false,
                    label: Text('Pengeluaran'),
                    icon: Icon(Icons.north_east_rounded),
                  ),
                  ButtonSegment<bool>(
                    value: true,
                    label: Text('Pemasukan'),
                    icon: Icon(Icons.south_west_rounded),
                  ),
                ],
                selected: {_isIncome},
                onSelectionChanged: (selection) {
                  setState(() {
                    _isIncome = selection.first;
                    _category = _categories.first;
                  });
                },
              ),
              const SizedBox(height: 22),
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nama transaksi',
                  hintText: 'Contoh: Makan siang',
                  prefixIcon: Icon(Icons.edit_note_rounded),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama transaksi wajib diisi.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Jumlah (Rupiah)',
                  hintText: 'Contoh: 150000',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                validator: (value) {
                  final amount = double.tryParse((value ?? '').trim().replaceAll(',', '.'));
                  if (value == null || value.trim().isEmpty) return 'Jumlah wajib diisi.';
                  if (amount == null || amount <= 0) return 'Jumlah harus lebih besar dari 0.';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Kategori', prefixIcon: Icon(Icons.category_outlined)),
                items: _categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _category = value);
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _chooseDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal transaksi',
                    prefixIcon: Icon(Icons.calendar_month_outlined),
                  ),
                  child: Text('${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}/${_date.year}'),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _saveTransaction,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Simpan Transaksi', style: TextStyle(fontWeight: FontWeight.w800)),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF52ab98),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
