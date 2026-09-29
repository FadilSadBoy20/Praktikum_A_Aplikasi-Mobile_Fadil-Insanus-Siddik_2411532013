import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  // GlobalKey untuk mengontrol form dan menemukan validasi
  final _formKey = GlobalKey<FormState>();

  // Controller untuk menampilkan teks dari input
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController(); // Controller untuk Tanggal

  // State untuk Dropdown
  String _selectedCategory = 'Makanan';
  final List<String> _categories = ['Makanan', 'Transportasi', 'Hiburan', 'Lainnya'];

  @override
  void dispose() {
    // Dispose controller saat halaman ditutup untuk mencegah memory leak
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catat Transaksi Baru'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      // SingleChildScrollView mencegah error layout saat keyboard muncul
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input 1: Judul Transaksi
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Transaksi',
                  hintText: 'Contoh: Beli Makanan',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul transaksi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Input 2: Nominal Saldo (Keyboard Angka)
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nominal (Rp)',
                  hintText: 'Masukkan jumlah nominal',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nominal wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Input 3: Kategori Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Input 4: Tanggal Transaksi (dengan DatePicker)
              TextFormField(
                controller: _dateController,
                readOnly: true, // Agar tidak bisa diketik manual
                decoration: InputDecoration(
                  labelText: 'Tanggal Transaksi',
                  hintText: 'DD/MM/YYYY',
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.deepPurple),
                    onPressed: () async {
                      // Membuka dialog date picker
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        // Format tanggal menjadi DD/MM/YYYY
                        String formattedDate =
                            '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
                        setState(() {
                          _dateController.text = formattedDate;
                        });
                      }
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              // Tombol Simpan
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Jika lolos validasi, tampilkan pop-up snackbar sukses
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Tersimpan: ${_titleController.text} (Rp ${_amountController.text}) - ${_dateController.text}',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Simpan Transaksi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}