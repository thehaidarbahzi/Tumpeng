import 'package:flutter/material.dart';
import 'package:tumpeng/core/theme/app_theme.dart';
import 'package:tumpeng/features/onboarding/user_role.dart';

class RoleOnboardingPage extends StatefulWidget {
  const RoleOnboardingPage({
    super.key,
    required this.role,
    required this.onComplete,
  });

  final UserRole role;
  final Future<void> Function(UserRole) onComplete;

  @override
  State<RoleOnboardingPage> createState() => _RoleOnboardingPageState();
}

class _RoleOnboardingPageState extends State<RoleOnboardingPage> {
  final _controller = PageController();
  int _page = 0;
  bool _saving = false;

  List<_RoleIntro> get _pages => widget.role == UserRole.hero
      ? const [
          _RoleIntro(
            Icons.search_rounded,
            'TEMUKAN YANG KAMU SUKA',
            'Temukan menu untuk momenmu.',
            'Jelajahi sajian tumpeng dan hidangan dari mitra kuliner pilihan.',
          ),
          _RoleIntro(
            Icons.shopping_bag_outlined,
            'PESAN DENGAN MUDAH',
            'Atur pesanan dalam beberapa langkah.',
            'Pilih menu, tentukan jumlah, lalu pantau pesananmu dari satu tempat.',
          ),
          _RoleIntro(
            Icons.celebration_outlined,
            'NIKMATI BERSAMA',
            'Momen spesial jadi lebih dekat.',
            'Pesan hidangan untuk keluarga, teman, atau acara yang berarti.',
          ),
        ]
      : const [
          _RoleIntro(
            Icons.storefront_outlined,
            'KENALKAN USAHAMU',
            'Tampilkan menu andalanmu.',
            'Buat etalase yang rapi agar pelanggan mudah menemukan sajianmu.',
          ),
          _RoleIntro(
            Icons.receipt_long_outlined,
            'PESANAN LEBIH TERTATA',
            'Kelola pesanan dari satu tempat.',
            'Lihat pesanan masuk dan siapkan hidangan dengan alur yang jelas.',
          ),
          _RoleIntro(
            Icons.trending_up_rounded,
            'TUMBUH BERSAMA',
            'Jangkau lebih banyak pelanggan.',
            'Bagikan sajian terbaikmu dan bangun hubungan dengan pelanggan.',
          ),
        ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_page < 2) {
      await _controller.nextPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    setState(() => _saving = true);
    await widget.onComplete(widget.role);
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _goBack() {
    if (_page == 0) {
      Navigator.of(context).pop();
    } else {
      _controller.previousPage(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) => PopScope<void>(
    canPop: _page == 0,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop && _page > 0) _goBack();
    },
    child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: _page == 0
              ? 'Kembali ke pilihan peran'
              : 'Halaman sebelumnya',
          onPressed: _goBack,
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('${widget.role.label} · ${widget.role.roleLabel}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                '${_page + 1} / 3',
                style: const TextStyle(color: AppColors.secondaryText),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _pages.length,
                onPageChanged: (page) => setState(() => _page = page),
                itemBuilder: (context, index) =>
                    _RoleIntroView(content: _pages[index], role: widget.role),
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
                      (index) => _Dot(active: index == _page),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saving ? null : _continue,
                    child: _saving
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _page == 2
                                ? 'Mulai sebagai ${widget.role.label}'
                                : 'Berikutnya',
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _RoleIntro {
  const _RoleIntro(this.icon, this.eyebrow, this.title, this.description);
  final IconData icon;
  final String eyebrow;
  final String title;
  final String description;
}

class _RoleIntroView extends StatelessWidget {
  const _RoleIntroView({required this.content, required this.role});
  final _RoleIntro content;
  final UserRole role;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
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
        const SizedBox(height: 32),
        Text(
          '${content.eyebrow} · ${role.label.toUpperCase()}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.green,
            letterSpacing: 1.1,
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
      ],
    ),
  );
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});
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
