import 'package:flutter/material.dart';
import 'package:tumpeng/core/theme/app_theme.dart';
import 'package:tumpeng/features/auth/auth_form_page.dart';
import 'package:tumpeng/features/onboarding/user_role.dart';

class AuthLandingPage extends StatelessWidget {
  const AuthLandingPage({super.key, required this.role});
  final UserRole role;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'TUMPENG',
        style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.2),
      ),
    ),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              children: [
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    role == UserRole.hero
                        ? Icons.favorite_outline
                        : Icons.storefront_outlined,
                    size: 48,
                    color: AppColors.green,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Selamat datang, ${role.label}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGreen,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  role == UserRole.hero
                      ? 'Masuk atau buat akun untuk mulai menemukan sajian favoritmu.'
                      : 'Masuk atau buat akun untuk mengelola etalase dan pesanan tokomu.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: AppColors.secondaryText, height: 1.45),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: () => _openForm(context, isRegister: true),
                  child: const Text('Buat akun'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => _openForm(context, isRegister: false),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: AppColors.green,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Masuk'),
                ),
                const SizedBox(height: 20),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('atau'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () =>
                      _openForm(context, isRegister: false, googleOnly: true),
                  icon: const Icon(Icons.account_circle_outlined),
                  label: const Text('Lanjutkan dengan Google'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: AppColors.darkGreen,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  void _openForm(
    BuildContext context, {
    required bool isRegister,
    bool googleOnly = false,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AuthFormPage(
          role: role,
          isRegister: isRegister,
          googleOnly: googleOnly,
        ),
      ),
    );
  }
}
