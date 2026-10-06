import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Kabataku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const KalkulatorPage(),
    );
  }
}

class KalkulatorPage extends StatefulWidget {
  const KalkulatorPage({super.key});

  @override
  State<KalkulatorPage> createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage> {
  final TextEditingController _angka1Controller = TextEditingController();
  final TextEditingController _angka2Controller = TextEditingController();
  String _hasil = '';
  Color _hasilColor = Colors.grey;
  String _operasiTerakhir = '';

  void _hitung(String operasi) {
    // Validasi input kosong
    if (_angka1Controller.text.isEmpty || _angka2Controller.text.isEmpty) {
      setState(() {
        _hasil = 'Error: Mohon isi kedua angka!';
        _hasilColor = Colors.red;
        _operasiTerakhir = '';
      });
      return;
    }

    // Parse input
    final angka1 = double.tryParse(_angka1Controller.text);
    final angka2 = double.tryParse(_angka2Controller.text);

    // Validasi format angka
    if (angka1 == null || angka2 == null) {
      setState(() {
        _hasil = 'Error: Input harus berupa angka!';
        _hasilColor = Colors.red;
        _operasiTerakhir = '';
      });
      return;
    }

    double hasil;
    String simbol;

    switch (operasi) {
      case 'kali':
        hasil = angka1 * angka2;
        simbol = '×';
        _operasiTerakhir = 'Kali';
        break;
      case 'bagi':
        if (angka2 == 0) {
          setState(() {
            _hasil = 'Error: Tidak bisa membagi dengan 0!';
            _hasilColor = Colors.red;
            _operasiTerakhir = '';
          });
          return;
        }
        hasil = angka1 / angka2;
        simbol = '÷';
        _operasiTerakhir = 'Bagi';
        break;
      case 'tambah':
        hasil = angka1 + angka2;
        simbol = '+';
        _operasiTerakhir = 'Tambah';
        break;
      case 'kurang':
        hasil = angka1 - angka2;
        simbol = '-';
        _operasiTerakhir = 'Kurang';
        break;
      default:
        hasil = 0;
        simbol = '';
        _operasiTerakhir = '';
    }

    setState(() {
      // Tampilkan rumus lengkap
      if (hasil == hasil.toInt()) {
        _hasil = '$angka1 $simbol $angka2 = ${hasil.toInt()}';
      } else {
        _hasil = '$angka1 $simbol $angka2 = ${hasil.toStringAsFixed(2)}';
      }
      _hasilColor = Colors.deepPurple.shade900;
    });
  }

  void _reset() {
    _angka1Controller.clear();
    _angka2Controller.clear();
    setState(() {
      _hasil = '';
      _hasilColor = Colors.grey;
      _operasiTerakhir = '';
    });
  }

  @override
  void dispose() {
    _angka1Controller.dispose();
    _angka2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Kalkulator Kabataku',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
            onPressed: _reset,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Header dengan icon dan deskripsi
              const Icon(
                Icons.calculate_outlined,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 15),
              const Text(
                'Kalkulator Kabataku',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Ka-li Ba-gi Ta-mbah Ku-rang',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              // Input Angka
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.deepPurple.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _angka1Controller,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Angka Pertama',
                        hintText: 'Masukkan angka pertama',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.looks_one, color: Colors.deepPurple),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _angka2Controller,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Angka Kedua',
                        hintText: 'Masukkan angka kedua',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.looks_two, color: Colors.deepPurple),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Grid 2x2 untuk tombol operasi
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 2,
                children: [
                  // Tombol Kali
                  ElevatedButton(
                    onPressed: () => _hitung('kali'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade600,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close, size: 30),
                        SizedBox(height: 5),
                        Text(
                          'Kali',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tombol Bagi
                  ElevatedButton(
                    onPressed: () => _hitung('bagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.horizontal_rule, size: 30),
                        SizedBox(height: 5),
                        Text(
                          'Bagi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tombol Tambah
                  ElevatedButton(
                    onPressed: () => _hitung('tambah'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 30),
                        SizedBox(height: 5),
                        Text(
                          'Tambah',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tombol Kurang
                  ElevatedButton(
                    onPressed: () => _hitung('kurang'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.remove, size: 30),
                        SizedBox(height: 5),
                        Text(
                          'Kurang',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Display Hasil
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.deepPurple.shade300,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.shade100,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 40,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _operasiTerakhir.isEmpty ? 'Pilih Operasi' : 'Hasil $_operasiTerakhir',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _hasil.isEmpty ? 'Hasil akan muncul di sini' : _hasil,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _hasil.isEmpty ? Colors.grey : _hasilColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Footer
              const Text(
                'Kabataku = Kali × Bagi ÷ Tambah + Kurang -',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
