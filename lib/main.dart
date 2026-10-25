import 'package:flutter/material.dart';
import 'package:tumpeng/core/theme/app_theme.dart';
import 'package:tumpeng/features/onboarding/app_entry.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TumpengApp());
}

class TumpengApp extends StatelessWidget {
  const TumpengApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Tumpeng',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: const AppEntry(),
  );
}
