import 'package:flutter/material.dart';
import 'package:tumpeng/core/theme/app_theme.dart';
import 'package:tumpeng/features/onboarding/user_role.dart';
import 'package:tumpeng/features/qr/qr_code_view.dart';
import 'package:tumpeng/features/qr/qr_scanner_page.dart';

Widget dashboardForRole(UserRole role) => switch (role) {
  UserRole.hero => const HeroDashboardPage(),
  UserRole.mitra => const MitraDashboardPage(),
};

class HeroDashboardPage extends StatelessWidget {
  const HeroDashboardPage({super.key});

  @override
  Widget build(BuildContext context) => _DashboardScaffold(
    role: UserRole.hero,
    greeting: 'Mau makan apa hari ini?',
    subtitle: 'Temukan pilihan lezat untuk momen bersama.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          readOnly: true,
          onTap: () => _showComingSoon(context, 'Pencarian menu'),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Cari menu atau mitra',
          ),
        ),
        const SizedBox(height: 24),
        const _SectionTitle(title: 'Pilihan untukmu', action: 'Lihat semua'),
        const SizedBox(height: 12),
        const _DashboardCard(
          icon: Icons.rice_bowl_outlined,
          title: 'Menu pilihan hari ini',
          description: 'Jelajahi hidangan dari mitra kuliner.',
        ),
        const SizedBox(height: 12),
        const _DashboardCard(
          icon: Icons.receipt_long_outlined,
          title: 'Pesananmu',
          description: 'Pesanan yang kamu buat akan muncul di sini.',
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const QrScannerPage()),
          ),
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Pindai kode QR'),
          style: _outlineButtonStyle,
        ),
      ],
    ),
  );
}

class MitraDashboardPage extends StatelessWidget {
  const MitraDashboardPage({super.key});

  @override
  Widget build(BuildContext context) => _DashboardScaffold(
    role: UserRole.mitra,
    greeting: 'Halo, Mitra!',
    subtitle: 'Kelola menu dan pesanan tokomu di sini.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Expanded(
              child: _MetricCard(
                label: 'Pesanan baru',
                value: '—',
                icon: Icons.notifications_none,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                label: 'Menu aktif',
                value: '—',
                icon: Icons.rice_bowl_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const _SectionTitle(title: 'Kelola tokomu'),
        const SizedBox(height: 12),
        const _DashboardCard(
          icon: Icons.receipt_long_outlined,
          title: 'Pesanan masuk',
          description: 'Pesanan pelanggan akan muncul di sini.',
        ),
        const SizedBox(height: 12),
        const _DashboardCard(
          icon: Icons.restaurant_menu_outlined,
          title: 'Menu dan ketersediaan',
          description: 'Atur hidangan yang ingin kamu tampilkan.',
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'QR toko',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 12),
                const QrCodeView(
                  data: 'https://tumpeng.example/mitra/toko',
                  size: 140,
                ),
                const SizedBox(height: 8),
                const Text(
                  'QR contoh. Hubungkan profil toko untuk membuat QR aktif.',
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _DashboardScaffold extends StatelessWidget {
  const _DashboardScaffold({
    required this.role,
    required this.greeting,
    required this.subtitle,
    required this.child,
  });
  final UserRole role;
  final String greeting;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'TUMPENG',
        style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.2),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Chip(
              label: Text(role.label),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
      ],
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          Text(
            greeting,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.darkGreen,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.action});
  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.darkGreen,
          ),
        ),
      ),
      if (action != null)
        TextButton(
          onPressed: () => _showComingSoon(context, action!),
          child: Text(action!),
        ),
    ],
  );
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.description,
  });
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: AppColors.green.withValues(alpha: 0.08),
        child: Icon(icon, color: AppColors.green),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(description),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showComingSoon(context, title),
    ),
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.green),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.darkGreen,
            ),
          ),
          Text(label, style: const TextStyle(color: AppColors.secondaryText)),
        ],
      ),
    ),
  );
}

void _showComingSoon(BuildContext context, String feature) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('$feature akan tersedia setelah API produk terhubung.'),
      ),
    );
}

final _outlineButtonStyle = OutlinedButton.styleFrom(
  foregroundColor: AppColors.green,
  minimumSize: const Size.fromHeight(48),
  side: const BorderSide(color: AppColors.border),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);
