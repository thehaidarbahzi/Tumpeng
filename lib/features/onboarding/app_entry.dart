import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumpeng/features/auth/auth_landing_page.dart';
import 'package:tumpeng/features/onboarding/onboarding_flow.dart';
import 'package:tumpeng/features/onboarding/user_role.dart';

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  static const _seenIntroKey = 'onboarding.seen_intro';
  static const _roleKey = 'onboarding.role';

  bool _loading = true;
  UserRole? _savedRole;

  @override
  void initState() {
    super.initState();
    _loadEntryState();
  }

  Future<void> _loadEntryState() async {
    final preferences = await SharedPreferences.getInstance();
    final hasSeenIntro = preferences.getBool(_seenIntroKey) ?? false;
    final role = UserRole.fromStorage(preferences.getString(_roleKey));
    if (!mounted) return;
    setState(() {
      _savedRole = hasSeenIntro ? role : null;
      _loading = false;
    });
  }

  Future<void> _completeOnboarding(UserRole role) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_seenIntroKey, true);
    await preferences.setString(_roleKey, role.name);
    if (!mounted) return;
    setState(() => _savedRole = role);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final role = _savedRole;
    if (role != null) return AuthLandingPage(role: role);
    return OnboardingFlow(onComplete: _completeOnboarding);
  }
}
