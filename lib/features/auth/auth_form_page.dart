import 'package:flutter/material.dart';
import 'package:tumpeng/core/network/api_client.dart';
import 'package:tumpeng/core/theme/app_theme.dart';
import 'package:tumpeng/features/auth/google_auth_service.dart';
import 'package:tumpeng/features/dashboard/dashboard_page.dart';
import 'package:tumpeng/features/onboarding/user_role.dart';

class AuthFormPage extends StatefulWidget {
  const AuthFormPage({
    super.key,
    required this.role,
    required this.isRegister,
    this.googleOnly = false,
  });

  final UserRole role;
  final bool isRegister;
  final bool googleOnly;

  @override
  State<AuthFormPage> createState() => _AuthFormPageState();
}

class _AuthFormPageState extends State<AuthFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!widget.googleOnly && !(_formKey.currentState?.validate() ?? false))
      return;
    setState(() => _submitting = true);
    try {
      final api = await ApiClient.create();
      if (widget.googleOnly) {
        await GoogleAuthService().signInAndExchange(
          api,
          role: widget.role.apiValue,
        );
      } else {
        final action = widget.isRegister ? 'register' : 'login';
        await api.post<dynamic>(
          '/auth/${widget.role.apiValue}/$action',
          data: {
            if (widget.isRegister) 'name': _name.text.trim(),
            'email': _email.text.trim(),
            'password': _password.text,
          },
        );
      }
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => dashboardForRole(widget.role)),
        (route) => false,
      );
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                'Belum berhasil. Periksa koneksi dan konfigurasi akunmu.',
              ),
            ),
          );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.googleOnly
        ? 'Masuk dengan Google'
        : widget.isRegister
        ? 'Buat akun ${widget.role.label}'
        : 'Masuk sebagai ${widget.role.label}';
    return Scaffold(
      appBar: AppBar(title: Text(widget.role.label)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.role == UserRole.hero
                        ? 'Akun Hero digunakan untuk menemukan dan memesan menu.'
                        : 'Akun Mitra digunakan untuk mengelola usaha dan pesanan.',
                    style: const TextStyle(color: AppColors.secondaryText),
                  ),
                  if (!widget.googleOnly) ...[
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (widget.isRegister) ...[
                            TextFormField(
                              controller: _name,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                labelText: widget.role == UserRole.mitra
                                    ? 'Nama usaha / pemilik'
                                    : 'Nama lengkap',
                              ),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Nama wajib diisi.'
                                  : null,
                            ),
                            const SizedBox(height: 14),
                          ],
                          TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            validator: (value) {
                              if (value == null || !value.contains('@'))
                                return 'Masukkan email yang valid.';
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _password,
                            obscureText: true,
                            autofillHints: [
                              widget.isRegister
                                  ? AutofillHints.newPassword
                                  : AutofillHints.password,
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Kata sandi',
                            ),
                            validator: (value) =>
                                value == null || value.length < 8
                                ? 'Gunakan minimal 8 karakter.'
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            widget.googleOnly
                                ? 'Lanjutkan'
                                : widget.isRegister
                                ? 'Daftar'
                                : 'Masuk',
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
