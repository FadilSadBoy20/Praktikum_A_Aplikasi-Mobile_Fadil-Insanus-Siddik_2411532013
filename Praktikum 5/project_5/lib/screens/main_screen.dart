import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'dashboard_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Key _dashboardKey = UniqueKey();
  Key _historyKey = UniqueKey();

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _logout() async {
    await AuthService().logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  Future<void> _navigateToAddTransaction() async {
    final result = await Navigator.pushNamed(context, '/add');
    
    // Refresh dashboard and history if transaction was added
    if (result == true && mounted) {
      setState(() {
        _dashboardKey = UniqueKey(); // Force rebuild dashboard
        _historyKey = UniqueKey();   // Force rebuild history
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const titles = ['Dashboard', 'Riwayat Transaksi', 'Profil'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex], style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DashboardScreen(
            key: _dashboardKey,
            onViewHistory: () => _onItemTapped(1),
          ),
          HistoryScreen(key: _historyKey),
          ProfileScreen(onLogout: _logout),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF2b6777),
              foregroundColor: Colors.white,
              tooltip: 'Tambah transaksi',
              onPressed: _navigateToAddTransaction,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF2b6777),
        unselectedItemColor: Colors.blueGrey.shade400,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}
