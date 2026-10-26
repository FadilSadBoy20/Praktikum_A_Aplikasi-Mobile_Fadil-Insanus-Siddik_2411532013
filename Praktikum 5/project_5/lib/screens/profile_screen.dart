import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/formatters.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    
    if (user == null) {
      return const Center(child: Text('Data user tidak ditemukan'));
    }

    final name = user.nama;
    final email = user.email;
    final phone = user.phone;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'P';

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 52,
                backgroundColor: const Color(0xFF52ab98),
                child: Text(
                  initial,
                  style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 5),
              Text(email, style: const TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text('Informasi Profil', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        _ProfileInfoTile(icon: Icons.person_outline, label: 'Nama', value: name),
        const SizedBox(height: 10),
        _ProfileInfoTile(icon: Icons.email_outlined, label: 'Email', value: email),
        const SizedBox(height: 10),
        _ProfileInfoTile(icon: Icons.phone_outlined, label: 'No. Telepon', value: formatPhoneNumber(phone)),
        const SizedBox(height: 26),
        OutlinedButton.icon(
          onPressed: () => _showLogoutDialog(context),
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Logout'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFC62828),
            side: const BorderSide(color: Color(0xFFE6B7B7)),
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari aplikasi?'),
        content: const Text('Kamu perlu login kembali untuk membuka halaman utama.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onLogout();
            },
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFC62828)),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2b6777)),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
