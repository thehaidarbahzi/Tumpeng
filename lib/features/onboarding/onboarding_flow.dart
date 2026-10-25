import 'package:flutter/material.dart';
import 'package:tumpeng/core/theme/app_theme.dart';
import 'package:tumpeng/features/onboarding/role_onboarding_page.dart';
import 'package:tumpeng/features/onboarding/user_role.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({
    super.key,
    required this.onComplete,
    this.initialPage = 0,
  });

  final Future<void> Function(UserRole) onComplete;
  final int initialPage;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  late final PageController _controller;
  late int _page;
  UserRole? _selectedRole;

  static const _pages = [
    _IntroContent(
      icon: Icons.rice_bowl_rounded,
      eyebrow: 'SELAMAT DATANG DI TUMPENG',
      title: 'Rasa Nusantara,\nuntuk bersama.',
      description: 'Temukan sajian istimewa untuk momen sehari-hari dan perayaan bersama orang tersayang.',
    ),
    _IntroContent(
      icon: Icons.explore_outlined,
      eyebrow: 'PILIHAN YANG DEKAT',
      title: 'Temukan menu\nfavoritmu.',
      description: 'Jelajahi pilihan tumpeng dan hidangan dari para mitra kuliner di sekitarmu.',
    ),
    _IntroContent(
      icon: Icons.diversity_3_outlined,
      eyebrow: 'SATU APLIKASI, DUA PERAN',
      title: 'Kamu ingin bergabung\nsebagai siapa?',
      description:
          'Pilih peran untuk melihat pengalaman yang paling sesuai untukmu.',
      rolePicker: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _page = widget.initialPage.clamp(0, 2).toInt();
    _controller = PageController(initialPage: _page);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _chooseRole(UserRole role) {
    setState(() => _selectedRole = role);
  }

  void _continue() {
    if (_page < 2) {
      _goTo(_page + 1);
      return;
    }
    final role = _selectedRole;
    if (role == null) return;
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            builder: (_) =>
                RoleOnboardingPage(role: role, onComplete: widget.onComplete),
          ),
        )
        .then((_) {
          if (mounted) setState(() => _selectedRole = null);
        });
  }

  @override
  Widget build(BuildContext context) {
    final isRolePicker = _page == 2;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  const Icon(Icons.rice_bowl_rounded, color: AppColors.green),
                  const SizedBox(width: 8),
                  const Text(
                    'TUMPENG',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_page + 1} / 3',
                    style: const TextStyle(color: AppColors.secondaryText),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _pages.length,
                onPageChanged: (page) => setState(() => _page = page),
                itemBuilder: (context, index) => _IntroPage(
                  content: _pages[index],
                  selectedRole: _selectedRole,
                  onSelectRole: _chooseRole,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => _PageDot(active: index == _page),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      if (_page > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _goTo(_page - 1),
                            style: _secondaryButtonStyle,
                            child: const Text('Kembali'),
                          ),
                        ),
                      if (_page > 0) const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isRolePicker && _selectedRole == null
                              ? null
                              : _continue,
                          child: Text(
                            isRolePicker ? 'Lanjutkan' : 'Berikutnya',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroContent {
  const _IntroContent({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.description,
    this.rolePicker = false,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final String description;
  final bool rolePicker;
}

class _IntroPage extends StatelessWidget {
  const _IntroPage({
    required this.content,
    required this.selectedRole,
    required this.onSelectRole,
  });

  final _IntroContent content;
  final UserRole? selectedRole;
  final ValueChanged<UserRole> onSelectRole;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight - 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 184,
              height: 184,
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.circle, size: 128, color: AppColors.gold),
                  Icon(content.icon, size: 68, color: AppColors.green),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              content.eyebrow,
              style: const TextStyle(
                color: AppColors.green,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.darkGreen,
                fontWeight: FontWeight.w700,
                height: 1.18,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: AppColors.secondaryText, height: 1.5),
            ),
            if (content.rolePicker) ...[
              const SizedBox(height: 24),
              _RoleChoiceCard(
                role: UserRole.hero,
                icon: Icons.favorite_outline,
                title: 'Hero',
                subtitle: 'Saya ingin mencari dan memesan makanan',
                selected: selectedRole == UserRole.hero,
                onTap: () => onSelectRole(UserRole.hero),
              ),
              const SizedBox(height: 12),
              _RoleChoiceCard(
                role: UserRole.mitra,
                icon: Icons.storefront_outlined,
                title: 'Mitra',
                subtitle: 'Saya ingin menjual dan mengelola pesanan',
                selected: selectedRole == UserRole.mitra,
                onTap: () => onSelectRole(UserRole.mitra),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class _RoleChoiceCard extends StatelessWidget {
  const _RoleChoiceCard({
    required this.role,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final UserRole role;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: '$title, $subtitle',
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.green.withValues(alpha: 0.06)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.green : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.green, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title · ${role.roleLabel}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.secondaryText),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.green : AppColors.secondaryText,
            ),
          ],
        ),
      ),
    ),
  );
}

class _PageDot extends StatelessWidget {
  const _PageDot({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 180),
    margin: const EdgeInsets.symmetric(horizontal: 4),
    width: active ? 24 : 8,
    height: 8,
    decoration: BoxDecoration(
      color: active ? AppColors.green : AppColors.border,
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

const _secondaryButtonStyle = ButtonStyle(
  minimumSize: WidgetStatePropertyAll(Size.fromHeight(48)),
  foregroundColor: WidgetStatePropertyAll(AppColors.green),
  side: WidgetStatePropertyAll(BorderSide(color: AppColors.border)),
);
